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


formatError : Maybe (Error.ErrorValue e) -> String
formatError maybeError =
    case maybeError of
        Just (Error.Empty) ->
            "Required"

        Just (Error.InvalidString) ->
            "Invalid value"

        _ ->
            ""
