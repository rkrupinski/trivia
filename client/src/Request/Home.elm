module Request.Home exposing (newGame)

import Http
import HttpBuilder
import Data.Game as Game exposing (Game)


newGame : Http.Request Game
newGame =
    "https://httpbin.org/post"
        |> HttpBuilder.post
        |> HttpBuilder.withExpect (Http.expectJson Game.decoder)
        |> HttpBuilder.toRequest
