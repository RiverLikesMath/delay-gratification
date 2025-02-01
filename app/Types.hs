module Types where 

import Data.Time 

data DelayedDateTime = DelayedDateTime { 
   dtId :: Int, 
   name :: String,
   beginTime :: UTCTime 
} deriving (Eq, Show) 

-- Class is a java interface 
-- algebraic data type 


data DelayedDateTimeStore = DelayedDateTimeStore [DelayedDateTime] deriving Show

class DateTimeCrud a where    --a can be any type! so the tuple for data DelayedDateTimeStore up above *might* be better . If we do that we may not need the typeclass at all
    add    :: a -> DelayedDateTime -> DelayedDateTimeStore -> DelayedDateTimeStore  
    remove :: a -> DelayedDateTime -> DelayedDateTimeStore -> DelayedDateTimeStore
    
data TestingStore = TestingStore 

instance DateTimeCrud TestingStore  where 
   add storeType dateTime (DelayedDateTimeStore store)    = DelayedDateTimeStore (   store ++ [dateTime] )
   remove storeType dateTime (DelayedDateTimeStore [])    = DelayedDateTimeStore []
   remove storeType dateTime (DelayedDateTimeStore store) = DelayedDateTimeStore ( filter (/= dateTime) store )
