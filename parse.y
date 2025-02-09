{

module Parse where
import Data.Maybe
import Data.Char
import AST

}

%monad { P } { thenP } { returnP }
%name pars

%tokentype { Token }
%lexer {lexer} {TEOF}

%token
  STATE     {TState}
  StateName {TName $$}
  RGB       {TRGB $$}
  DEFAULT   {TDefault}
  NEIGH     {TNeigh}
  MOORE     {TMoore}
  NEUMANN   {TNeumann}
  GRID      {TGrid}
  TOROIDAL  {TToroidal}
  STEP      {TStep}
  THEN      {TThen}
  AND       {TAnd}
  OR        {TOr}
  XOR       {TXor}
  '('       {TPopen}
  ')'       {TPclose}
  '{'       {TLopen}
  '}'       {TLclose}
  ','       {TComma}
  COUNT     {TCount}
  SELF      {TSelf}
  '<'       {TLt}
  '>'       {TGt}
  '='       {TEq}
  '<>'      {TNe}
  START     {TStart}
  int       {TInt $$}
  ';'       {TSeq}

%left AND OR XOR ';'
%nonassoc '>' '<' '=' '<>'

%%

Comm      : Comm ';' Comm                   { Seq $1 $3}
          | STATE StateName RGB             { State $2 $3 }
          | STATE StateName RGB DEFAULT     { DefState $2 $3 }
          | GRID int int                    { Grid $2 $3 }
          | GRID int int TOROIDAL           { TorGrid $2 $3 }
          | STEP  Sts '{' Preds '}'         { Step $2 $4}
          | Neighbor                        { $1 }
          | START '{' Coords '}' StateName  { Start $3 $5}


Neighbor  : NEIGH MOORE                     { Neigh Moore }
          | NEIGH NEUMANN                   { Neigh Neumann }
          | NEIGH Coord                     { Neigh (Coord $2) }

Coords    : Coord                           { [$1] }
          | Coord ',' Coords                { $1 : $3 }

Coord     : '(' int ',' int ')'             { ($2,$4) }

Sts       : StateName                       { [$1] }
          | '{' StateList '}'               { $2 }

StateList : StateName                       { [$1] }
          | StateName ',' StateList         { $1 : $3 }

Preds     : Pred                            { [$1] }
          | Pred ',' Preds                  { $1 : $3 }

Pred      : Cond THEN StateName             { Pred $1 $3 }

Cond      : Comp                            { Single $1 }
          | Comp Opp Cond                   { $2 $1 $3}

Opp       : AND                             { And }
          | XOR                             { Xor }
          | OR                              { Or }

Comp      : Num Ord Num                     { NumCmp $1 $2 $3 }
          | Coord '=' StateName             { StateEq $1 $3 }
          | Coord '<>' StateName            { StateNe $1 $3 }

Ord       : '='                             { NumEq }
          | '<'                             { NumLt }
          | '>'                             { NumGt }
          | '<>'                            { NumNe }

Num       : COUNT StateName                 { Count $2 }
          | int                             { Int $1 }


{

data ParseResult a = Ok a | Failed String
                     deriving Show                     
type LineNumber = Int
type P a = String -> LineNumber -> ParseResult a

getLineNo :: P LineNumber
getLineNo = \s l -> Ok l

thenP :: P a -> (a -> P b) -> P b
m `thenP` k = \s l-> case m s l of
                         Ok a     -> k a s l
                         Failed e -> Failed e
                         
returnP :: a -> P a
returnP a = \s l-> Ok a

failP :: String -> P a
failP err = \s l -> Failed err

catchP :: P a -> (String -> P a) -> P a
catchP m k = \s l -> case m s l of
                        Ok a     -> Ok a
                        Failed e -> k e s l

happyError :: P a
happyError = \ s i -> Failed $ "Linea "++(show (i::LineNumber))++": Error de parseo \n"++(s)

data Token =  TState
            | TName String
            | TRGB String
            | TDefault
            | TNeigh
            | TMoore
            | TNeumann
            | TGrid
            | TToroidal
            | TStep
            | TThen
            | TAnd
            | TOr
            | TXor
            | TPopen
            | TPclose
            | TLopen
            | TLclose
            | TComma
            | TCount
            | TSelf
            | TLt
            | TGt
            | TEq
            | TNe
            | TStart
            | TInt Int
            | TMinus
            | TSeq
            | TEOF


lexer cont s = case s of
                    [] -> cont TEOF []
                    ('\n':s)  ->  \line -> lexer cont s (line + 1)
                    (c:cs)
                          | isSpace c -> lexer cont cs
                          | isAlpha c -> lexChar (c:cs)
                          | isDigit c -> lexNum (c:cs)
                    (';':cs) -> cont TSeq cs
                    ('(':cs) -> cont TPopen cs
                    ('{':cs) -> cont TLopen cs
                    (',':cs) -> cont TComma cs
                    (')':cs) -> cont TPclose cs
                    ('}':cs) -> cont TLclose cs
                    ('<':cs) -> cont TLt cs
                    ('>':cs) -> cont TGt cs
                    ('=':cs) -> cont TEq cs
                    ('<' :('>':cs)) -> cont TNe cs
                    ('-' :(c:cs)) -> if isDigit c
                                     then lexNumNeg (c:cs)
                                     else \ line -> Failed $ "Linea "++(show line)++": - inesperado"
                    ('#':cs) -> let (rgb,rest) = span isAlphaNum cs
                                in  if isRGB rgb 
                                    then cont (TRGB rgb) rest
                                    else \ line -> Failed $ "Linea "++(show line)++": Sintaxis de RGB incorrecta"
              where   lexChar cs = case span isAlphaNum cs of
                            ("STATE",rest)    ->  cont TState rest
                            ("DEFAULT",rest)  ->  cont TDefault rest
                            ("NEIGH",rest)    ->  cont TNeigh rest
                            ("MOORE",rest)    ->  cont TMoore rest
                            ("NEUMANN",rest)  ->  cont TNeumann rest
                            ("GRID",rest)     ->  cont TGrid rest
                            ("TOROIDAL",rest) ->  cont TToroidal rest
                            ("STEP",rest)     ->  cont TStep rest
                            ("THEN",rest)     ->  cont TThen rest
                            ("AND",rest)      ->  cont TAnd rest
                            ("OR",rest)       ->  cont TOr rest
                            ("XOR",rest)      ->  cont TXor rest
                            ("COUNT",rest)    ->  cont TCount rest
                            ("SELF",rest)     ->  cont TSelf rest
                            ("START",rest)    ->  cont TStart rest
                            (stateName,rest)  ->  cont (TName stateName) rest
                      lexNum cs = cont (TInt (read num))  rest
                                where (num,rest) = span isDigit cs
                      lexNumNeg cs = cont (TInt (-(read num)))  rest
                                   where (num,rest) = span isDigit cs
                      isRGB xs = (length xs == 6) && or (map (\x -> isDigit x || (x >= 'a' && x <= 'f'))  xs)

parseador s = pars s 1
}