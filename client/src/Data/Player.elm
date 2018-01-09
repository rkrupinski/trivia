module Data.Player
    exposing
        ( PlayerId
        , PlayerName
        , Player
        , Joined
        , playerDecoder
        , joinedDecoder
        )

import Json.Decode as Decode
import Request.Helpers exposing (rootDecoder)


type alias PlayerId =
    String


type alias PlayerName =
    String


type alias Player =
    { id : PlayerId
    , name : PlayerName
    }


type alias Joined =
    { playerId : PlayerId
    }


playerDecoder : Decode.Decoder Player
playerDecoder =
    Decode.map2 Player
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)


joinedDecoder : Decode.Decoder Joined
joinedDecoder =
    rootDecoder <|
        Decode.map Joined (Decode.field "player_id" Decode.string)
