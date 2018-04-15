{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Server where

import Model.User
import Model.Student
import Model.Offering
import Web.Scotty
import Web.Scotty.Internal.Types
import Data.Text
import qualified Data.Text.Internal.Lazy as TL
import qualified Data.Aeson as J
import DB
import GHC.Generics

type Port = Int

server :: Port -> IO ()
server port = scotty port $ do
    get "/user/:id" $ do
      id <- param "id" :: ActionM TL.Text
      u <- getUser (UserID id)
      json u
    post "/student" $ do s' <- parseNewStudent
                         case s' of
                           Just u -> do
                             id <- saveNewUser u
                             return ()
                           Nothing -> return ()
                         json ()
    post "/offering" $ do
      b <- body
      let Just off = J.decode b :: Maybe Offering
      id <- saveNewOffering off
      json ()
    get "/offerings" (getCategory "offerings" >>= json)


-- fix the explicit pattern match on just here
parseNewStudent :: ActionM (Maybe (User))
parseNewStudent = do b <- body
                     let Just (NewStudentData n email s m) = (J.decode b :: Maybe NewStudentData)
                         Just email' = parseEmail email
                     return $ Just (User n email' (Just (Student s m)) Nothing)

data NewStudentData = NewStudentData { name :: Name,
                                       email :: Text,
                                       standing :: Standing,
                                       major :: Major
                                     } deriving (Show, Generic)

instance J.FromJSON NewStudentData where 
