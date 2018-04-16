{-# LANGUAGE DeriveGeneric #-}

module Model.Message where

import           Data.Aeson
import           Data.Text
import           Data.Time
import           Model.User
import GHC.Generics


data Message = Message { from      :: UserID
                       , to        :: UserID
                       , subject   :: Text
                       , date_sent :: UTCTime
                       , body      :: Text
                       } deriving (Show, Generic)

instance ToJSON Message where

instance FromJSON Message where
