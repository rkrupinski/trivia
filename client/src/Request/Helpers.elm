module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl str =
    "http://localhost:4000/api/v1" ++ str
