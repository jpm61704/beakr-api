{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Model.Offering where 
 
import Data.Aeson
import Data.Text
import Data.String
import Control.Applicative
import GHC.Generics
import Model.Student

data Offering = Offering { title :: Text
                         , summary :: Text
                         , detailedDescription :: Text
                         , compensation :: Compensation
                         , available :: Bool
                         , majors :: [Major]
                         } deriving (Show, Generic)

instance ToJSON Offering where

instance FromJSON Offering where

data Compensation = Hourly Double
                  | Grant Double
                  deriving (Show, Generic)

instance ToJSON Compensation where

instance FromJSON Compensation where 
