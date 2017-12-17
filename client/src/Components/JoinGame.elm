module Components.JoinGame
    exposing
        ( Model
        , Msg
        , init
        , view
        , update
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Http
import Navigation
import Form exposing (Form)
import Form.Validate as Validate
import Form.Input as Input
import Data.Game exposing (GameId)
import Data.Player exposing (Joined)
import Request.Game exposing (joinGame)
import Utils exposing (playUrl, formatError, playUrl)


type alias FormData =
    { playerName : String
    }


type Model
    = Model
        { gameId : GameId
        , playerForm : Form () FormData
        , pending : Bool
        }


type Msg
    = FormMsg Form.Msg
    | Joined (Result Http.Error Joined)


init : GameId -> Model
init gameId =
    Model
        { gameId = gameId
        , playerForm = Form.initial [] validation
        , pending = False
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model ({ gameId, playerForm } as model)) =
    case msg of
        FormMsg formMsg ->
            case ( formMsg, Form.getOutput playerForm ) of
                ( Form.Submit, Just { playerName } ) ->
                    Model
                        { model
                            | pending = True
                        }
                        ! [ Http.send Joined <| joinGame gameId playerName ]

                _ ->
                    Model
                        { model
                            | playerForm = Form.update validation formMsg playerForm
                        }
                        ! []

        Joined (Ok { playerId }) ->
            Model
                { model
                    | pending = False
                }
                ! [ Navigation.newUrl <| playUrl gameId playerId ]

        Joined (Err err) ->
            -- TODO: Error handling
            Model
                { model
                    | pending = False
                }
                ! []


view : Model -> Html Msg
view (Model { playerForm, pending }) =
    div []
        [ h1 [] [ text "Join game" ]
        , Html.map FormMsg <| renderForm playerForm pending
        ]


renderForm : Form () FormData -> Bool -> Html Form.Msg
renderForm form pending =
    let
        renderErrorFor field =
            case field.liveError of
                Just error ->
                    p [] [ text <| formatError "Player name" error ]

                Nothing ->
                    text ""

        playerName : Form.FieldState () String
        playerName =
            Form.getFieldAsString "playerName" form
    in
        Html.form
            [ onSubmit Form.Submit ]
            [ Input.textInput playerName
                [ placeholder "Player name"
                , disabled pending
                ]
            , button [ disabled pending ] [ text "Join" ]
            , br [] []
            , renderErrorFor playerName
            ]


validation : Validate.Validation () FormData
validation =
    Validate.map
        FormData
        (Validate.field "playerName"
            Validate.string
            |> Validate.andThen Validate.nonEmpty
        )
