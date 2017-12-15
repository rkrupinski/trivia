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
import Utils exposing (playUrl, formatError)


type alias PlayerName =
    String


type alias FormData =
    { playerName : PlayerName
    }


type Model
    = Model
        { gameId : GameId
        , playerForm : Form () FormData
        , pending : Bool
        }


type Msg
    = FormMsg Form.Msg



-- | Joined (Result Http.Error Joined)


init : GameId -> Model
init gameId =
    Model
        { gameId = gameId
        , playerForm = Form.initial [] validation
        , pending = False
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model ({ playerForm } as model)) =
    case msg of
        FormMsg formMsg ->
            let
                playerForm_ : Form () FormData
                playerForm_ =
                    Form.update validation formMsg playerForm
            in
                Model
                    { model
                        | playerForm = playerForm_
                    }
                    ! []


view : Model -> Html Msg
view (Model { playerForm }) =
    div []
        [ h1 [] [ text "Join game" ]
        , Html.map FormMsg <| renderForm playerForm
        ]


renderForm : Form () FormData -> Html Form.Msg
renderForm form =
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
            [ Input.textInput playerName []
            , text " "
            , button [] [ text "Join" ]
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
