module AST where

type RGB = String
type StateName = String

data Comm = Seq Comm Comm
          | State StateName RGB
          | DefState StateName RGB
          | Grid Int Int
          | TorGrid Int Int
          | Step [StateName] [Pred]
          | Neigh NeighborType
          | Start [(Int,Int)] StateName deriving Show

data NeighborType = Moore
                  | Neumann
                  | Coord (Int, Int) deriving Show

data Pred = Pred Cond StateName deriving Show

data Cond = Single Comp
          | And Comp Cond 
          | Xor Comp Cond 
          | Or Comp Cond deriving Show

data Comp = NumCmp  Quantity  Ordinal Quantity
          | StateEq (Int,Int) StateName
          | StateNe (Int,Int) StateName deriving Show

data Ordinal  = NumEq
              | NumLt
              | NumGt
              | NumNe deriving Show

data Quantity  = Count StateName
               | Int Int deriving Show