module Request.Game
    exposing
        ( newGame
        , gameData
        )

import Http
import HttpBuilder
import Json.Encode as Encode
import Data.Game exposing (Game, GameId, gameDecoder)
import Request.Helpers exposing (apiUrl)


newGameTmpBody : Encode.Value
newGameTmpBody =
    Encode.object
        [ ( "game"
          , Encode.object
                [ ( "status", Encode.string "opened" )
                ]
          )
        ]


newGame : Http.Request Game
newGame =
    "/games"
        |> apiUrl
        |> HttpBuilder.post
        |> HttpBuilder.withJsonBody newGameTmpBody
        |> HttpBuilder.withExpect (Http.expectJson gameDecoder)
        |> HttpBuilder.toRequest


gameData : GameId -> Http.Request Game
gameData gameId =
    "/games/"
        |> flip (++) gameId
        |> apiUrl
        |> HttpBuilder.get
        |> HttpBuilder.withExpect (Http.expectJson gameDecoder)
        |> HttpBuilder.toRequest
