module CelAutoGen where
import Parse
import AST
import Data.HashMap.Strict as M

type GenResult = ParseResult
type Neighbors = [Coordinate]
type Predicate = (CelAuto -> Coordinate -> Maybe StateName)


type States = HashMap StateName RGB
type Predicates = HashMap StateName [Predicate]

data Grid = Finite (HashMap Coordinate StateName) Int Int | Toroidal (HashMap Coordinate StateName) Int Int deriving Show

data CelAuto = CA { grid  :: Grid,
                    defState :: StateName,
                    states :: States,
                    neighbors :: Neighbors,
                    step :: Predicates}

sumCoords :: Coordinate -> Coordinate -> Coordinate
sumCoords (x,y) (a,b) = (x+a,y+b)

emptyMap :: HashMap a b
emptyMap = M.empty

memberState :: States -> StateName -> Bool
memberState states name = M.member name states

inGrid :: Grid -> Coordinate -> Bool
inGrid (Toroidal _ x y) (a,b) = (0 <= a) && (a < x) && (0 <= b) && (b < y)
inGrid (Finite _ x y) (a,b) = (0 <= a) && (a < x) && (0 <= b) && (b < y)

emptyPreds :: Predicates
emptyPreds = M.empty

mergePreds :: Predicates -> Predicates -> Predicates
mergePreds = M.unionWith (++)

fromListPred :: [(StateName, [Predicate])] -> Predicates
fromListPred xs = Prelude.foldl mergePreds emptyPreds $ Prelude.map (M.fromList.(:[])) xs

fromListStates :: [(Coordinate,StateName)] -> (HashMap Coordinate StateName)
fromListStates = M.fromList

unionStates :: (HashMap Coordinate StateName) -> (HashMap Coordinate StateName) -> (HashMap Coordinate StateName)
unionStates = M.union

getNeighCoords :: CelAuto -> Coordinate -> Neighbors
getNeighCoords ca coord = let neighs = neighbors ca
                          in  Prelude.map (sumCoords coord) neighs

countNeighs :: CelAuto -> Coordinate -> StateName -> Int
countNeighs ca coord name = let neighbors = getNeighCoords ca coord
                            in  length (Prelude.filter ((==) name) (Prelude.map (getState ca) neighbors))

getState :: CelAuto -> Coordinate -> StateName
getState ca coord = getState' (grid ca) (defState ca) coord

getState' (Finite cells _ _) defState coord = case M.lookup coord cells of
                                              Nothing -> defState
                                              Just x  -> x
getState' (Toroidal cells x y) defState (a,b) = let a' = a `mod` x
                                                    b' = b `mod` y
                                                in  fromJust $ M.lookup (a', b') cells
  where
   fromJust (Just x) = x

universalPred :: StateName -> Predicate
universalPred self = \_ _ -> Just self

lucup :: StateName -> Predicates -> [Predicate]
lucup name preds= fromJust' $  M.lookup name preds
  where
    fromJust' (Just x) = x