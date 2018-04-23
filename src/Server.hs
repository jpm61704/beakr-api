{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module Server where

import qualified Data.Aeson                  as J
import           Data.Maybe
import           Data.Text
import qualified Data.Text.Internal.Lazy     as TL
import           DB
import           GHC.Generics
import           Model.Message
import           Model.Offering
import           Model.Student
import           Model.User
import           Network.Wai.Middleware.Cors
import           Web.Scotty
import           Web.Scotty.Internal.Types

type Port = Int

server :: Port -> IO ()
server port = scotty port $ do
    middleware simpleCors
    getID "/user/:id" UserID getUser
    getAll "/users" "users"

    post "/student" $ do s' <- parseNewStudent
                         case s' of
                           Just u -> do
                             id <- saveNewUser u
                             return ()
                           Nothing -> return ()
                         json ()
    postNew "/offering" saveNewOffering
    getAll "/offerings" "offerings"

    postNew "/message" saveNewMessage
    getID "/message/:id" MessageID getMessage
    getAll "/messages" "messages"

postNew :: (J.FromJSON a, J.ToJSON b) => RoutePattern -> (a -> ActionM (Maybe b)) -> ScottyM ()
postNew route saveToDB = post route $ do
  b <- body
  let x = J.eitherDecode b :: (J.FromJSON a) => Either String a
  case x of
    Right n -> do
      id <- saveToDB n
      json id
    Left err -> json err

getAll :: RoutePattern -> Text -> ScottyM ()
getAll route cat = get route (getCategory cat >>= json)


getID :: (J.ToJSON b, J.FromJSON b) => RoutePattern -> (Text -> a) -> (a -> ActionM (Maybe b)) -> ScottyM ()
getID ourEndpoint idwrap getFromDB = get ourEndpoint $ do
  id <- param "id" :: ActionM Text
  x  <- getFromDB (idwrap id)
  json x


-- fix the explicit pattern match on just here
parseNewStudent :: ActionM (Maybe (User))
parseNewStudent = do b <- body
                     let Just (NewStudentData n email s m) = (J.decode b :: Maybe NewStudentData)
                         Just email' = parseEmail email
                     return $ Just (User n email' (Just (Student s m)) Nothing)

data NewStudentData = NewStudentData { name     :: Name,
                                       email    :: Text,
                                       standing :: Standing,
                                       major    :: Major
                                     } deriving (Show, Generic)

instance J.FromJSON NewStudentData where
