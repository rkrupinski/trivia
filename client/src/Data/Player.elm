module Data.Player
    exposing
        ( PlayerId
        , PlayerName
        , Joined
        , joinedDecoder
        )

import Json.Decode as Decode
import Request.Helpers exposing (rootDecoder)


type alias PlayerId =
    String


type alias PlayerName =
    String


type alias Joined =
    { playerId : PlayerId
    }


joinedDecoder : Decode.Decoder Joined
joinedDecoder =
    rootDecoder <|
        Decode.map Joined (Decode.field "player_id" Decode.string)
