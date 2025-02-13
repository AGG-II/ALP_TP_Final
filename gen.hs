module Gen where
import Data.List
import CelAutoGen
import AST
import Parse

type StateList = [(StateName, RGB)]

obtenerDefState :: Comm -> GenResult(Maybe StateName, Comm)
obtenerDefState (Seq c1 c2) = do (l1, c1') <- obtenerDefState c1
                                 (l2, c2') <- obtenerDefState c2
                                 compDef l1 l2 (mergeComm c1' c2')
  where
   compDef Nothing g c = return (g, c)
   compDef g Nothing c = return (g, c)
   compDef (Just l1) (Just l2)  _ = Failed ("Error: Se declaro dos veces el estado DEFAULT (" ++ l1 ++ " y " ++ l2 ++ ")." )
obtenerDefState (DefState name rgb) = return (Just name, State name rgb)                       
obtenerDefState x = return (Nothing,x)

checkDef :: Maybe StateName -> GenResult StateName
checkDef Nothing = Failed "Error DEFAULT: No se declaro un estado por defecto."
checkDef (Just x) = return x

obtenerEstados ::  Comm -> GenResult (StateList,Comm)
obtenerEstados (Seq c1 c2) = do (l1, c1') <- obtenerEstados c1
                                (l2, c2') <- obtenerEstados c2
                                case mergeStates l1 l2 of
                                  Left e -> Failed e
                                  Right l3 -> return (l3, mergeComm c1' c2')
obtenerEstados (State name rgb) = return ([(name, rgb)], Empty)
obtenerEstados x = return ([],x)

checkStates :: States -> Comm -> GenResult ()
checkStates states c = let ret = elimDup $ filter (not.(memberState states)) $ getStates' c
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
elimDup [] = []
elimDup (x:xs) = let ret = elimDup xs
                 in if elem x ret
                    then ret
                    else (x:xs)

obtenerGrilla :: Comm -> GenResult (Maybe Grid , Comm)
obtenerGrilla (Seq c1 c2) = do (g1, c1') <- obtenerGrilla c1
                               (g2, c2') <- obtenerGrilla c2
                               compGrid g1 g2 (mergeComm c1' c2') 
  where
    compGrid Nothing g c = return (g, c)
    compGrid g Nothing c = return (g, c)
    compGrid _ _ _ = Failed "Error GRID: Se declaro multiples veces la forma de la grilla."
obtenerGrilla (Grid x y) | x == 0 || y == 0 = Failed "Error: Se declaro un Grid imposible de dimension 0."
                         |  x < 0 || y < 0  = Failed "Error: Se declaro un Grid imposible de dimension negativa."
                         | otherwise        = return (Just (Finite emptyMap x y ) , Empty)
obtenerGrilla (TorGrid x y) | x == 0 || y == 0 = Failed "Error: Se declaro un Grid imposible de dimension 0."
                            |  x < 0 || y < 0  = Failed "Error: Se declaro un Grid imposible de dimension negativa."
                            | otherwise        = return (Just (Toroidal emptyMap x y ) , Empty)
obtenerGrilla x = return (Nothing,x)

checkGrid :: Maybe Grid -> GenResult Grid
checkGrid Nothing = Failed "Error GRID: No se declaro una grilla."
checkGrid (Just x) = return x

obtenerVecinos :: Comm -> GenResult (Neighbors, Comm)
obtenerVecinos (Seq c1 c2) = do (g1, c1') <- obtenerVecinos c1
                                (g2, c2') <- obtenerVecinos c2
                                return (mergeNeighs g1 g2, mergeComm c1' c2')
  where
    mergeNeighs [] g = g
    mergeNeighs g [] = g
    mergeNeighs xs ys = let ys' = filter (\y -> y `notElem` xs) ys
                        in  (xs++ys')
obtenerVecinos (Neigh Moore) = return ([(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,-1),(-1,1),(1,-1)],Empty)
obtenerVecinos (Neigh Neumann) = return ([(1,0),(-1,0),(0,1),(0,-1)],Empty)
obtenerVecinos (Neigh (Coord coord)) = return ([coord], Empty)
obtenerVecinos x = return ([],x)

obtenerInicio :: Grid -> States -> Comm -> GenResult ([(Coordinate,StateName)] , Comm)
obtenerInicio grid states (Seq c1 c2) = do (l1, c1') <- obtenerInicio grid states c1
                                           (l2, c2') <- obtenerInicio grid states c2
                                           mergeInicios l1 l2 (mergeComm c1' c2')
  where
    mergeInicios l1 l2 c = let l1' = map fst l1
                               l2' = map fst l2 
                               inter = intersect l1' l2'
                           in  if null inter
                               then return (l1 ++ l2, c)
                               else Failed ("Error: Se declararon la/s coordenada/s " ++ show inter ++ " con mas de un estado inicial.")
obtenerInicio grid states (Start stateName xs) = if null outside
                                                 then return (map (\c -> (c, stateName)) xs ,Empty)
                                                 else Failed ("Error de START: Las coordenadas " ++ show outside ++ " no son validas para este tablero.")
  where
    outside = filter (not.(inGrid grid)) xs
obtenerInicio _ _ x = return ([],x)

obtenerPredicados :: States -> Comm -> GenResult ( Predicates,Comm)
obtenerPredicados states (Seq c1 c2) = do (l1, c1') <- obtenerPredicados states c1
                                          (l2, c2') <- obtenerPredicados states c2
                                          return (mergePreds l1 l2 ,(mergeComm c1' c2'))
obtenerPredicados states (Step stateNames preds) = return (foldl mergePreds emptyPreds (map (createPreds preds) stateNames), Empty)
obtenerPredicados _ x = return (emptyPreds,x)

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

fillGrid :: Grid -> [(Coordinate,StateName)] -> StateName -> GenResult Grid
fillGrid (Finite _ x y) start def = let allDef = map (\coord -> (coord, def)) [(a,b) | a <- [0..x], b <- [0..y]]
                                        gridDef = fromListStates allDef
                                        startStates = fromListStates start
                                    in  return (Finite (unionStates startStates gridDef) x y)
fillGrid (Toroidal _ x y) start def = let allDef = map (\coord -> (coord, def)) [(a,b) | a <- [0..x], b <- [0..y]]
                                          gridDef = fromListStates allDef
                                          startStates = fromListStates start
                                      in  return (Toroidal (unionStates startStates gridDef) x y)

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