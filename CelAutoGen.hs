module CelAutoGen where
import Parse
import AST
import Data.HashMap.Strict as M
import Data.Vector as V
import Graphics.Gloss (Color, makeColorI)
import Numeric (readHex)
import Data.Char (toLower)

type GenResult = ParseResult
type Neighbors = [Coordinate]
type Predicate = (CelAuto -> Coordinate -> Maybe StateName)
type Cells =  Vector (Vector (Coordinate, StateName))

type States = HashMap StateName RGB
type Predicates = HashMap StateName [Predicate]
type StatesColor = HashMap StateName Color

data Grid = Finite Cells Int Int | Toroidal Cells Int Int deriving Show

data CelAuto = CA { grid  :: Grid,
                    defState :: StateName,
                    states :: StatesColor,
                    neighbors :: Neighbors,
                    step :: Predicates}

emptyCells :: Cells
emptyCells = V.empty

genDef :: Int -> Int -> StateName -> Cells
genDef x y name = V.generate y (\b -> generate x (\a -> ((a,b), name)))

mapCells :: ((Coordinate, StateName) -> a) -> Cells -> Vector (Vector a)
mapCells foo cells = V.map (V.map foo) cells

modifyCells :: Cells -> [(Coordinate,StateName)] -> Cells
modifyCells cells xs = mapCells (foo xs) cells
  where
    foo xs t@(coord, name) = case search xs coord of
                                  Nothing -> t
                                  Just name' -> (coord, name')
    search [] _ = Nothing
    search (((x,y),name):xs) (a,b) = if x == a && y == b then Just name else search xs (a,b)

getCells :: CelAuto -> Cells
getCells ca = getCells' $ grid ca
  where
    getCells' (Finite cells _ _) = cells
    getCells' (Toroidal cells _ _) = cells

getElem :: Coordinate -> Cells -> Maybe (Coordinate, StateName)
getElem (x,y) cells = case cells V.!? y of 
                       Nothing -> Nothing
                       Just col -> col V.!? x

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
   getState' (Finite cells _ _) defState coord = case getState'' coord cells of
                                                 Nothing -> defState
                                                 Just x  -> x
   getState' (Toroidal cells x y) defState (a,b) = let a' = a `mod` x
                                                       b' = b `mod` y
                                                   in  fromJust $ getState'' (a', b') cells
   getState'' coord cells = case getElem coord cells of
                          Nothing -> Nothing
                          Just (_,state) -> Just state
   fromJust (Just x) = x

universalPred :: StateName -> Predicate
universalPred self = \_ cd-> Just self

createCA :: Grid -> StateName -> States -> Neighbors -> Predicates -> CelAuto
createCA grid def sts neigh universalPreds = let stsCol  = M.map makeColor sts
                                             in  CA grid def stsCol neigh universalPreds

makeColor :: String -> Color
makeColor xs = let (r,g,b) = hexToRGB xs
               in  makeColorI r g b 255

-- Esto lo hizo chatGTP
hexToRGB :: String -> (Int, Int, Int)
hexToRGB ('#':hex) = 
    let [r, g, b] = Prelude.map (Prelude.fst . Prelude.head . readHex) (chunksOf 2 hex)
    in (r, g, b)

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = Prelude.take n xs : chunksOf n (Prelude.drop n xs)

getDimGrid :: CelAuto -> (Int,Int)
getDimGrid ca = case grid ca of
                Finite _ x y -> (x,y)
                Toroidal _ x y -> (x,y)

next :: CelAuto -> CelAuto
next ca = let newGrid = next' ca (grid ca)
          in  modifyGrid ca newGrid
  where
    modifyGrid (CA _ def sts neigh preds) newGrid = CA newGrid def sts neigh preds
    next' ca (Finite grid x y) = Finite (mapCells (applyNext ca) grid) x y
    next' ca (Toroidal grid x y) = Toroidal (mapCells (applyNext ca) grid) x y

applyNext :: CelAuto -> (Coordinate, StateName) -> (Coordinate,StateName)
applyNext ca (coord,self) = let preds = step ca
                                conds = fromJust (M.lookup self preds)
                            in  getNewState ca coord conds
  where
    fromJust (Just x) = x
    getNewState ca coord (f:fs) = case f ca coord of
                                  Nothing       -> getNewState ca coord fs
                                  Just newState -> (coord,newState)

getColor :: StatesColor -> StateName -> Color
getColor stsCol name = fromJust $ M.lookup name stsCol
  where
    fromJust (Just x) = x

toListCells grid = V.toList $ V.foldl (V.++) V.empty grid