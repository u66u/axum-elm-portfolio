module UI exposing (layout)

import Gen.Route as Route exposing (Route)
import Html exposing (Html, a, div, footer, h1, header, li, section, text, ul)
import Html.Attributes exposing (class, classList, href)


layout : String -> Route -> Html msg -> Html msg
layout title route children =
    section [ class "section" ]
        [ div [ class "container" ]
            [ viewHeader title route
            , children
            , viewFooter
            ]
        ]


viewHeader : String -> Route -> Html msg
viewHeader title current =
    let
        viewLink : String -> Route -> Html msg
        viewLink label route =
            li [ classList [ ( "is-active", route == current ) ] ]
                [ a [ href (Route.toHref route) ] [ text label ] ]
    in
    header []
        [ h1 [ class "title" ] [ text title ]
        , div [ class "tabs" ]
            [ ul []
                [ viewLink "Home" Route.Home_
                , viewLink "About" Route.About
                , viewLink "Skills" Route.Skill
                , viewLink "Experience" Route.Career
                , viewLink "Blog" Route.Blog
                ]
            ]
        ]

viewFooter : Html msg
viewFooter =
    footer [ class "footer" ]
        [ div [ class "content has-text-centered" ] [ text "footer" ] ]
