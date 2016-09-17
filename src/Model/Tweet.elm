module Model.Tweet
    exposing
        ( Tweet
        , TweetId
        , TweetGeo
        , TweetPlace
        , TweetUser
        , exampleTweet
        , jsonDecodeTweetString
        , toMarker
        )

import Json.Decode
import Json.Decode.Pipeline
import Model.GMaps exposing (Marker)


type alias TweetId = Int


type alias Tweet =
    { id : TweetId
    , text : String
    , geo : TweetGeo
    , place : TweetPlace
    , user : TweetUser
    , lang : String
    , entities : TweetEntities
    }


type alias TweetGeo =
    { type' : String
    , coordinates : List Float
    }


type alias TweetPlace =
    { id : String
    , place_type : String
    , name : String
    , country_code : String
    }


type alias TweetUser =
    { id : Int
    , id_str : String
    , name : String
    , screen_name : String
    , followers_count : Int
    , lang : String
    , profile_image_url_https : String
    }


type alias TweetEntities =
    { hashtags : List TweetHashtag
    }


type alias TweetHashtag =
    { text : String
    , indices : List Int
    }


toMarker : Tweet -> Marker
toMarker tweet =
  let
    lat = tweet.geo.coordinates |> List.head |> Maybe.withDefault 0
    lng = tweet.geo.coordinates |> List.drop 1 |> List.head |> Maybe.withDefault 0
  in
      { id = tweet.id
      , pos = { lat = lat, lng = lng }
      }


jsonDecodeTweetString : String -> Result String Tweet
jsonDecodeTweetString =
    Json.Decode.decodeString decodeTweet


decodeTweet : Json.Decode.Decoder Tweet
decodeTweet =
    Json.Decode.Pipeline.decode Tweet
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "geo" (decodeTweetGeo)
        |> Json.Decode.Pipeline.required "place" (decodeTweetPlace)
        |> Json.Decode.Pipeline.required "user" (decodeTweetUser)
        |> Json.Decode.Pipeline.required "lang" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "entities" (decodeTweetEntities)


decodeTweetGeo : Json.Decode.Decoder TweetGeo
decodeTweetGeo =
    Json.Decode.Pipeline.decode TweetGeo
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "coordinates" (Json.Decode.list Json.Decode.float)


decodeTweetPlace : Json.Decode.Decoder TweetPlace
decodeTweetPlace =
    Json.Decode.Pipeline.decode TweetPlace
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "place_type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "country_code" (Json.Decode.string)


decodeTweetUser : Json.Decode.Decoder TweetUser
decodeTweetUser =
    Json.Decode.Pipeline.decode TweetUser
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "id_str" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "screen_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "followers_count" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "lang" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "profile_image_url_https" (Json.Decode.string)


decodeTweetEntities : Json.Decode.Decoder TweetEntities
decodeTweetEntities =
    Json.Decode.Pipeline.decode TweetEntities
        |> Json.Decode.Pipeline.required "hashtags" (Json.Decode.list decodeTweetHashtag)


decodeTweetHashtag : Json.Decode.Decoder TweetHashtag
decodeTweetHashtag =
    Json.Decode.Pipeline.decode TweetHashtag
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "indices" (Json.Decode.list Json.Decode.int)


exampleTweet : Tweet
exampleTweet =
    { id = 527191454335397900
    , text = "Good luck on your quest to learn Redux!"
    , geo =
        { type' = "Point"
        , coordinates =
            [ 41.3802
            , 2.147794
            ]
        }
    , place =
        { id = "1a27537478dd8e38"
        , place_type = "city"
        , name = "London"
        , country_code = "UK"
        }
    , user =
        { id = 1421560482
        , id_str = "1421560482"
        , name = "Dan Abramov"
        , screen_name = "@DanAbramov"
        , followers_count = 26587
        , lang = "es"
        , profile_image_url_https = "https://pbs.twimg.com/profile_images/553711083064541184/9VsY9i09.jpeg"
        }
    , lang = "en"
    , entities =
        { hashtags = []
        }
    }
