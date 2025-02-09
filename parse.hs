{-# OPTIONS_GHC -w #-}
module Parse where
import Data.Maybe
import Data.Char
import AST
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,111) ([0,657,512,8192,82,64,0,0,32,0,0,0,32,0,0,32960,0,0,0,256,4096,2048,0,0,256,0,0,0,1,2628,2048,0,8192,0,0,4096,0,0,0,0,128,0,0,0,8192,0,0,0,0,0,0,0,0,0,0,0,2,64,0,0,16,0,0,0,1,0,8,0,0,512,0,0,128,0,0,4129,0,0,1,0,16384,0,0,0,0,0,16,0,16,0,0,0,384,0,16384,0,0,4096,0,0,2,0,32768,3,0,0,960,32768,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,512,0,0,0,0,256,0,0,0,0,0,0,0,0,1032,0,0,0,0,0,0,0,0,0,0,0,0,32768,2064,0,0,0,0,0,0,0,0,0,64,0,0,0,4129,0,0,0,8192,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pars","Comm","Neighbor","Coords","Coord","Sts","StateList","Preds","Pred","Cond","Opp","Comp","Ord","Num","STATE","StateName","RGB","DEFAULT","NEIGH","MOORE","NEUMANN","GRID","TOROIDAL","STEP","THEN","AND","OR","XOR","'('","')'","'{'","'}'","','","COUNT","SELF","'<'","'>'","'='","'<>'","START","int","';'","%eof"]
        bit_start = st Prelude.* 45
        bit_end = (st Prelude.+ 1) Prelude.* 45
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..44]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (17) = happyShift action_4
action_0 (21) = happyShift action_5
action_0 (24) = happyShift action_6
action_0 (26) = happyShift action_7
action_0 (42) = happyShift action_8
action_0 (4) = happyGoto action_9
action_0 (5) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (17) = happyShift action_4
action_1 (21) = happyShift action_5
action_1 (24) = happyShift action_6
action_1 (26) = happyShift action_7
action_1 (42) = happyShift action_8
action_1 (4) = happyGoto action_2
action_1 (5) = happyGoto action_3
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (44) = happyShift action_10
action_2 _ = happyFail (happyExpListPerState 2)

action_3 _ = happyReduce_7

action_4 (18) = happyShift action_20
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (22) = happyShift action_17
action_5 (23) = happyShift action_18
action_5 (31) = happyShift action_19
action_5 (7) = happyGoto action_16
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (43) = happyShift action_15
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (18) = happyShift action_13
action_7 (33) = happyShift action_14
action_7 (8) = happyGoto action_12
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (33) = happyShift action_11
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (44) = happyShift action_10
action_9 (45) = happyAccept
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (17) = happyShift action_4
action_10 (21) = happyShift action_5
action_10 (24) = happyShift action_6
action_10 (26) = happyShift action_7
action_10 (42) = happyShift action_8
action_10 (4) = happyGoto action_29
action_10 (5) = happyGoto action_3
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (31) = happyShift action_19
action_11 (6) = happyGoto action_27
action_11 (7) = happyGoto action_28
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (33) = happyShift action_26
action_12 _ = happyFail (happyExpListPerState 12)

action_13 _ = happyReduce_15

action_14 (18) = happyShift action_25
action_14 (9) = happyGoto action_24
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (43) = happyShift action_23
action_15 _ = happyFail (happyExpListPerState 15)

action_16 _ = happyReduce_11

action_17 _ = happyReduce_9

action_18 _ = happyReduce_10

action_19 (43) = happyShift action_22
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (19) = happyShift action_21
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (20) = happyShift action_44
action_21 _ = happyReduce_2

action_22 (35) = happyShift action_43
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (25) = happyShift action_42
action_23 _ = happyReduce_4

action_24 (34) = happyShift action_41
action_24 _ = happyFail (happyExpListPerState 24)

action_25 (35) = happyShift action_40
action_25 _ = happyReduce_17

action_26 (31) = happyShift action_19
action_26 (36) = happyShift action_38
action_26 (43) = happyShift action_39
action_26 (7) = happyGoto action_32
action_26 (10) = happyGoto action_33
action_26 (11) = happyGoto action_34
action_26 (12) = happyGoto action_35
action_26 (14) = happyGoto action_36
action_26 (16) = happyGoto action_37
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (34) = happyShift action_31
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (35) = happyShift action_30
action_28 _ = happyReduce_12

action_29 _ = happyReduce_1

action_30 (31) = happyShift action_19
action_30 (6) = happyGoto action_63
action_30 (7) = happyGoto action_28
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (18) = happyShift action_62
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (40) = happyShift action_60
action_32 (41) = happyShift action_61
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (34) = happyShift action_59
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (35) = happyShift action_58
action_34 _ = happyReduce_19

action_35 (27) = happyShift action_57
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (28) = happyShift action_54
action_36 (29) = happyShift action_55
action_36 (30) = happyShift action_56
action_36 (13) = happyGoto action_53
action_36 _ = happyReduce_22

action_37 (38) = happyShift action_49
action_37 (39) = happyShift action_50
action_37 (40) = happyShift action_51
action_37 (41) = happyShift action_52
action_37 (15) = happyGoto action_48
action_37 _ = happyFail (happyExpListPerState 37)

action_38 (18) = happyShift action_47
action_38 _ = happyFail (happyExpListPerState 38)

action_39 _ = happyReduce_35

action_40 (18) = happyShift action_25
action_40 (9) = happyGoto action_46
action_40 _ = happyFail (happyExpListPerState 40)

action_41 _ = happyReduce_16

action_42 _ = happyReduce_5

action_43 (43) = happyShift action_45
action_43 _ = happyFail (happyExpListPerState 43)

action_44 _ = happyReduce_3

action_45 (32) = happyShift action_70
action_45 _ = happyFail (happyExpListPerState 45)

action_46 _ = happyReduce_18

action_47 _ = happyReduce_34

action_48 (36) = happyShift action_38
action_48 (43) = happyShift action_39
action_48 (16) = happyGoto action_69
action_48 _ = happyFail (happyExpListPerState 48)

action_49 _ = happyReduce_31

action_50 _ = happyReduce_32

action_51 _ = happyReduce_30

action_52 _ = happyReduce_33

action_53 (31) = happyShift action_19
action_53 (36) = happyShift action_38
action_53 (43) = happyShift action_39
action_53 (7) = happyGoto action_32
action_53 (12) = happyGoto action_68
action_53 (14) = happyGoto action_36
action_53 (16) = happyGoto action_37
action_53 _ = happyFail (happyExpListPerState 53)

action_54 _ = happyReduce_24

action_55 _ = happyReduce_26

action_56 _ = happyReduce_25

action_57 (18) = happyShift action_67
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (31) = happyShift action_19
action_58 (36) = happyShift action_38
action_58 (43) = happyShift action_39
action_58 (7) = happyGoto action_32
action_58 (10) = happyGoto action_66
action_58 (11) = happyGoto action_34
action_58 (12) = happyGoto action_35
action_58 (14) = happyGoto action_36
action_58 (16) = happyGoto action_37
action_58 _ = happyFail (happyExpListPerState 58)

action_59 _ = happyReduce_6

action_60 (18) = happyShift action_65
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (18) = happyShift action_64
action_61 _ = happyFail (happyExpListPerState 61)

action_62 _ = happyReduce_8

action_63 _ = happyReduce_13

action_64 _ = happyReduce_29

action_65 _ = happyReduce_28

action_66 _ = happyReduce_20

action_67 _ = happyReduce_21

action_68 _ = happyReduce_23

action_69 _ = happyReduce_27

action_70 _ = happyReduce_14

happyReduce_1 = happySpecReduce_3  4 happyReduction_1
happyReduction_1 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Seq happy_var_1 happy_var_3
	)
