{-# LANGUAGE ScopedTypeVariables #-}

module TimeLogic (convToUTC, printCheckTimes)  where

import Data.Time

convToUTC :: String -> Maybe UTCTime
convToUTC timeStr = parseTimeM True defaultTimeLocale "%Y-%-m-%-d %R" timeStr :: Maybe UTCTime

printCheckTimes :: UTCTime -> UTCTime -> TimeZone -> IO ()
printCheckTimes now startTime tz = 
   putStrLn finalMsg
      where
         timeElapsed = diffUTCTime now startTime

         nextStr = currDiffMsg 1 startTime timeElapsed tz
         prevStr = currDiffMsg 0 startTime timeElapsed tz
         finalMsg = "\n    next " ++ nextStr ++ "\n" ++ "previous " ++ prevStr ++ "\n"

currDiffMsg :: Double -> UTCTime -> NominalDiffTime -> TimeZone -> String
currDiffMsg amount startTime timeElapsed tz =
    message where
         diff = calcDiff amount timeElapsed
         newTime = addUTCTime diff startTime
         newTimeLocal = utcToZonedTime tz newTime
         message = "one is " ++ (show newTimeLocal)


calcDiff :: Double -> NominalDiffTime -> NominalDiffTime
calcDiff amount x = secondsToNominalDiffTime (realToFrac nextFar )
    where
      cast :: Double  = realToFrac x
      howFar = logBase 2 cast
      floorFar = realToFrac ( floor howFar :: Integer )
      nextFar = 2 ** (floorFar + amount)


