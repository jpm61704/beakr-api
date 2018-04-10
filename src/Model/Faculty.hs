{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module Model.Faculty where

import           Control.Applicative
import           Data.Aeson
import           Data.String
import           Data.Text
import           Model.Department
import           GHC.Generics

data Faculty = Faculty { department          :: Department
                       , researchDescription :: Text
                       , job_description :: FacultyType
                       } deriving (Show, Generic)

data FacultyType = Professor
                 | AssociateProfessor
                 | AssistantProfessor
                 | Other Text
                 deriving (Show, Generic)

instance ToJSON Faculty where

instance FromJSON Faculty where 

instance ToJSON FacultyType where

instance FromJSON FacultyType where 
