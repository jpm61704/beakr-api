{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module Model.User where


import           Control.Applicative
import           Data.Aeson
import           Data.Text
import           GHC.Generics
import Model.Student
import Model.Faculty

-- * User datatype

data User = User { name  :: Name
                 , email :: Email
                 , student :: Maybe Student
                 , faculty :: Maybe Faculty
                 } deriving (Show, Generic)

instance FromJSON User where

instance ToJSON User where

user = User (Name "Jack" (Just "Paul") "Martin") (Email "jpm61704" "gmail.com") (Just (Student Senior (Major "Computer Science"))) Nothing


-- ** Name datatype


data Name = Name { firstName  :: Text
                 , middleName :: Maybe Text
                 , lastName   :: Text } deriving (Show, Generic)

instance FromJSON Name where

instance ToJSON Name where

-- ** Email datatype

data Email = Email { username :: Text
                   , domain   :: Text } deriving (Show, Generic)

instance FromJSON Email where

instance ToJSON Email where

parseEmail :: Text -> Maybe Email
parseEmail x = case splitOn "@" x of
  (u:d:[]) -> Just $ Email u d
  _        -> Nothing
