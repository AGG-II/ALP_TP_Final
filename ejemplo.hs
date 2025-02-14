import AST
import Parse
import Gen
import Data.HashMap.Strict as M
import CelAutoGen
main = do
         handle <- readFile "rule90.ca"
         let ca = fromOk $ construir handle
         print (grid ca)
         print ""
         print ""
         print ""
         print (grid (next ca))
         --mostrarPasos 0 100 ca
  where 
    fromJust (Just x) = x
    fromOk (Ok x) = x

{-mostrarPasos x y ca = if x == y 
                      then
                      else
-}
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

{-coso ca coord = if getState ca coord == "Alive"
                then '0'
                else ' '
-}

foreach [] = return ()
foreach (x:xs) = do print x
                    foreach xs
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
nextMultiple 0 ca = ca
nextMultiple x ca = next $ nextMultiple (x-1) ca