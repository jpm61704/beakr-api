{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Model.Offering where

import Data.Aeson
import Data.Text
import Data.String
import Control.Applicative
import GHC.Generics
import Model.Student
import Model.Tag
import Data.Time

data Offering = Offering { title :: Text
                         , summary :: Text
                         , detailedDescription :: Text
                         , compensation :: Double
                         , available :: Bool
                         , majors :: [Major]
--                         , length :: OfferingLength
                         , tags :: [Tag]
                         } deriving (Show, Generic)

instance ToJSON Offering where

instance FromJSON Offering where


data OfferingLength = OfferingLength { startDate :: Day
                                     , endDate :: Maybe Day
                                     } deriving (Show, Generic)

instance ToJSON OfferingLength where

instance FromJSON OfferingLength where



newtype OfferingID = OfferingID Text deriving (Show, Generic)

instance ToJSON OfferingID where

instance FromJSON OfferingID where
-- need to parse lists of objects from the DB with as a list of key value pairs as opposed to an object
-- They are of form {
--      key : {},
--      key : {},,
--      etc...
-- }
