module Pages.Skill exposing (Model, Msg, page)

import Gen.Params.Skill exposing (Params)
import Gen.Route exposing (Route)
import Html exposing (Html, div, h3, p, text)
import Html.Attributes exposing (class)
import Http
import Config exposing (..)
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Page
import Request
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init
        , update = update
        , view = view "Axum-Elm-Portfolio | Skills" req.route
        , subscriptions = subscriptions
        }


type alias Model =
    { skills : List Skill }


type Msg
    = GotSkills (Result Http.Error (List Skill))


type alias Skill =
    { id : Int
    , title : String
    , content : String
    }


skillDecoder : Decoder Skill
skillDecoder =
    succeed Skill
        |> required "id" int
        |> required "title" string
        |> required "content" string


init : ( Model, Cmd Msg )
init =
    ( Model []
    , Http.get
        { url = backend_url ++ "/skills"
        , expect = Http.expectJson GotSkills (list skillDecoder)
        }
    )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotSkills result ->
            case result of
                Ok skills ->
                    ( { model | skills = skills }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


view : String -> Route -> Model -> View Msg
view title route model =
    { title = title
    , body = [ UI.layout title route <| body model ]
    }


body : Model -> Html Msg
body model =
    viewGrid model.skills


viewGrid : List Skill -> Html Msg
viewGrid skills =
    div [ class "section" ]
        (List.map viewBox skills)


viewBox : Skill -> Html Msg
viewBox skill =
    div [ class "box", class "content" ]
        [ h3 [] [ text skill.title ]
        , p [] [ text skill.content ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
