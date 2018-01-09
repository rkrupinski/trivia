module Components.Summary
    exposing
        ( render
        )

import Html exposing (..)
import Material.Options as Options
import Material.Typography as Typography
import Material.Table as Table
import Data.Game exposing (Game)
import Data.Player exposing (Player, PlayerId)
import Data.Question exposing (Question, QuestionId)
import Data.Answers exposing (Answers)


render : Game -> Html never
render { players, questions, answers } =
    let
        headings : List String
        headings =
            computeHeadings players

        rows : List (List String)
        rows =
            computeRows questions answers

        footer : List String
        footer =
            computeFooter players answers
    in
        div []
            [ Options.styled p
                [ Typography.headline ]
                [ text "Game summary" ]
            , Table.table [ Options.css "whiteSpace" "normal" ]
                [ Table.thead []
                    [ renderRow renderHeading headings
                    ]
                , Table.tbody [] <| List.map (renderRow renderCell) rows
                , Table.tfoot []
                    [ renderRow renderCell footer
                    ]
                ]
            ]


computeHeadings : List Player -> List String
computeHeadings players =
    "Question" :: (List.map .name players)


computeRows : List Question -> List Answers -> List (List String)
computeRows questions answers =
    List.map
        (\{ text, id } ->
            text :: getAnswers id answers
        )
        questions


computeFooter : List Player -> List Answers -> List String
computeFooter players answers =
    "" :: List.map (\{ id } -> toString <| getCorrectCount id answers) players


getCorrectCount : PlayerId -> List Answers -> Int
getCorrectCount playerId answers =
    answers
        |> List.concatMap .players
        |> List.filter (\{ id, correct } -> id == playerId && correct)
        |> List.length


getAnswers : QuestionId -> List Answers -> List String
getAnswers id answers =
    List.filter (\{ question_id } -> id == question_id) answers
        |> List.head
        |> Maybe.map (\{ players } -> List.map (.correct >> formatAnswer) players)
        |> Maybe.withDefault []


getCellAttrs : Bool -> List (Options.Property c m)
getCellAttrs isFirst =
    let
        alignment : String
        alignment =
            case isFirst of
                True ->
                    "left"

                False ->
                    "center"
    in
        [ Options.css "textAlign" alignment ]


renderRow : (Bool -> String -> Html never) -> List String -> Html never
renderRow renderer cells =
    case cells of
        first :: rest ->
            Table.tr [] <| renderer True first :: List.map (renderer False) rest

        _ ->
            text ""


renderHeading : Bool -> String -> Html never
renderHeading isFirst body =
    Table.th (getCellAttrs isFirst) [ text body ]


renderCell : Bool -> String -> Html never
renderCell isFirst body =
    Table.td (getCellAttrs isFirst) [ text body ]


formatAnswer : Bool -> String
formatAnswer correct =
    case correct of
        True ->
            "👍"

        False ->
            "👎"
