{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module DB where

import qualified Control.Lens            as L
import           Control.Monad.Trans
import           Data.Aeson
import           Data.Aeson.Encoding
import qualified Data.ByteString.Lazy    as B
import           Data.HashMap.Strict
import           Data.Maybe
import           Data.Semigroup
import           Data.String
import           Data.Text
import           Data.Text.Lazy.Encoding
import           GHC.Generics
import           Model.Message
import           Model.Offering
import           Model.Student
import           Model.User
import           Network.Wreq
import qualified Web.Scotty              as S

newtype OfferingID = OfferingID Text

saveNewUser :: User -> S.ActionM (Maybe UserID)
saveNewUser user = saveNew "users" UserID user

getUser :: UserID -> S.ActionM (Maybe User)
getUser (UserID id) = getFromID "users/" id

getOffering :: OfferingID -> S.ActionM (Maybe Offering)
getOffering (OfferingID id) = getFromID "offerings/" id

saveNewOffering :: Offering -> S.ActionM (Maybe OfferingID)
saveNewOffering = saveNew "offerings" OfferingID

getMessage :: MessageID -> S.ActionM (Maybe Message)
getMessage (MessageID id) = getFromID "messages/" id


saveNewMessage :: Message -> S.ActionM (Maybe MessageID)
saveNewMessage = saveNew "messages" MessageID

-- * Generalized DB Functions

dbURL :: Text
dbURL = "https://beakr-mu.firebaseio.com/"

saveNew :: (ToJSON a)
        => Text          -- ^ endpoint ending with a forward slash
        -> (Text -> b)    -- ^ wrapper fun ction forTAGS
        -> a             -- ^ the thing to be saved
        -> S.ActionM (Maybe b) -- ^ the id after saving
saveNew endpoint f x = do
  let url = unpack (mconcat [dbURL, endpoint, ".json"])
  y <- lift $ post url (encode x)
  return $ fmap f $ decode (y L.^. responseBody)

getFromID :: (FromJSON a) => Text -> Text -> S.ActionM (Maybe a)
getFromID endpoint id = do
  x <- lift $ get $ unpack $ mconcat [dbURL, endpoint, id, ".json"]
  return $ decode $ (x L.^. responseBody)

getCategory :: Text -> S.ActionM [KeyVal]
getCategory c = do
  x <- lift $ get $ unpack $ mconcat [dbURL, c, ".json"]
  return $ convertToPairsList $ x L.^. responseBody


-- need to parse lists of objects from the DB with as a list of key value pairs as opposed to an object
-- They are of form {
--      key : {},
--      key : {},,
--      etc...
-- }

data KeyVal = KeyVal { id     :: Text
                     , object :: Value
                     } deriving (Show, Generic)

instance ToJSON KeyVal where

testJSON :: B.ByteString
testJSON = "{\"bob\": {\"name\": \"larry\"}, \"sally\": {\"name\": \"not sally\"}}"

testJSON2 :: B.ByteString
testJSON2 = "{\"name\":\"Dave\",\"age\":2}"

off :: Text
off = "offerings"

decodeToKVList :: B.ByteString -> [(Text, Value)]
decodeToKVList txt = toList $ fromJust $ decode txt

tupleToObject :: (Text, Value) -> KeyVal
tupleToObject (t, v) = KeyVal t v

convertToPairsList :: B.ByteString -> [KeyVal]
convertToPairsList txt = fmap tupleToObject $ decodeToKVList txt

