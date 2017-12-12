module Request.Home exposing (newGame)

import Http
import HttpBuilder
import Json.Encode as Encode
import Data.Game as Game exposing (Game)
import Request.Helpers exposing (apiUrl)


body : Encode.Value
body =
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
        |> HttpBuilder.withJsonBody body
        |> HttpBuilder.withExpect (Http.expectJson Game.decoder)
        |> HttpBuilder.toRequest
