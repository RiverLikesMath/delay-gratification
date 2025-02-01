module Types where 

import Data.Time 

data DelayedDateTime = DelayedDateTime { 
   dtId :: Int, 
   name :: String,
   beginTime :: UTCTime 
} deriving (Eq, Show) 

-- Class is a java interface 
-- algebraic data type 



class DateTimeStore a where    --a can be any type! so the tuple for data DateTimeStore up above *might* be better . If we do that we may not need the typeclass at all
    add    ::  a -> DelayedDateTime  -> a  
    remove ::  a -> DelayedDateTime  -> a

data TestingStore = TestingStore [DelayedDateTime] deriving Show
data SQLStore     = SQLStore

instance DateTimeStore TestingStore  where 
   add     (TestingStore store)  dateTime  = TestingStore (   store ++ [dateTime] )
   remove  (TestingStore [])  dateTime  = TestingStore []
   remove  (TestingStore store) dateTime = TestingStore ( filter (/= dateTime) store )

--instance DateTimeStore SQLStore where
--   add storeType dateTime  
