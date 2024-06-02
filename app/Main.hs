{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Data.Time

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

main :: IO ()
main = do
    now <- getCurrentTime
    
    let startTime = convToUTC "2024-06-01 16:39PDT"  
      in case startTime of 
         Nothing -> putStrLn "gimme a good date" 
         Just x -> printCheckTimes now x 
