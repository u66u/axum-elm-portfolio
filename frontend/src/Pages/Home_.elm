module Pages.Home_ exposing (view)

import Gen.Route as Route
import Html exposing (Html, div, section, text)
import Html.Attributes exposing (class)
import View exposing (View)
import Html exposing (p)
import UI


view : View msg
view =
    { title = "axum-elm test app"
    , body = [ UI.layout "axum-elm test app" Route.Home_ content ]
    }

content : Html msg
content =
    section [ class "section is-large" ]
        [ div [ class "container" ]
            [ p [ class "title" ] [ text "Hello!" ]
            , p [ class "substitute" ] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" ]
            ]
        ]
