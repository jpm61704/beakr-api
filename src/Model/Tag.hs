{-# LANGUAGE DeriveGeneric #-}
module Model.Tag where

import GHC.Generics
import Data.Aeson
import Data.Text 

data Tag = Tag Text deriving (Show, Generic)

instance ToJSON Tag where

instance FromJSON Tag where
