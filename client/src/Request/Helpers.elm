module Request.Helpers
    exposing
        ( apiUrl
        , rootDecoder
        )

import Json.Decode as Decode


apiUrl : String -> String
apiUrl str =
    "http://localhost:4000/api/v1" ++ str


rootDecoder : Decode.Decoder a -> Decode.Decoder a
rootDecoder =
    Decode.field "data"
