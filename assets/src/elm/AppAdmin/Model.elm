module AppAdmin.Model exposing (..)

import AppAdmin.Ports exposing (InfoForElm)
import Element.Input as Input
import GraphQL.Client.Http as GraphQLClient
import Recording exposing (Recording, RecordingId, Theme)
import RemoteData exposing (RemoteData)


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
    | InfoFromOutside InfoForElm
    | LogError String


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


type Field
    = Author
    | Description
    | SearchAddress


type Page
    = ListPage
    | EditPage Recording


type alias GraphQLData a =
    RemoteData GraphQLClient.Error a


addressInputId : String
addressInputId =
    "address-input"
