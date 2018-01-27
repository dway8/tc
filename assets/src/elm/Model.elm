module Model exposing (..)

import RemoteData exposing (RemoteData)
import GraphQL.Client.Http as GraphQLClient


type Msg
    = NoOp
    | ReceiveQueryResponse (GraphQLData (List Recording))
    | EditRecording Recording
    | UpdateRecordingField Field String
    | SaveRecording
    | CancelEditing
    | SaveRecordingResponse (GraphQLData Recording)
    | DeleteRecording RecordingId
    | DeleteRecordingResponse (GraphQLData RecordingId)


type alias Model =
    { recordings : GraphQLData (List Recording)
    , page : Page
    , form : EditableData Recording
    }


type EditableData a
    = NotEditing
    | Editing a
    | EditSubmitting a
    | EditRefused a
    | EditSaved


type Page
    = ListPage
    | EditPage Recording


type alias GraphQLData a =
    RemoteData GraphQLClient.Error a


type alias Recording =
    { id : RecordingId
    , author : Maybe String
    , description : Maybe String
    }


type alias RecordingId =
    String


type Field
    = Author
    | Description
