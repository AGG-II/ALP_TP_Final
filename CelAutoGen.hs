module CelAutoGen where
import Parse
import AST
import Data.HashMap.Strict as M
import Data.Vector as V

type GenResult = ParseResult
type Neighbors = [Coordinate]
type Predicate = (CelAuto -> Coordinate -> Maybe StateName)
type Cells =  Vector (Vector (Coordinate, StateName))

type States = HashMap StateName RGB
type Predicates = HashMap StateName [Predicate]

data Grid = Finite Cells Int Int | Toroidal Cells Int Int deriving Show

data CelAuto = CA { grid  :: Grid,
                    defState :: StateName,
                    states :: States,
                    neighbors :: Neighbors,
                    step :: Predicates}

emptyCells :: Cells
emptyCells = V.empty

genDef :: Int -> Int -> StateName -> Cells
genDef x y name = V.generate x (\x -> generate y (\y -> ((x,y), name)))

mapCells :: ((Coordinate, StateName) -> (Coordinate, StateName)) -> Cells -> Cells
mapCells foo cells = V.map (V.map foo) cells

modifyCells :: Cells -> [(Coordinate,StateName)] -> Cells
modifyCells cells xs = mapCells (foo xs) cells
  where
    foo xs t@(coord, name) = case search xs coord of
                                  Nothing -> t
                                  Just name' -> (coord, name')
    search [] _ = Nothing
    search (((x,y),name):xs) (a,b) = if x == a && y == b then Just name else search xs (a,b)

getElem :: Coordinate -> Cells -> Maybe (Coordinate, StateName)
getElem (x,y) cells = case cells V.!? x of 
                       Nothing -> Nothing
                       Just col -> col V.!? y

sumCoords :: Coordinate -> Coordinate -> Coordinate
sumCoords (x,y) (a,b) = (x+a,y+b)

memberState :: States -> StateName -> Bool
memberState states name = M.member name states

inGrid :: Grid -> Coordinate -> Bool
inGrid (Toroidal _ x y) (a,b) = (0 <= a) && (a < x) && (0 <= b) && (b < y)
inGrid (Finite _ x y) (a,b) = (0 <= a) && (a < x) && (0 <= b) && (b < y)

emptyPreds :: Predicates
emptyPreds = M.empty

mergePreds :: Predicates -> Predicates -> Predicates
mergePreds = M.unionWith (Prelude.++)

fromListPred :: [(StateName, [Predicate])] -> Predicates
fromListPred xs = Prelude.foldl mergePreds emptyPreds $ Prelude.map (M.fromList.(:[])) xs

getNeighCoords :: CelAuto -> Coordinate -> Neighbors
getNeighCoords ca coord = let neighs = neighbors ca
                          in  Prelude.map (sumCoords coord) neighs

countNeighs :: CelAuto -> Coordinate -> StateName -> Int
countNeighs ca coord name = let neighbors = getNeighCoords ca coord
                            in  Prelude.length (Prelude.filter ((==) name) (Prelude.map (getState ca) neighbors))

getState :: CelAuto -> Coordinate -> StateName
getState ca coord = getState' (grid ca) (defState ca) coord
  where
   getState' (Finite cells _ _) defState coord = case getState coord cells of
                                                 Nothing -> defState
                                                 Just x  -> x
   getState' (Toroidal cells x y) defState (a,b) = let a' = a `mod` x
                                                       b' = b `mod` y
                                                   in  fromJust $ getState (a', b') cells
   getState coord cells = case getElem coord cells of
                          Nothing -> Nothing
                          Just (_,state) -> Just state
   fromJust (Just x) = x

universalPred :: StateName -> Predicate
universalPred self = \_ cd-> Just self