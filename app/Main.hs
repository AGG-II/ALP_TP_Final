import System.Environment (getArgs)
import Data.HashMap.Strict as M
import Parse( ParseResult(..), parseador )
import Gen
import CelAutoGen
import CAGraphics
main = do
         args <- getArgs
         if (length args) /= 1
         then print "¡Cantida de argumentos incorrecta!"
         else parse $ head args

parse file = do handle <- readFile file
                case construir handle of
                 Ok ca -> correr ca file
                 Failed e -> print e

construir s = do ast <- parseador s
                 (maybeDef, rest) <- getDefState ast
                 def <- checkDef maybeDef
                 (sts, rest1) <- getStates rest
                 let mapSts = M.fromList sts
                 checkStates mapSts rest1
                 (maybeGrid, rest2) <- getGrid rest1
                 grid <- checkGrid maybeGrid
                 (neighs, rest3) <- getNeighbors rest2
                 allNeighs <- filterNeighbors neighs grid
                 (start, rest4) <- getStart grid mapSts rest3
                 (preds, fin) <- getPredicates mapSts rest4
                 universalPreds <- addUniversalPred preds sts
                 fullGrid <- fillGrid grid start def
                 return $ createCA fullGrid def mapSts allNeighs universalPreds