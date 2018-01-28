module Model exposing (..)

import RemoteData exposing (RemoteData)
import GraphQL.Client.Http as GraphQLClient
import Element.Input as Input


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
    | OpenCreateView
    | SelectTheme (Input.SelectMsg Theme)


type alias Model =
    { recordings : GraphQLData (List Recording)
    , page : Page
    , form : EditableData RecordingForm
    }


type EditableData a
    = NotEditing
    | Editing a
    | EditSubmitting a
    | EditRefused a
    | EditSaved


type alias RecordingForm =
    { recording : Recording
    , theme : Input.SelectWith Theme Msg
    }


type Page
    = ListPage
    | EditPage Recording


type alias GraphQLData a =
    RemoteData GraphQLClient.Error a


type alias Recording =
    { id : RecordingId
    , author : Maybe String
    , description : Maybe String
    , theme : Theme
    }


newRecording : Recording
newRecording =
    { id = "NEW"
    , author = Nothing
    , description = Nothing
    , theme = NoTheme
    }


type alias RecordingId =
    String


type Field
    = Author
    | Description


type Theme
    = Nature
    | History
    | Culture
    | NoTheme


themeToString : Theme -> String
themeToString theme =
    toString theme


themesList : List Theme
themesList =
    [ NoTheme, Nature, History, Culture ]
