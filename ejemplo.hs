import AST
import Parse
import Gen
import Data.HashMap.Strict as M
import CelAutoGen
main = do
         handle <- readFile "game_of_life.ca"
         let ca = construir handle
         foreach (mostrar ca [0..10] [0..10])
         foreach (mostrar (step ca) [0..10] [0..10])

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
                 return (CA  fullGrid def (M.fromList sts) neigh preds)
{-
ACORDATE DE PONER UN CHEQUEO FINAL PARA VER QUE LA ESTRUCTURA ESTÁ COMPLETA
-}                   

mostrar :: GenResult CelAuto -> [Int] -> [Int] -> [[Int]]
mostrar (Failed x) _ _ = []
mostrar g@(Ok ca) x [] = []
mostrar g@(Ok ca) x  (y:ys) = (mostrar g x ys) ++ [(Prelude.map (coso ca) $ Prelude.map (\q -> (q,y)) x)]

coso ca coord = if getState ca coord == "Alive"
                then 1
                else 0

foreach [] = return ()
foreach (x:xs) = do print x
                    foreach xs