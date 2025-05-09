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
    , colors : List ColorOption
    }

type alias ColorOption =
    { name : String
    , hex : String
    , imageUrl : String
    , hoverImageUrl : String
    , selected : Bool
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { product = 
        { name = "Transit Workpack 20L"
        , subtitle = "Second Edition"
        , price = "$179"
        , colors = 
            [ { name = "Bronze", 
                hex = "#8B4513", 
                imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-BRZ-213/0?auto=format&fit=crop&w=1500&h=1500",
                hoverImageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-BRZ-213/1?auto=format&fit=crop&w=1500&h=1500", 
                selected = True }
            , { name = "Black", 
                hex = "#333333", 
                imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-BLK-215/0?auto=format&fit=crop&w=750&h=750",
                hoverImageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-BLK-215/1?auto=format&fit=crop&w=750&h=750", 
                selected = False }
            , { name = "Navy", 
                hex = "#1a2b4a", 
                imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-NSK-213/0?auto=format&fit=crop&w=750&h=750",
                hoverImageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-NSK-213/1?auto=format&fit=crop&w=750&h=750", 
                selected = False }
            , { name = "Olive", 
                hex = "#4A5D4E", 
                imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-OLI-215/0?auto=format&fit=crop&w=750&h=750",
                hoverImageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-OLI-215/1?auto=format&fit=crop&w=750&h=750", 
                selected = False }
            , { name = "Stone", 
                hex = "#d7d1c5", 
                imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-STO-215/0?auto=format&fit=crop&w=750&h=750",
                hoverImageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-STO-215/1?auto=format&fit=crop&w=750&h=750", 
                selected = False }
            ]
        }
      , selectedColorIndex = 0  -- Bronze is selected by default (index 0)
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
                |> Maybe.withDefault { name = "", hex = "", imageUrl = "", hoverImageUrl = "", selected = False }
                
        currentImageUrl = 
            if model.isHovering then
                selectedColor.hoverImageUrl
            else
                selectedColor.imageUrl
    in
    div [ class "product-card" ]
        [ div 
            [ class "product-image-container"
            , onMouseEnter MouseEnter
            , onMouseLeave MouseLeave
            ]
            [ img 
                [ src currentImageUrl
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