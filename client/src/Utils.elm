module Utils exposing (..)

import Data.Game exposing (GameId)
import Data.Player exposing (PlayerId)
import Form.Error as Error


homeUrl : String
homeUrl =
    "#/"


gameUrl : GameId -> String
gameUrl gameId =
    "#/" ++ gameId


playUrl : GameId -> PlayerId -> String
playUrl gameId playerId =
    "#/" ++ gameId ++ "/" ++ playerId


formatError : String -> Error.ErrorValue e -> String
formatError fieldLabel error =
    case error of
        Error.Empty ->
            fieldLabel ++ " is required"

        Error.InvalidString ->
            -- ¯\_(ツ)_/¯
            fieldLabel ++ " is required"

        _ ->
            "Error"
