module Gen where
import Data.List
import CelAutoGen
import AST
import Parse

type StateList = [(StateName, RGB)]

getDefState :: Comm -> GenResult(Maybe StateName, Comm)
getDefState (Seq c1 c2) = do (l1, c1') <- getDefState c1
                             (l2, c2') <- getDefState c2
                             compDef l1 l2 (mergeComm c1' c2')
  where
   compDef Nothing g c = return (g, c)
   compDef g Nothing c = return (g, c)
   compDef (Just l1) (Just l2)  _ = Failed ("Error: Se declaro dos veces el estado DEFAULT (" ++ l1 ++ " y " ++ l2 ++ ")." )
getDefState (DefState name rgb) = return (Just name, State name rgb)                       
getDefState x = return (Nothing,x)

checkDef :: Maybe StateName -> GenResult StateName
checkDef Nothing = Failed "Error DEFAULT: No se declaro un estado por defecto."
checkDef (Just x) = return x

getStates ::  Comm -> GenResult (StateList,Comm)
getStates (Seq c1 c2) = do (l1, c1') <- getStates c1
                           (l2, c2') <- getStates c2
                           case mergeStates l1 l2 of
                            Left e -> Failed e
                            Right l3 -> return (l3, mergeComm c1' c2')
getStates (State name rgb) = return ([(name, rgb)], Empty)
getStates x = return ([],x)

checkStates :: States -> Comm -> GenResult ()
checkStates states c = let ret = nub $ filter (not.(memberState states)) $ getStates' c
                       in if null ret
                          then Ok ()
                          else Failed ("Error: Se hace referencia a los siguientes estados no definidos: " ++ showStates ret)
 where
  showStates [x] = x ++ "."
  showStates (x:xs) = x ++ "," ++ showStates xs

getStates' :: Comm -> [StateName]
getStates' (Seq c1 c2) = let l1 = getStates' c1
                             l2 = getStates' c2
                         in  l1 ++ l2
getStates' (Start stateName _) = [stateName]
getStates' (Step stateNames preds) = let predStates = getPredsStates preds
                                     in  stateNames ++ predStates
 where
  getPredsStates preds = foldl (++) [] (map getPredsStates' preds)
  getPredsStates' (Pred cond stateName) = let condStates = getCondStates cond
                                          in  stateName : condStates

  getCondStates (And c1 c2)           = (getCondStates c1) ++ (getCondStates c2)
  getCondStates (Xor c1 c2)           = (getCondStates c1) ++ (getCondStates c2)
  getCondStates (Or  c1 c2)           = (getCondStates c1) ++ (getCondStates c2)
  getCondStates (NumCmp q1 _ q2)      = (getQuantityState q1) ++ (getQuantityState q2)
  getCondStates (StateEq _ stateName) = [stateName]
  getCondStates (StateNe _ stateName) = [stateName]
  getCondStates _                     = []

  getQuantityState (Count stateName)  = [stateName]
  getQuantityState _                  = []
getStates' _ = []

getGrid :: Comm -> GenResult (Maybe Grid , Comm)
getGrid (Seq c1 c2) = do (g1, c1') <- getGrid c1
                         (g2, c2') <- getGrid c2
                         compGrid g1 g2 (mergeComm c1' c2') 
  where
    compGrid Nothing g c = return (g, c)
    compGrid g Nothing c = return (g, c)
    compGrid _ _ _ = Failed "Error GRID: Se declaro multiples veces la forma de la grilla."
getGrid (Grid x y) | x == 0 || y == 0 = Failed "Error: Se declaro un Grid imposible de dimension 0."
                         |  x < 0 || y < 0  = Failed "Error: Se declaro un Grid imposible de dimension negativa."
                         | otherwise        = return (Just (Finite emptyCells x y ) , Empty)
getGrid (TorGrid x y) | x == 0 || y == 0 = Failed "Error: Se declaro un Grid imposible de dimension 0."
                            |  x < 0 || y < 0  = Failed "Error: Se declaro un Grid imposible de dimension negativa."
                            | otherwise        = return (Just (Toroidal emptyCells x y ) , Empty)
getGrid x = return (Nothing,x)

checkGrid :: Maybe Grid -> GenResult Grid
checkGrid Nothing = Failed "Error GRID: No se declaro una grilla."
checkGrid (Just x) = return x

fillGrid :: Grid -> [(Coordinate,StateName)] -> StateName -> GenResult Grid
fillGrid (Finite _ x y) start def = let allDef = genDef x y def
                                    in  return (Finite (modifyCells allDef start) x y)
fillGrid (Toroidal _ x y) start def = let allDef = genDef x y def
                                      in  return (Toroidal (modifyCells allDef start) x y)

getNeighbors :: Comm -> GenResult (Neighbors, Comm)
getNeighbors (Seq c1 c2) = do (g1, c1') <- getNeighbors c1
                              (g2, c2') <- getNeighbors c2
                              return (mergeNeighs g1 g2, mergeComm c1' c2')
  where
    mergeNeighs [] g = g
    mergeNeighs g [] = g
    mergeNeighs xs ys = let ys' = filter (\y -> y `notElem` xs) ys
                        in  (xs++ys')
getNeighbors (Neigh Moore) = return ([(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,-1),(-1,1),(1,-1)],Empty)
getNeighbors (Neigh Neumann) = return ([(1,0),(-1,0),(0,1),(0,-1)],Empty)
getNeighbors (Neigh (Coord coord)) = return ([coord], Empty)
getNeighbors x = return ([],x)

filterNeighbors :: Neighbors -> Grid -> GenResult Neighbors
filterNeighbors neighs (Finite _ x y) = return $ nub $ map modNeigh neighs
  where
    modNeigh (a,b) = let a' = a `mod` x
                         b' = b `mod` y
                         a'' = if a < 0 then a' - x else a'
                         b'' = if b < 0 then b' - y else b'
                     in  (a'', b'')
filterNeighbors neighs (Toroidal _ x y) = return $ nub $ map modNeigh neighs
  where
    modNeigh (a,b) = let a' = a `mod` x
                         b' = b `mod` y
                         a'' = if a < 0 then a' - x else a'
                         b'' = if b < 0 then b' - y else b'
                     in  (a'', b'')

getStart :: Grid -> States -> Comm -> GenResult ([(Coordinate,StateName)] , Comm)
getStart grid states (Seq c1 c2) = do (l1, c1') <- getStart grid states c1
                                      (l2, c2') <- getStart grid states c2
                                      mergeInicios l1 l2 (mergeComm c1' c2')
  where
    mergeInicios l1 l2 c = let l1' = map fst l1
                               l2' = map fst l2 
                               inter = intersect l1' l2'
                           in  if null inter
                               then return (l1 ++ l2, c)
                               else Failed ("Error: Se declararon la/s coordenada/s " ++ show inter ++ " con mas de un estado inicial.")
getStart grid states (Start stateName xs) = if null outside
                                                 then return (map (\c -> (c, stateName)) xs ,Empty)
                                                 else Failed ("Error de START: Las coordenadas " ++ show outside ++ " no son validas para este tablero.")
  where
    outside = filter (not.(inGrid grid)) xs
getStart _ _ x = return ([],x)

getPredicates :: States -> Comm -> GenResult ( Predicates,Comm)
getPredicates states (Seq c1 c2) = do (l1, c1') <- getPredicates states c1
                                      (l2, c2') <- getPredicates states c2
                                      return (mergePreds l1 l2 ,(mergeComm c1' c2'))
getPredicates states (Step stateNames preds) = return (foldl mergePreds emptyPreds (map (createPreds preds) stateNames), Empty)
getPredicates _ x = return (emptyPreds,x)

createPreds :: [Pred] -> StateName -> Predicates
createPreds xs self = let functions = (map (createPred self) xs)
                      in  fromListPred functions

createPred :: StateName ->Pred -> (StateName,[Predicate])
createPred self (Pred c result) = let cond = createCond c self
                                      ret = (\ca coord -> if (cond ca coord) then Just result else Nothing)
                                  in (self, [ret])

createCond :: Cond -> StateName -> (CelAuto -> Coordinate -> Bool)
createCond (NumCmp q1 ord q2) self = let q1'  = createQuantity q1
                                         q2'  = createQuantity q2
                                     in createCmp ord q1' q2'
  where
    createQuantity (Count stateName) = \ca coord-> countNeighs ca coord stateName
    createQuantity (Int x) = \_ _ -> x
    createCmp NumEq f1 f2 = \ca coord -> (f1 ca coord) == (f2 ca coord)
    createCmp NumLt f1 f2 = \ca coord -> (f1 ca coord) <  (f2 ca coord)
    createCmp NumGt f1 f2 = \ca coord -> (f1 ca coord) >  (f2 ca coord)
    createCmp NumNe f1 f2 = \ca coord -> (f1 ca coord) /= (f2 ca coord)
createCond (StateEq coord cmp) self = \ca cd -> (getState ca $ sumCoords cd coord) == cmp
createCond (StateNe coord cmp) self = \ca cd -> (getState ca $ sumCoords cd coord) /= cmp
createCond (SelfEq coord) self      = \ca cd -> (getState ca $ sumCoords cd coord) == self
createCond (SelfNe coord) self      = \ca cd -> (getState ca $ sumCoords cd coord) /= self
createCond (And c1 c2) self = let c1' = createCond c1 self
                                  c2' = createCond c2 self
                               in (\ca coord -> (c1' ca coord) && (c2' ca coord))
createCond (Xor c1 c2) self = let c1' = createCond c1 self
                                  c2' = createCond c2 self
                               in (\ca coord -> (c1' ca coord) /= (c2' ca coord))
createCond (Or  c1 c2) self = let c1' = createCond c1 self
                                  c2' = createCond c2 self
                               in (\ca coord -> (c1' ca coord) || (c2' ca coord))

addUniversalPred :: Predicates -> [(StateName, RGB)] -> GenResult (Predicates)
addUniversalPred preds sts = let sts' = map fst sts
                                 universal = map ((:[]).universalPred) sts'
                                 res = zip sts' universal
                             in  return (mergePreds preds $ fromListPred res)

mergeComm :: Comm -> Comm -> Comm
mergeComm Empty c = c
mergeComm c Empty = c
mergeComm c1 c2 = Seq c1 c2

mergeStates :: StateList -> StateList -> Either String StateList
mergeStates l [] = Right l
mergeStates [] r = Right r
mergeStates l (s@(state,rgb):xs) = if null (filter (\(x,y) -> x == state) l)
                                   then mergeStates (s:l) xs
                                   else Left ("Error: Doble declaracion del estado " ++ state)