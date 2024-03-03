module Pages.Blog.Id_ exposing (Model, Msg, page)

import Gen.Params.Blog.Id_ exposing (Params)
import Gen.Route exposing (Route)
import Html exposing (Html, div, h1, h2, p, text)
import Html.Attributes exposing (class)
import Http
import Page
import Config exposing (..)
import UI
import Request
import Shared
import View exposing (View)
import Json.Decode exposing (Decoder, field, int, list, string)


type alias Model =
    { post : Maybe BlogPost
    , error : Maybe String
    }


type Msg
    = GotPost (Result Http.Error BlogPost)


type alias BlogPost =
    { id : Int
    , title : String
    , content : String
    }



viewPost : BlogPost -> Html Msg
viewPost blog =
    div [ class "box", class "content" ]
        [ h2 [] [ text blog.content ]
        , p [] [ text blog.title]
        ]


body : Model -> Html Msg
body model =
    case model.post of
        Just post ->
            viewPost post

        Nothing ->
            text "No post available."


blogPostDecoder : Decoder BlogPost
blogPostDecoder =
    field "id" int
        |> Json.Decode.andThen (\id ->
            field "name" string
                |> Json.Decode.andThen (\title ->
                    field "content" string
                        |> Json.Decode.map (\content ->
                            BlogPost id title content
                        )
                )
        )



page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init req.params
        , update = update
        , view = view req.route
        , subscriptions = \_ -> Sub.none
        }


init : Params -> ( Model, Cmd Msg )
init params =
    ( { post = Nothing, error = Nothing }
    , Http.get
        { url = backend_url ++ "/blog/" ++ params.id
        , expect = Http.expectJson GotPost blogPostDecoder
        }
    )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotPost result ->
            case result of
                Ok post ->
                    ( { model | post = Just post }, Cmd.none )
                Err _ ->
                    ( { model | error = Just "Failed to fetch the post." }, Cmd.none )


view : Route -> Model -> View Msg
view route model =
    case model.post of
        Just post ->
            { title = post.title
            , body = [ UI.layout post.title route <| body model ]
            }
        Nothing ->
            { title = "Loading..."
            , body = [ text "Loading blog post..." ]
            }


blogPostView : BlogPost -> Html msg
blogPostView post =
    div []
        [ h1 [] [ text post.title ]
        , p [] [ text post.content ]
        ]
