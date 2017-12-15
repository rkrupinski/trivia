module Data.Player
    exposing
        ( PlayerId
        , Joined
        )


type alias PlayerId =
    String


type alias Joined =
    { playerId : PlayerId
    }
