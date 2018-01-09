module Data.Game
    exposing
        ( Game
        , GameId
        , GameStatus(..)
        , gameDecoder
        )

import Json.Decode as Decode
import Request.Helpers exposing (rootDecoder)
import Data.Player exposing (Player, playerDecoder)
import Data.Question exposing (Question, questionDecoder)
import Data.Answers exposing (Answers, answersDecoder)


type alias GameId =
    String


type alias Game =
    { id : GameId
    , can_join : Bool
    , playing : Bool
    , status : GameStatus
    , players : List Player
    , questions : List Question
    , answers : List Answers
    }


type GameStatus
    = Started
    | Finished


statusFromString : String -> Decode.Decoder GameStatus
statusFromString statusStr =
    case statusStr of
        "started" ->
            Decode.succeed Started

        "finished" ->
            Decode.succeed Finished

        _ ->
            Decode.fail <| "Invalid status: " ++ statusStr


statusDecoder : Decode.Decoder GameStatus
statusDecoder =
    Decode.string
        |> Decode.andThen statusFromString


gameDecoder : Decode.Decoder Game
gameDecoder =
    rootDecoder <|
        Decode.map7 Game
            (Decode.field "id" Decode.string)
            (Decode.field "can_join" Decode.bool)
            (Decode.field "playing" Decode.bool)
            (Decode.field "status" statusDecoder)
            (Decode.field "players" <| Decode.list playerDecoder)
            (Decode.field "questions" <| Decode.list questionDecoder)
            (Decode.field "answers" <| Decode.list answersDecoder)