happyReduction_1 _ _ _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_3  4 happyReduction_2
happyReduction_2 (HappyTerminal (TRGB happy_var_3))
	(HappyTerminal (TName happy_var_2))
	_
	 =  HappyAbsSyn4
		 (State happy_var_2 happy_var_3
	)
happyReduction_2 _ _ _  = notHappyAtAll 

happyReduce_3 = happyReduce 4 4 happyReduction_3
happyReduction_3 (_ `HappyStk`
	(HappyTerminal (TRGB happy_var_3)) `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (DefState happy_var_2 happy_var_3
	) `HappyStk` happyRest

happyReduce_4 = happySpecReduce_3  4 happyReduction_4
happyReduction_4 (HappyTerminal (TInt happy_var_3))
	(HappyTerminal (TInt happy_var_2))
	_
	 =  HappyAbsSyn4
		 (Grid happy_var_2 happy_var_3
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happyReduce 4 4 happyReduction_5
happyReduction_5 (_ `HappyStk`
	(HappyTerminal (TInt happy_var_3)) `HappyStk`
	(HappyTerminal (TInt happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (TorGrid happy_var_2 happy_var_3
	) `HappyStk` happyRest

happyReduce_6 = happyReduce 5 4 happyReduction_6
happyReduction_6 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Step happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_1  4 happyReduction_7
happyReduction_7 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happyReduce 5 4 happyReduction_8
happyReduction_8 ((HappyTerminal (TName happy_var_5)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Start happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_9 = happySpecReduce_2  5 happyReduction_9
happyReduction_9 _
	_
	 =  HappyAbsSyn5
		 (Neigh Moore
	)

happyReduce_10 = happySpecReduce_2  5 happyReduction_10
happyReduction_10 _
	_
	 =  HappyAbsSyn5
		 (Neigh Neumann
	)

happyReduce_11 = happySpecReduce_2  5 happyReduction_11
happyReduction_11 (HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (Neigh (Coord happy_var_2)
	)
happyReduction_11 _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  6 happyReduction_12
happyReduction_12 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 ([happy_var_1]
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  6 happyReduction_13
happyReduction_13 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1 : happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 5 7 happyReduction_14
happyReduction_14 (_ `HappyStk`
	(HappyTerminal (TInt happy_var_4)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TInt happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 ((happy_var_2,happy_var_4)
	) `HappyStk` happyRest

happyReduce_15 = happySpecReduce_1  8 happyReduction_15
happyReduction_15 (HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  8 happyReduction_16
happyReduction_16 _
	(HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn8
		 (happy_var_2
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  9 happyReduction_17
happyReduction_17 (HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn9
		 ([happy_var_1]
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  9 happyReduction_18
happyReduction_18 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn9
		 (happy_var_1 : happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  10 happyReduction_19
happyReduction_19 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 ([happy_var_1]
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  10 happyReduction_20
happyReduction_20 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1 : happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  11 happyReduction_21
happyReduction_21 (HappyTerminal (TName happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 (Pred happy_var_1 happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  12 happyReduction_22
happyReduction_22 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (Single happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  12 happyReduction_23
happyReduction_23 (HappyAbsSyn12  happy_var_3)
	(HappyAbsSyn13  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_2 happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  13 happyReduction_24
happyReduction_24 _
	 =  HappyAbsSyn13
		 (And
	)

happyReduce_25 = happySpecReduce_1  13 happyReduction_25
happyReduction_25 _
	 =  HappyAbsSyn13
		 (Xor
	)

happyReduce_26 = happySpecReduce_1  13 happyReduction_26
happyReduction_26 _
	 =  HappyAbsSyn13
		 (Or
	)

happyReduce_27 = happySpecReduce_3  14 happyReduction_27
happyReduction_27 (HappyAbsSyn16  happy_var_3)
	(HappyAbsSyn15  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn14
		 (NumCmp happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  14 happyReduction_28
happyReduction_28 (HappyTerminal (TName happy_var_3))
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn14
		 (StateEq happy_var_1 happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  14 happyReduction_29
happyReduction_29 (HappyTerminal (TName happy_var_3))
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn14
		 (StateNe happy_var_1 happy_var_3
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  15 happyReduction_30
happyReduction_30 _
	 =  HappyAbsSyn15
		 (NumEq
	)

happyReduce_31 = happySpecReduce_1  15 happyReduction_31
happyReduction_31 _
	 =  HappyAbsSyn15
		 (NumLt
	)

happyReduce_32 = happySpecReduce_1  15 happyReduction_32
happyReduction_32 _
	 =  HappyAbsSyn15
		 (NumGt
	)

happyReduce_33 = happySpecReduce_1  15 happyReduction_33
happyReduction_33 _
	 =  HappyAbsSyn15
		 (NumNe
	)

happyReduce_34 = happySpecReduce_2  16 happyReduction_34
happyReduction_34 (HappyTerminal (TName happy_var_2))
	_
	 =  HappyAbsSyn16
		 (Count happy_var_2
	)
happyReduction_34 _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  16 happyReduction_35
happyReduction_35 (HappyTerminal (TInt happy_var_1))
	 =  HappyAbsSyn16
		 (Int happy_var_1
	)
happyReduction_35 _  = notHappyAtAll 

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	TEOF -> action 45 45 tk (HappyState action) sts stk;
	TState -> cont 17;
	TName happy_dollar_dollar -> cont 18;
	TRGB happy_dollar_dollar -> cont 19;
	TDefault -> cont 20;
	TNeigh -> cont 21;
	TMoore -> cont 22;
	TNeumann -> cont 23;
	TGrid -> cont 24;
	TToroidal -> cont 25;
	TStep -> cont 26;
	TThen -> cont 27;
	TAnd -> cont 28;
	TOr -> cont 29;
	TXor -> cont 30;
	TPopen -> cont 31;
	TPclose -> cont 32;
	TLopen -> cont 33;
	TLclose -> cont 34;
	TComma -> cont 35;
	TCount -> cont 36;
	TSelf -> cont 37;
	TLt -> cont 38;
	TGt -> cont 39;
	TEq -> cont 40;
	TNe -> cont 41;
	TStart -> cont 42;
	TInt happy_dollar_dollar -> cont 43;
	TSeq -> cont 44;
	_ -> happyError' (tk, [])
	})

happyError_ explist 45 tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => P a -> (a -> P b) -> P b
happyThen = (thenP)
happyReturn :: () => a -> P a
happyReturn = (returnP)
happyThen1 :: () => P a -> (a -> P b) -> P b
happyThen1 = happyThen
happyReturn1 :: () => a -> P a
happyReturn1 = happyReturn
happyError' :: () => ((Token), [Prelude.String]) -> P a
happyError' tk = (\(tokens, explist) -> happyError) tk
pars = happySomeParser where
 happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


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
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
