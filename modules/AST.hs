module AST where

type RGB = String
type StateName = String
type Coordinate = (Int, Int)

data Comm = Seq Comm Comm
          | State StateName RGB
          | DefState StateName RGB
          | Grid Int Int
          | TorGrid Int Int
          | Step [StateName] [Pred]
          | Neigh NeighborType
          | Start StateName [Coordinate]
          | Empty deriving Show

data NeighborType = Moore
                  | Neumann
                  | Coord Coordinate deriving Show

data Pred = Pred Cond StateName deriving Show

data Cond = NumCmp  Quantity  Ordinal Quantity
          | StateEq Coordinate StateName
          | StateNe Coordinate StateName
          | SelfEq  Coordinate
          | SelfNe  Coordinate
          | And Cond Cond 
          | Xor Cond Cond 
          | Or Cond Cond deriving Show

data Ordinal  = NumEq
              | NumLt
              | NumGt
              | NumNe deriving Show

data Quantity  = Count StateName
               | Int Int deriving Show