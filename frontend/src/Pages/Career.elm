module Pages.Career exposing (Model, Msg, page)

import Gen.Params.Career exposing (Params)
import Gen.Route exposing (Route)
import Html exposing (Html, div, h2, p, text)
import Html.Attributes exposing (class)
import Http exposing (expectJson)
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Page
import Request
import Config exposing (..)
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init
        , update = update
        , view = view "Axum-Elm-Portfolio | Experience" req.route
        , subscriptions = subscriptions
        }


type alias Career =
    { id : Int
    , name : String
    , years_from : String
    , years_to : String
    , description : String
    }


type alias Model =
    { careers : List Career }


type Msg
    = GotCareers (Result Http.Error (List Career))


careerDecoder : Decoder Career
careerDecoder =
    succeed Career
        |> required "id" int
        |> required "name" string
        |> required "years_from" string
        |> required "years_to" string
        |> required "description" string


init : ( Model, Cmd Msg )
init =
    ( Model []
    , Http.get
        { url = backend_url ++ "/careers"
        , expect = expectJson GotCareers (list careerDecoder)
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCareers result ->
            case result of
                Ok careers ->
                    ( { model | careers = careers }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


view : String -> Route -> Model -> View Msg
view title route model =
    { title = title
    , body = [ UI.layout title route <| body model ]
    }


body : Model -> Html Msg
body model =
    viewCareers model.careers


viewCareers : List Career -> Html Msg
viewCareers careers =
    div [ class "section" ]
        (List.map viewCareer careers)


viewCareer : Career -> Html Msg
viewCareer career =
    div [ class "box", class "content" ]
        [ p [] [ text (career.years_from ++ "~" ++ career.years_to) ]
        , h2 [] [ text career.name ]
        , p [] [ text career.description ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
