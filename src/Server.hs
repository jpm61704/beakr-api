{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Server where

import Model.User
import Model.Student
import Web.Scotty
import Web.Scotty.Internal.Types
import Data.Text
import qualified Data.Text.Internal.Lazy as TL
import qualified Data.Aeson as J
import DB
import GHC.Generics

server :: IO ()
server = scotty 3000 $ do
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
