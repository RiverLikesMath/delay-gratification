{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Data.Time
import Options.Applicative 
import TimeLogic 
import Types

data DelayOpts = DelayOpts 
  {
   hello :: String
 -- , quiet :: Bool
 -- , enthusiasm :: Int
  }

delayOpts :: Parser DelayOpts 
delayOpts = DelayOpts 
   <$> strOption
    (long "start" 
    <> metavar "STARTDATE"
    <> value "2024-07-22 20:47"
    <> help "the date and time to start the delay timer, in %Y-%-m-%-d %R form. Example (and current default)  is '2024-07-22 20:47')") 

main :: IO ()
main = trySayTimes =<< execParser opts 
    where 
      opts = info (delayOpts <**> helper)
         ( fullDesc 
           <> progDesc "Print the previous and next time for STARTDATE, using teh algorithm to determine when the previous and next time'll be"
           <> header "hello! this is my first command line haskell program, it helps me avoid looking at things too often" )

parseDateAndGo :: String -> IO () --better name please! 
parseDateAndGo date = do
   now <- getCurrentTime  
   timezone <- getCurrentTimeZone --this'll never be run outside the pacific timezones, right? 
   
   testingStoreStuff (TestingStore [] ) now 

   let startTime = convToUTC date timezone 
      in case startTime of 
        Nothing -> putStrLn "when calling with --start, the date format is YYYY-MM-DD HH:MM. Assumes local time." 
        Just x -> printCheckTimes now x timezone

printDDtime :: UTCTime  -> IO()  
printDDtime now = print  DelayedDateTime { dtId = 0, name = "First time", beginTime =  now }

trySayTimes :: DelayOpts -> IO () 
trySayTimes (DelayOpts date) =  parseDateAndGo date 

sqlStoreTest :: UTCTime -> IO() 
sqlStoreTest now = do 
   print "wow, now to try and do all that, but with sqlite" 
--   testingStoreStuff SQLStore now  

testingStoreStuff  :: (DateTimeStore a) => a-> UTCTime  -> IO() 
testingStoreStuff storeType now = do 
   now2 <- getCurrentTime
   
   printDDtime now 
   printDDtime now2 

   let start  = TestingStore [] 
   print start 
   
   let firstDDtime = (DelayedDateTime {dtId =0, name = "First time", beginTime = now})  
   let next = add start firstDDtime
   putStrLn "next is"
   print next
   
   let secDDtime = (DelayedDateTime {dtId =1, name = " second time", beginTime = now2})
   let next2 = add next secDDtime

   print "after that is" 
   print next2

   let remove1 = remove next2 firstDDtime 
   print "now removing the first one" 
   print remove1
   
   print "now removing the second one, should be empty" 
   let remove2 = remove remove1  secDDtime 
   print  remove2 
   
   
   let removeFromEmpty =  remove remove1 secDDtime 
   print "remove from empty gets us:" 
   print removeFromEmpty  

