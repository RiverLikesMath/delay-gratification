{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Data.Time
import Options.Applicative 

convToUTC :: String -> Maybe UTCTime
convToUTC timeStr = parseTimeM True defaultTimeLocale "%Y-%-m-%-d %R%Z" timeStr :: Maybe UTCTime

printCheckTimes :: UTCTime -> UTCTime -> IO ()
printCheckTimes now startTime = 
   putStrLn finalMsg 
      where
         timeElapsed = diffUTCTime now startTime 
         
         nextStr = currDiffMsg 1 startTime timeElapsed 
         prevStr = currDiffMsg 0 startTime timeElapsed 
         finalMsg = "\n    next " ++ nextStr ++ "\n" ++ "previous " ++ prevStr ++ "\n"
 

currDiffMsg :: Double -> UTCTime -> NominalDiffTime -> String 
currDiffMsg amount startTime timeElapsed = 
    message where 
         pacific = TimeZone (-7*60) False "PDT" 
         diff = calcDiff amount timeElapsed 
         newTime = addUTCTime diff startTime 
         newTimeLocal = utcToZonedTime pacific newTime 
         message = "one is " ++ (show newTimeLocal) 

calcDiff :: Double -> NominalDiffTime -> NominalDiffTime 
calcDiff amount x = secondsToNominalDiffTime (realToFrac nextFar ) 
    where 
      cast :: Double  = realToFrac x
      howFar = logBase 2 cast 
      floorFar = realToFrac ( floor howFar :: Integer ) 
      nextFar = 2 ** (floorFar + amount) 

data DelayOpts = DelayOpts 
  {
   hello :: String
 --  , quiet :: Bool
 -- , enthusiasm :: Int
  }

delayOpts :: Parser DelayOpts 
delayOpts = DelayOpts 
   <$> strOption
    (long "start" 
    <> metavar "STARTDATE"
    <> value "2024-07-22 20:47PDT"
    <> help "the date and time to start the delay timer, in %Y-%-m-%-d %R%Z form. Example (and current default)  is '2024-07-22 20:47PDT'.  Only currently understands PDT")

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
   let startTime = convToUTC date  
      in case startTime of 
        Nothing -> putStrLn "gimme a good date" 
        Just x -> printCheckTimes now x 

trySayTimes :: DelayOpts -> IO () 
trySayTimes (DelayOpts date) =  parseDateAndGo date 

   
