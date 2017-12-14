module Data.Game
    exposing
        ( Game
        , GameId
        , GameStatus
        , gameDecoder
        )

import Json.Decode as Decode
import Request.Helpers exposing (rootDecoder)


type alias GameId =
    String


type alias Game =
    { id : GameId
    , can_join : Bool
    , status : GameStatus
    }


type GameStatus
    = Opened


statusFromString : String -> Decode.Decoder GameStatus
statusFromString statusStr =
    case statusStr of
        "opened" ->
            Decode.succeed Opened

        _ ->
            Decode.fail <| "Invalid status: " ++ statusStr


statusDecoder : Decode.Decoder GameStatus
statusDecoder =
    Decode.string
        |> Decode.andThen statusFromString


gameDecoder : Decode.Decoder Game
gameDecoder =
    rootDecoder <|
        Decode.map3 Game
            (Decode.field "id" Decode.string)
            (Decode.field "can_join" Decode.bool)
            (Decode.field "status" statusDecoder)
