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
    { product : Product
    , selectedColorIndex : Int
    , isHovering : Bool
    }

type alias Product =
    { name : String
    , subtitle : String
    , price : String
    , imageUrl : String
    , hoverImageUrl : String
    , colors : List ColorOption
    }

type alias ColorOption =
    { name : String
    , hex : String
    , selected : Bool
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { product = 
        { name = "Transit Workpack 20L"
        , subtitle = "Second Edition"
        , price = "$179"
        , imageUrl = "https://bellroy.imgix.net/cms_images/7325/transit-workpack-20l-SE-amber-hero-1_1.jpg"
        , hoverImageUrl = "https://bellroy.imgix.net/cms_images/7326/transit-workpack-20l-SE-amber-hero-2_1.jpg"
        , colors = 
            [ { name = "Black", hex = "#333333", selected = False }
            , { name = "Navy", hex = "#1a2b4a", selected = False }
            , { name = "Ranger Green", hex = "#4A5D4E", selected = False }
            , { name = "Amber", hex = "#bf6e3b", selected = True }
            , { name = "Limestone", hex = "#d7d1c5", selected = False }
            ]
        }
      , selectedColorIndex = 3  -- Amber is selected by default (index 3)
      , isHovering = False
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
    let
        selectedColor = 
            model.product.colors
                |> List.indexedMap (\idx color -> if idx == model.selectedColorIndex then Just color else Nothing)
                |> List.filterMap identity
                |> List.head
                |> Maybe.withDefault { name = "", hex = "", selected = False }
    in
    div [ class "product-card" ]
        [ div 
            [ class "product-image-container"
            , onMouseEnter MouseEnter
            , onMouseLeave MouseLeave
            ]
            [ img 
                [ src (if model.isHovering then model.product.hoverImageUrl else model.product.imageUrl)
                , class "product-image"
                , alt model.product.name
                ] 
                []
            ]
        , div [ class "product-info" ]
            [ div [ class "product-title" ]
                [ h3 [ class "product-name" ] [ text model.product.name ]
                , span [ class "product-subtitle" ] [ text model.product.subtitle ]
                ]
            , p [ class "product-price" ] [ text model.product.price ]
            , div [ class "color-options" ] 
                (List.indexedMap 
                    (\idx color -> 
                        viewColorOption idx color (idx == model.selectedColorIndex)
                    ) 
                    model.product.colors
                )
            , div [ class "product-description" ]
                [ text "20L, 16\" laptop / A versatile backpack for work" ]
            ]
        ]

viewColorOption : Int -> ColorOption -> Bool -> Html Msg
viewColorOption index color isSelected =
    div 
        [ class "color-option-wrapper"
        , onClick (SelectColor index)
        ]
        [ div 
            [ class "color-option"
            , classList [("selected", isSelected)]
            , style "background-color" color.hex
            , title color.name
            ] 
            []
        ]

onMouseEnter : msg -> Attribute msg
onMouseEnter msg =
    Html.Events.on "mouseenter" (Decode.succeed msg)

onMouseLeave : msg -> Attribute msg
onMouseLeave msg =
    Html.Events.on "mouseleave" (Decode.succeed msg)