module Data.Game
    exposing
        ( Game
        , GameId
        , decoder
        )

import Json.Decode as Decode


type alias GameId =
    String


type alias Game =
    { id : GameId
    }


decoder : Decode.Decoder Game
decoder =
    Decode.map Game <| Decode.field "id" Decode.string
