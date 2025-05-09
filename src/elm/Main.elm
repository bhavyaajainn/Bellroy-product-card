module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Decode

-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { productName : String
    , price : String
    , isHovering : Bool
    , selectedColorIndex : Int
    , colors : List ColorOption
    }


type alias ColorOption =
    { name : String
    , hex : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { productName = "Bellroy Slim Wallet"
      , price = "$89.00"
      , isHovering = False
      , selectedColorIndex = 0
      , colors = 
          [ { name = "Black", hex = "#000000" }
          , { name = "Brown", hex = "#8B4513" }
          , { name = "Navy", hex = "#000080" }
          ]
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = MouseEnter
    | MouseLeave
    | SelectColor Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseEnter ->
            ( { model | isHovering = True }, Cmd.none )
            
        MouseLeave ->
            ( { model | isHovering = False }, Cmd.none )
            
        SelectColor index ->
            ( { model | selectedColorIndex = index }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "product-card" ]
        [ div [ class "product-image", 
                onMouseEnter MouseEnter,
                onMouseLeave MouseLeave
              ]
            [ img [ src (if model.isHovering 
                          then "https://bellroy.imgix.net/cms_images/2753/hover-image-placeholder.jpg" 
                          else "https://bellroy.imgix.net/cms_images/2752/image-placeholder.jpg"), 
                   alt "Product Image" ] []
            ]
        , div [ class "product-info" ]
            [ h3 [ class "product-name" ] [ text model.productName ]
            , p [ class "product-price" ] [ text model.price ]
            , div [ class "color-options" ] (List.indexedMap (viewColorOption model.selectedColorIndex) model.colors)
            ]
        ]


viewColorOption : Int -> Int -> ColorOption -> Html Msg
viewColorOption selectedIndex index color =
    div 
        [ class "color-option"
        , classList [("selected", selectedIndex == index)]
        , onClick (SelectColor index)
        , style "background-color" color.hex
        , title color.name
        ] []


onMouseEnter : msg -> Attribute msg
onMouseEnter msg =
    Html.Events.on "mouseenter" (Decode.succeed msg)


onMouseLeave : msg -> Attribute msg
onMouseLeave msg =
    Html.Events.on "mouseleave" (Decode.succeed msg)