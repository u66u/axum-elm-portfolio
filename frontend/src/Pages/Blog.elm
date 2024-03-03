module Pages.Blog exposing (Model, Msg, page)

import Gen.Params.Blog exposing (Params)
import Gen.Route exposing (Route)
import Html exposing (Html, div, h3, p, text, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, int, list, string)
import Page
import Request
import Shared
import UI
import Config
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init
        , update = update
        , view = view "Axum-Elm-Portfolio | Blog" req.route
        , subscriptions = subscriptions
        }


type alias Model =
    { posts : List BlogPost }


type Msg
    = GotPosts (Result Http.Error (List BlogPost))


type alias BlogPost =
    { id : Int
    , title : String
    , content : String
    }


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


init : ( Model, Cmd Msg )
init =
    ( Model []
    , Http.get
        { url = Config.backend_url ++ "/blog"
        , expect = Http.expectJson GotPosts (list blogPostDecoder)
        }
    )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotPosts result ->
            case result of
                Ok posts ->
                    ( { model | posts = posts }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


view : String -> Route -> Model -> View Msg
view title route model =
    { title = title
    , body = [ UI.layout title route <| body model ]
    }


body : Model -> Html Msg
body model =
    viewGrid model.posts


viewGrid : List BlogPost -> Html Msg
viewGrid posts =
    div [ class "section" ]
        (List.map viewBox posts)


viewBox : BlogPost -> Html Msg
viewBox post =
    let
        truncatedContent =
            if String.length post.content > 200 then
                String.left 200 post.content ++ "..."
            else
                post.content

        -- Create the link to the individual blog post page
        postUrl =
            "/blog/" ++ String.fromInt post.id
    in
    div [ class "box", class "content" ]
        [ h3 [] [ text post.title ]
        , p [] [ text truncatedContent ]
        , a [ href postUrl, class "button" ] [ text "Read More" ]
        ]

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
