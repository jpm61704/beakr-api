{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Model.Department where

import Data.Aeson
import Data.Text
import Data.String
import Control.Applicative
import GHC.Generics
import Model.Student

data Department = Department { name :: Text
                             , majors :: [Major]
                             } deriving (Show, Generic)

instance ToJSON Department where

instance FromJSON Department where

