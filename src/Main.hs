module Main where



import qualified API.JSON           (main)
import qualified CLI                (main)
import           System.Environment
import           System.Exit



main :: IO ()
main = getArgs >>= parse



parse :: [String] -> IO ()
parse ["-h"]               = usage >> exit
parse ["-v"]               = version >> exit
parse ["-m", "cli"]        = CLI.main
parse ["-m", "json", json] = API.JSON.main json



usage :: IO ()
usage = putStr $
  "Usage: go-haskell [-vhm] [json...]\n\n" ++
  "Options:\n" ++
  "  -h    Print this information\n" ++
  "  -m    Mode\n" ++
  "        (\"cli\"|\"json\")\n" ++
  "  -v    Print version information\n"



version :: IO ()
version = putStrLn "go-haskell 0.0.0.1"



exit :: IO ()
exit = exitSuccess

