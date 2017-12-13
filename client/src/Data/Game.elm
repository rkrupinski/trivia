module Data.Game
    exposing
        ( Game
        , GameId
        , gameDecoder
        )

import Json.Decode as Decode
import Request.Helpers exposing (rootDecoder)


type alias GameId =
    String


type alias Game =
    { id : GameId
    }


gameDecoder : Decode.Decoder Game
gameDecoder =
    rootDecoder <|
        Decode.map Game <|
            Decode.field "id" Decode.string
