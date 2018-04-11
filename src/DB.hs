{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module DB where

import Network.Wreq
import Model.User
import Model.Student
import Model.Offering
import Data.Aeson
import Data.Aeson.Encoding
import qualified Control.Lens as L
import Data.String
import Data.Text.Lazy
import qualified Data.ByteString.Lazy as B
import qualified Web.Scotty as S
import Data.Semigroup
import Control.Monad.Trans
import Data.Text.Lazy.Encoding
import GHC.Generics

newtype UserID = UserID Text
newtype OfferingID = OfferingID Text

saveNewUser :: User -> S.ActionM (UserID)
saveNewUser user = saveNew "users" UserID user

getUser :: UserID -> S.ActionM (Maybe User)
getUser (UserID id) = getFromID "users/" id

getOffering :: OfferingID -> S.ActionM (Maybe Offering)
getOffering (OfferingID id) = getFromID "offerings/" id

saveNewOffering :: Offering -> S.ActionM (OfferingID)
saveNewOffering = saveNew "offerings" OfferingID

-- * Generalized DB Functions

dbURL :: Text
dbURL = "https://beakr-mu.firebaseio.com/"

saveNew :: (ToJSON a)
        => Text          -- ^ endpoint ending with a forward slash
        -> (Text -> b)    -- ^ wrapper function for resulting ID
        -> a             -- ^ the thing to be saved
        -> S.ActionM (b) -- ^ the id after saving
saveNew endpoint f x = do
  let url = unpack (mconcat [dbURL, endpoint, ".json"])
  y <- lift $ post url (encode x)
  return $ f $ decodeUtf8 (y L.^. responseBody)

getFromID :: (FromJSON a) => Text -> Text -> S.ActionM (Maybe a)
getFromID endpoint id = do
  x <- lift $ get $ unpack $ mconcat [dbURL, endpoint, id, ".json"]
  return $ decode $ (x L.^. responseBody)

