{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module Model.Student where

import           Control.Applicative
import           Data.Aeson
import           Data.String
import           Data.Text
import           GHC.Generics

-- * user datatype

data Student = Student { standing :: Standing
                       , major    :: Major
                       } deriving (Show, Generic)

data Standing = Freshman | Sophomore | Junior | Senior | SeniorPlus deriving (Show, Generic)

data Major = Major Text deriving (Show, Generic)


instance FromJSON Student where

instance ToJSON Student where

instance FromJSON Standing where

instance ToJSON Standing where

instance ToJSON Major where

instance FromJSON Major where
