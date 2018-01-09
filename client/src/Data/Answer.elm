module Data.Answer
    exposing
        ( Answer
        , answerDecoder
        )

import Json.Decode as Decode


type alias Answer =
    { id : Int
    , text : String
    }


answerDecoder : Decode.Decoder Answer
answerDecoder =
    Decode.map2 Answer
        (Decode.field "id" Decode.int)
        (Decode.field "text" Decode.string)
