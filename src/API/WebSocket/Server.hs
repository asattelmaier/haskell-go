{-# LANGUAGE OverloadedStrings #-}



module API.WebSocket.Server where



import           Control.Monad      (forever)
import           Data.Maybe         (fromMaybe)
import           Data.Text          (Text)
import qualified Data.Text.IO       as T
import qualified Network.WebSockets as WS
import           Text.Read          (readMaybe)



type Client = WS.Connection



defaultPort :: Int
defaultPort = 9000



main :: Maybe String -> IO ()
main port = do
  runServer (fromMaybe defaultPort (readMaybe =<< port))



runServer :: Int -> IO ()
runServer port = do
  -- TODO: Add logger
  putStrLn ("Listening on ws://127.0.0.1:" ++ show port)

  WS.runServer "127.0.0.1" port server



server :: WS.ServerApp
server pending = do
  client <- WS.acceptRequest pending

  WS.withPingThread client 30 (return ()) $ do
    communicate client



communicate :: Client -> IO ()
communicate client = forever $ do
  clientData <- WS.receiveData client :: IO Text

  T.putStrLn clientData

  WS.sendTextData client clientData

