module Data.Question
    exposing
        ( Question
        , QuestionId
        , questionDecoder
        )

import Json.Decode as Decode
import Data.Answer exposing (Answer, answerDecoder)


type alias QuestionId =
    Int


type alias Question =
    { id : QuestionId
    , text : String
    , answers : List Answer
    }


questionDecoder : Decode.Decoder Question
questionDecoder =
    Decode.map3 Question
        (Decode.field "id" Decode.int)
        (Decode.field "text" Decode.string)
        (Decode.field "answers" <| Decode.list answerDecoder)
