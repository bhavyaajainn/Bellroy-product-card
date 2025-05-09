module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { product : Product
    , selectedColorIndex : Int
    , showInsideView : Bool
    }

type alias Product =
    { name : String
    , subtitle : String
    , price : String
    , colors : List ColorOption
    , insideImageUrl : String
    }

type alias ColorOption =
    { name : String
    , hex : String
    , imageUrl : String
    , selected : Bool
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { product =
            { name = "Transit Workpack 20L"
            , subtitle = "Second Edition"
            , price = "$179"
            , insideImageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-STO-215/2?auto=format&fit=max&w=1500"
            , colors =
                [ { name = "Black", hex = "#333333", imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-BLK-215/0?auto=format&fit=crop&w=750&h=750", selected = True }
                , { name = "Navy", hex = "#1a2b4a", imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-NSK-213/0?auto=format&fit=crop&w=750&h=750", selected = False }
                , { name = "Olive", hex = "#4A5D4E", imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-OLI-215/0?auto=format&fit=crop&w=750&h=750", selected = False }
                , { name = "Bronze", hex = "#b36d3e", imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-BRZ-213/0?auto=format&fit=crop&w=1500&h=1500", selected = False }
                , { name = "Stone", hex = "#d7d1c5", imageUrl = "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BTWB-STO-215/0?auto=format&fit=crop&w=750&h=750", selected = False }
                ]
            }
      , selectedColorIndex = 0
      , showInsideView = False
      }
    , Cmd.none
    )


type Msg
    = SelectColor Int
    | ToggleInsideView


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectColor index ->
            ( { model | selectedColorIndex = index, showInsideView = False }, Cmd.none )

        ToggleInsideView ->
            ( { model | showInsideView = not model.showInsideView }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        selectedColor =
            model.product.colors
                |> List.indexedMap (\idx color -> if idx == model.selectedColorIndex then Just color else Nothing)
                |> List.filterMap identity
                |> List.head
                |> Maybe.withDefault { name = "", hex = "", imageUrl = "", selected = False }

        currentImageUrl =
            if model.showInsideView then
                model.product.insideImageUrl
            else
                selectedColor.imageUrl
    in
    div [ class "product-card" ]
        [ div [ class "product-image-container" ]
            [ img [ src currentImageUrl, class "product-image", alt model.product.name ] []
            , div [ class "toggle-view-button-container" ]
                [ button
                    [ class (if model.showInsideView then "close-button" else "show-inside-button")
                    , onClick ToggleInsideView
                    ]
                    [ text (if model.showInsideView then "CLOSE" else "SHOW INSIDE")
                    , span [ class "button-icon" ] [ text (if model.showInsideView then "×" else "+") ]
                    ]
                ]
            ]
        , div [ class "product-info" ]
            [ h3 [ class "product-title" ]
                [ text model.product.name
                , span [ class "product-subtitle" ] [ text (" – " ++ model.product.subtitle) ]
                ]
            , p [ class "product-price" ] [ text model.product.price ]
            , div [ class "color-options" ]
                (List.indexedMap (\i c -> viewColorOption i c (i == model.selectedColorIndex)) model.product.colors)
            , div [ class "product-description" ]
                [ text "20L, 16\" laptop / A versatile backpack for work" ]
            ]
        ]


viewColorOption : Int -> ColorOption -> Bool -> Html Msg
viewColorOption index color isSelected =
    div
        [ class "color-option-container"
        , onClick (SelectColor index)
        ]
        [ if isSelected then
            div
                [ class "color-ring"
                , style "border-color" color.hex
                ]
                [ div
                    [ class "color-dot"
                    , style "background-color" color.hex
                    ]
                    []
                ]
          else
            div
                [ class "color-full"
                , style "background-color" color.hex
                ]
                []
        ]
