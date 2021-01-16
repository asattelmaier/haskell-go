{-# LANGUAGE NamedFieldPuns #-}

module UserInterface.Render
( render
, cursorToLocation
) where



import Location               (Location (Location))
import Board                  (Board, State (Empty, Stone), Color (White, Black))
import Game                   (Game (Game, board, activePlayer))
import UserInterface.Cursor   (Cursor (Cursor))



cursorRepresentation  = '█'
empty                 = '+'
blackStone            = 'X'
whiteStone            = 'O'
gutter                = ' '
horizontalGutter      = '-'
verticalGutter        = '|'
verticalGutterSpace   = 3
horizontalGutterSpace = 1



render :: Game -> Cursor -> String
render game cursor = renderCursor game cursor $ renderBoard game



cursorToLocation :: Cursor -> Maybe Location
cursorToLocation (Cursor x y)
  | isOnPoint = Just (Location positionY positionX)
  | otherwise = Nothing
  where positionX  = x `div` (verticalGutterSpace + 1)
        positionY  = y `div` (horizontalGutterSpace + 1)
        isOnPoint  = isXOnPoint && isYOnPoint
        isXOnPoint = x `mod` (verticalGutterSpace + 1) == 0
        isYOnPoint = y `mod` (horizontalGutterSpace + 1) == 0



renderCursor :: Game -> Cursor -> String -> String
renderCursor Game {board} cursor renderedBoard =
  replaceChar renderedBoard index cursorRepresentation
  where index = getCursorLocationIndex cursor board



getCursorLocationIndex :: Cursor -> Board -> Int
getCursorLocationIndex (Cursor x y) board = x + y * (horizontalLines - 1) * 4 + y * 2
  where horizontalLines = length $ head board



renderBoard :: Game -> String
renderBoard Game {board} = removeLastLine $ concatMap renderGrid board
  where removeLastLine = take $ horizontalLines * horizontalLineWidth * (1 + horizontalGutterSpace) - lastLine
        horizontalLines     = length board
        horizontalLineWidth = (verticalGutterSpace + 1) * (horizontalLines - 1) + 2
        lastLine            = horizontalGutterSpace * horizontalLineWidth



renderGrid :: [State] -> String
renderGrid states = unlines $ renderHorizontalLine states : renderVerticalLines states



renderHorizontalLine :: [State] -> String
renderHorizontalLine = renderLine . map (renderHorizontalGutter . renderIntersection)



renderVerticalLines :: [State] -> [String]
renderVerticalLines = replicate horizontalGutterSpace . renderLine . map renderVerticalLine 



renderLine :: [String] -> String
renderLine a = take ((length a - 1) * (verticalGutterSpace + 1) + 1) $ concat a



renderHorizontalGutter :: Char -> String
renderHorizontalGutter = flip (:) (replicate verticalGutterSpace horizontalGutter)



renderVerticalLine :: State -> String
renderVerticalLine _ = verticalGutter:replicate verticalGutterSpace gutter



renderIntersection :: State -> Char
renderIntersection Empty         = empty
renderIntersection (Stone Black) = blackStone
renderIntersection (Stone White) = whiteStone





-- General Utils

replaceChar :: String -> Int -> Char -> String
replaceChar [] _ _ = []
replaceChar (_:stringTail) 0 char = char:stringTail
replaceChar (stringHead:stringTail) index char =
  if index < 0
    then stringHead:stringTail
    else stringHead:replaceChar stringTail (index - 1) char
