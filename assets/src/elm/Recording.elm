module Recording exposing (..)

import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder exposing (..)
import RemoteData
import Task exposing (Task)
import Utils exposing (Coordinates)


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


getAuthor : Recording -> String
getAuthor rec =
    Maybe.withDefault "" rec.author


getDescription : Recording -> String
getDescription rec =
    Maybe.withDefault "" rec.description


fetchRecordingsQuery : Request Query (List Recording)
fetchRecordingsQuery =
    extract
        (field "recordings"
            []
            (list recordingSpec)
        )
        |> queryDocument
        |> request
            {}


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "/api" request


recordingSpec : ValueSpec NonNull ObjectType Recording vars
recordingSpec =
    object Recording
        |> with (field "id" [] string)
        |> with (field "author" [] (nullable string))
        |> with (field "description" [] (nullable string))
        |> with
            (field "theme"
                []
                (extract (field "name" [] themeSpec))
            )
        |> with
            (field "coordinates"
                []
                (object Coordinates
                    |> with (field "lat" [] float)
                    |> with (field "lng" [] float)
                )
            )
        |> with (field "searchAddress" [] (nullable string))
        |> with (field "address" [] (nullable string))
        |> with (field "city" [] (nullable string))


themeSpec : ValueSpec NonNull EnumType Theme vars
themeSpec =
    enumWithDefault (always NoTheme)
        [ ( "Nature", Nature )
        , ( "Histoire", History )
        , ( "Culture", Culture )
        ]
