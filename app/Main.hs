{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Data.Time
import Options.Applicative 
import TimeLogic 

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
   let startTime = convToUTC date timezone 
      in case startTime of 
        Nothing -> putStrLn "when calling with --start, the date format is YYYY-MM-DD HH:MM. Assumes local time." 
        Just x -> printCheckTimes now x timezone

trySayTimes :: DelayOpts -> IO () 
trySayTimes (DelayOpts date) =  parseDateAndGo date 

   
