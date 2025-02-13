import AST
import Parse
import Gen
import Data.HashMap.Strict as M
import CelAutoGen
main = do
         handle <- readFile "game_of_life.ca"
         let ca = fromOk (construir handle)
         foreach (mostrar ca [0..10] [0..10])
         print ""
         foreach (mostrar (next ca) [0..10] [0..10])
         print ""
         foreach (mostrar (next (next ca)) [0..10] [0..10])
  where 
    fromJust (Just x) = x

contador stateName = \ca coord-> countNeighs ca coord stateName

cosoco ca stateName fs = if stateName == "Alive"
                         then Prelude.map (\f -> f ca (3,5)) fs
                         else Prelude.map (\f -> f ca (0,0)) fs

construir s = do arbol <- parseador s
                 (maybeDef, resto) <- obtenerDefState arbol
                 def <- checkDef maybeDef
                 (sts, resto1) <- obtenerEstados resto
                 checkStates (M.fromList sts) resto1
                 (maybeGrid, resto2) <- obtenerGrilla resto1
                 grid <- checkGrid maybeGrid
                 (neigh, resto3) <- obtenerVecinos resto2
                 (start, resto4) <- obtenerInicio grid (M.fromList sts) resto3
                 (preds, fin) <- obtenerPredicados (M.fromList sts) resto4
                 universalPreds <- addUniversalPred preds sts
                 fullGrid <- fillGrid grid start def
                 return (CA  fullGrid def (M.fromList sts) neigh universalPreds)
{-
ACORDATE DE PONER UN CHEQUEO FINAL PARA VER QUE LA ESTRUCTURA ESTÁ COMPLETA
-}                   

fromOk (Ok x) = x

mostrar :: CelAuto -> [Int] -> [Int] -> [[Int]]
mostrar ca x [] = []
mostrar ca x  (y:ys) = (mostrar ca x ys) ++ [(Prelude.map (coso ca) $ Prelude.map (\q -> (q,y)) x)]

coso ca coord = if getState ca coord == "Alive"
                then 1
                else 0

foreach [] = return ()
foreach (x:xs) = do print x
                    foreach xs

next :: CelAuto -> CelAuto
next ca = let newGrid = next' ca (grid ca)
          in  modifyGrid ca newGrid
  where
    modifyGrid (CA _ def sts neigh preds) newGrid = CA newGrid def sts neigh preds
    next' ca (Finite grid x y) = Finite (mapGrid (applyNext ca) grid) x y
    next' ca (Toroidal grid x y) = Toroidal (mapGrid (applyNext ca) grid) x y

mapGrid ::  (Coordinate -> StateName -> StateName) -> HashMap Coordinate StateName -> HashMap Coordinate StateName
mapGrid = M.mapWithKey

applyNext :: CelAuto -> Coordinate -> StateName -> StateName
applyNext ca coord self = let preds = step ca
                              conds = fromJust (M.lookup self preds)
                          in  getNewState ca coord conds
  where
    fromJust (Just x) = x
    getNewState ca coord (f:fs) = case f ca coord of
                                  Nothing       -> getNewState ca coord fs
                                  Just newState -> newState