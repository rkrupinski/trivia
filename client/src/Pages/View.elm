module Pages.View
    exposing
        ( init
        , update
        , Model
        , Msg
        )


type Model
    = Model {}


type Msg
    = Noop


init : ( Model, Cmd Msg )
init =
    Model
        {}
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    Model model ! []
