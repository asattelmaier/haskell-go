module Go.Intersection
( Location (Location)
, Color (Black, White)
, State (Empty, Stone)
, Intersection (Intersection)
, isEmpty
, setEmpty
, hasSameState
, hasColor
, includes
, create
) where



import           Data.List
import           Data.Maybe
import           Go.Color   (Color (Black, White))



data Location     = Location Int Int deriving (Show, Eq)
data State        = Empty | Stone Color deriving (Show, Eq)
data Intersection = Intersection Location State deriving (Show, Eq)



create :: Location -> Color -> Intersection
create location color = Intersection location (Stone color)



isEmpty :: Intersection -> Bool
isEmpty (Intersection location state) = state == Empty



setEmpty :: Intersection -> Intersection
setEmpty (Intersection location state) = Intersection location Empty



getState :: Intersection -> State
getState (Intersection location state) = state



hasSameState :: Intersection -> Intersection -> Bool
hasSameState intersectionA intersectionB = getState intersectionA == getState intersectionB



getColor :: Intersection -> Maybe Color
getColor (Intersection _ Empty)         = Nothing
getColor (Intersection _ (Stone color)) = Just color



hasColor :: Intersection -> Color -> Bool
hasColor intersection color = (Just color ==) $ getColor intersection



includes :: [Intersection] -> Intersection -> Bool
includes intersections intersection
  | isNothing result = False
  | otherwise        = True
  where result = find (intersection ==) intersections

