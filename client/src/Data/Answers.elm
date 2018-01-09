module Data.Answers
    exposing
        ( Answers
        , answersDecoder
        )

import Json.Decode as Decode
import Data.Question exposing (QuestionId)
import Data.Player exposing (PlayerId)


type alias Answers =
    { question_id : QuestionId
    , players : List PlayerAnswer
    }


type alias PlayerAnswer =
    { id : PlayerId
    , correct : Bool
    }


playerAnswerDecoder : Decode.Decoder PlayerAnswer
playerAnswerDecoder =
    Decode.map2 PlayerAnswer
        (Decode.field "id" Decode.string)
        (Decode.field "correct" Decode.bool)


answersDecoder : Decode.Decoder Answers
answersDecoder =
    Decode.map2 Answers
        (Decode.field "question_id" Decode.int)
        (Decode.field "players" <| Decode.list playerAnswerDecoder)
