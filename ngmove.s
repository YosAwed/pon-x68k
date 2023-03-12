*
*	Copyleft Awed 
*
*	パズルでぽん（仮称）専用グラフィックルーチン（１／４版）
*	(N dot 移動バージョン)
*	1992/06/04- First Edition
*
*
	.include	doscall.mac

GRAM	EQU	$C00000
COUNT	EQU	64-1

	.xdef	_G_MOVE_U
	.xdef	_G_MOVE_D
	.xdef	_G_MOVE_L
	.xdef	_G_MOVE_R

	.text
*********************************************************************************
*
*	int G_MOVE_UZ(int x,int y,int n)
*
*	(x,y)-(x+63,y+63)の範囲のグラフィックス(512*512 65535)を上にnドット
*	ずつ６４ドット分動かす。
*	x,yは1≦n≦65535の範囲にあること。これを超えた時には暴走する。
*	このルーチンを呼ぶ前にグラフィック周りは初期化しておくこと。
*	またクリッピングをしていないので、おかしな座標をアクセスすると飛ぶでしょう。
*	たとえば  G_MOVE_U(0,0,10)とか。
*	return なし
*
_G_MOVE_U:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y
		MOVE.L	4*15+8(SP),D3       * n

		CLR.L	-(SP)
		DOS	_SUPER
		MOVE.L	D0,(SP)

		MOVE.L	#COUNT,D4		*COUNTER 横ライン用
		MOVE.L	#COUNT,D5		*COUNTER 縦ライン用
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#1024,D3
		SUBA.L	D3,A1			*Nライン上

LOOP_U:
		MOVE.L	(A0)+,(A1)+		*横１列64ドット分
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+


		ADD.L	#1024-128,A0	*１ライン下に下げる
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_U		*縦６４ドット分

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS

***************

_G_MOVE_D:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y
		MOVE.L	4*15+8(SP),D3       * n

		CLR.L	-(SP)
		DOS	_SUPER
		MOVE.L	D0,(SP)

		MOVE.L	#COUNT,D4		*COUNTER 横ライン用
		MOVE.L	#COUNT,D5		*COUNTER 縦ライン用
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADD.L	#1024*63,D2		*63ライン下
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#1024,D3
		ADDA.L	D3,A1			*Nライン下

LOOP_D:
		MOVE.L	(A0)+,(A1)+		*横１列64ドット分
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		SUB.L	#1024+128,A0		*１ライン上に上げる
		SUB.L	#1024+128,A1		

		DBRA	D5,LOOP_D		*縦64ドット分

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS

****************

_G_MOVE_L:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y
		MOVE.L	4*15+8(SP),D3       * n

		CLR.L	-(SP)
		DOS	_SUPER
		MOVE.L	D0,(SP)

		MOVE.L	#COUNT,D4		*COUNTER 横ライン用
		MOVE.L	#COUNT,D5		*COUNTER 縦ライン用
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#2,D3
		SUBA.L	D3,A1			*Nドット左

LOOP_L:
		MOVE.L	(A0)+,(A1)+		*横１列64ドット分
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+
		MOVE.L	(A0)+,(A1)+

		ADD.L	#1024-128,A0		*１ライン下に下げる
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_L		*縦64ドット分

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS


****************

_G_MOVE_R:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y
		MOVE.L	4*15+8(SP),D3       * n

		CLR.L	-(SP)
		DOS	_SUPER
		MOVE.L	D0,(SP)

		MOVE.L	#COUNT,D4		*COUNTER 横ライン用
		MOVE.L	#COUNT,D5		*COUNTER 縦ライン用
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADD.L	#64*2,D1		*右端
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#2,D3
		ADDA.L	D3,A1			*Nドット右

LOOP_R:
		MOVE.L	-(A0),-(A1)		*横１列64ドット分
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)

		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)

		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)

		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)
		MOVE.L	-(A0),-(A1)

		ADD.L	#1024+128,A0		*１ライン下に下げる
		ADD.L	#1024+128,A1		

		DBRA	D5,LOOP_R		*縦64ドット分

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS
