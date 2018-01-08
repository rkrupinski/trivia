module Components.JoinGame
    exposing
        ( Model
        , Msg
        , init
        , view
        , update
        )

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Http
import Material
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options
import Material.Typography as Typography
import Navigation
import Form exposing (Form)
import Form.Validate as Validate
import ElmFormMdl.Form.Material exposing (textfield, submitButton)
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
        , mdl : Material.Model
        }


type Msg
    = FormMsg Form.Msg
    | Joined (Result Http.Error Joined)
    | Mdl (Material.Msg Msg)


init : GameId -> Model
init gameId =
    Model
        { gameId = gameId
        , playerForm = Form.initial [] validation
        , pending = False
        , mdl = Material.model
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model ({ gameId, playerForm, pending } as model)) =
    case msg of
        FormMsg formMsg ->
            case ( formMsg, Form.getOutput playerForm, pending ) of
                ( Form.Submit, Just { playerName }, False ) ->
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

        Mdl mdlMsg ->
            let
                ( model_, cmd ) =
                    Material.update Mdl mdlMsg model
            in
                Model model_ ! [ cmd ]


view : Model -> Html Msg
view (Model { playerForm, pending, mdl }) =
    div []
        [ Options.styled p
            [ Typography.headline ]
            [ text "Join game" ]
        , renderForm mdl playerForm pending
        ]


renderForm : Material.Model -> Form () FormData -> Bool -> Html Msg
renderForm mdl form pending =
    let
        playerName : Form.FieldState () String
        playerName =
            Form.getFieldAsString "playerName" form
    in
        Html.form
            [ onSubmit (FormMsg Form.Submit) ]
            [ textfield
                FormMsg
                Mdl
                formatError
                mdl
                playerName
                [ Textfield.label "Player name"
                , Options.css "marginRight" "1em"
                , Options.css "width" "10em"
                , Options.disabled pending
                ]
            , submitButton
                FormMsg
                Mdl
                mdl
                [ Button.ripple
                , Button.colored
                , Button.raised
                , Options.disabled pending
                ]
                [ text "Join" ]
            ]


validation : Validate.Validation () FormData
validation =
    Validate.map
        FormData
        (Validate.field "playerName"
            Validate.string
            |> Validate.andThen Validate.nonEmpty
        )
