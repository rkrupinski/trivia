# Trivia

``docker-compose up``

- ``127.0.0.1:4000`` (backend/api)
- ``127.0.0.1:8000`` (client)

## Reset db and populate with questions 

``./mix ecto.reset``

## For creating object (e.g. game object):
```
{
    "game": {
        ..fields
    }
}
```