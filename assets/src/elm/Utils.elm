module Utils exposing (..)

import Task


emitMsg : msg -> Cmd msg
emitMsg msg =
    msg
        |> Task.succeed
        |> Task.perform identity