module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl str =
    "http://0.0.0.0:4000/api/v1" ++ str
