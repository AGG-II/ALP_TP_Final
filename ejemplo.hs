import AST
import Parse
import Gen
import Data.HashMap.Strict as M
import Data.Vector as V
import CelAutoGen
import CAGraphics
main = do
         handle <- readFile "rule90.ca"
         let ca = fromOk $ construir handle
         let res = correr ca "rule90"
         print "Finalizado con Exito!"
         --cuanto <- getLine
         --mostrar (grid ca)
         --miRepeat 0 (read cuanto) ca
  where 
    fromJust (Just x) = x
    fromOk (Ok x) = x
{-    
miRepeat x x' ca = do print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ""
                      print ("Paso numero " Prelude.++ (show x) Prelude.++ ".")
                      mostrar (grid ca)
                      if x == x'
                      then return ()
                      else miRepeat (x+1) x' (next ca)

mostrar (Finite cells x y) = imprimir 0 y cells
  where
    imprimir x x' cells = if x == x'
                          then return ()
                          else do imprimirFila (cells V.! x)
                                  imprimir (x+1) x' cells
mostrar (Toroidal cells x y) = imprimir 0 y cells
  where
    imprimir x x' cells = if x == x'
                          then return ()
                          else do imprimirFila (cells V.! x)
                                  imprimir (x+1) x' cells

imprimirFila fila =  print (V.map (\(_,st) -> if st == "Off" then ' ' else '0') fila) 
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
                 return $ createCA fullGrid def (M.fromList sts) neigh universalPreds

{-coso ca coord = if getState ca coord == "Alive"
                then '0'
                else ' '
-}

foreach [] = return ()
foreach (x:xs) = do print x
                    foreach xs