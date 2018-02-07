module Model exposing (..)

import RemoteData exposing (RemoteData)
import GraphQL.Client.Http as GraphQLClient
import Element.Input as Input
import Ports exposing (InfoForElm)
import Utils exposing (Coordinates)


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
    , coordinates : Coordinates
    , searchAddress : Maybe String
    , address : Maybe String
    , city : Maybe String
    }


newRecording : Recording
newRecording =
    { id = "NEW"
    , author = Nothing
    , description = Nothing
    , theme = NoTheme
    , coordinates = { lat = 0, lng = 0 }
    , searchAddress = Nothing
    , address = Nothing
    , city = Nothing
    }


type alias RecordingId =
    String


type Field
    = Author
    | Description
    | SearchAddress


type Theme
    = Nature
    | History
    | Culture
    | NoTheme


themeToString : Theme -> String
themeToString theme =
    case theme of
        NoTheme ->
            "Aucun"

        Nature ->
            "Nature"

        History ->
            "Histoire"

        Culture ->
            "Culture"


themesList : List Theme
themesList =
    [ NoTheme, Nature, History, Culture ]


addressInputId : String
addressInputId =
    "address-input"
