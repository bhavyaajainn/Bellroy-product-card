module ProductCard exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, classList, style, src, alt, title)  -- Removed 'required' from here
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (required)  -- Renamed to avoid conflict
import Http


-- TYPES


type alias ColorOption =
    { name : String
    , hex : String
    , isAvailable : Bool
    }


type alias Product =
    { id : String
    , name : String
    , price : Float
    , currency : String
    , imageUrl : String
    , hoverImageUrl : String
    , colors : List ColorOption
    , description : String
    }


type alias Model =
    { product : Maybe Product
    , selectedColorIndex : Int
    , isHovering : Bool
    , loading : Bool
    , error : Maybe String
    }


type Msg
    = LoadProduct
    | ProductLoaded (Result Http.Error Product)
    | SelectColor Int
    | MouseEnter
    | MouseLeave


-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { product = Nothing
      , selectedColorIndex = 0
      , isHovering = False
      , loading = False
      , error = Nothing
      }
    , Cmd.none
    )


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadProduct ->
            ( { model | loading = True }, fetchProduct )

        ProductLoaded result ->
            case result of
                Ok product ->
                    ( { model | product = Just product, loading = False, error = Nothing }, Cmd.none )

                Err _ ->
                    ( { model | error = Just "Failed to load product", loading = False }, Cmd.none )

        SelectColor index ->
            ( { model | selectedColorIndex = index }, Cmd.none )

        MouseEnter ->
            ( { model | isHovering = True }, Cmd.none )

        MouseLeave ->
            ( { model | isHovering = False }, Cmd.none )


-- VIEW


view : Model -> Html Msg
view model =
    div [] [ text "Product Card Component (to be implemented)" ]


-- HTTP


fetchProduct : Cmd Msg
fetchProduct =
    -- We'll implement this in the next step
    Cmd.none


productDecoder : Decoder Product
productDecoder =
    Decode.succeed Product
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "price" Decode.float
        |> required "currency" Decode.string
        |> required "imageUrl" Decode.string
        |> required "hoverImageUrl" Decode.string
        |> required "colors" (Decode.list colorOptionDecoder)
        |> required "description" Decode.string


colorOptionDecoder : Decoder ColorOption
colorOptionDecoder =
    Decode.succeed ColorOption
        |> required "name" Decode.string
        |> required "hex" Decode.string
        |> required "isAvailable" Decode.bool