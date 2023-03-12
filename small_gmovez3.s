*
*	Copyleft Awed 
*
*	パズルでぽん（仮称）専用グラフィックルーチン（１／４版）
*	（ずりずり・非ラスターﾊﾞｰｼﾞｭﾖﾝ）
*	1992/05/19- First Edition
*
*
	.include	doscall.mac

GRAM	EQU	$C00000
COUNT	EQU	64-1

	.xdef	_G_MOVE_UZ
	.xdef	_G_MOVE_DZ
	.xdef	_G_MOVE_LZ
	.xdef	_G_MOVE_RZ

	.text
*********************************************************************************
*
*	int G_MOVE_UZ(int x,int y)
*
*	(x,y)-(x+63,y+63)の範囲のグラフィックス(512*512 65535)を上に1ドット
*	ずつ６４ドット分動かす。
*	x,yは1≦n≦65535の範囲にあること。これを超えた時には暴走する。
*	このルーチンを呼ぶ前にグラフィック周りは初期化しておくこと。
*	またクリッピングをしていないので、おかしな座標をアクセスすると飛ぶでしょう。
*	たとえば  G_MOVE_UZ(0,0)とか。
*	return なし
*
_G_MOVE_UZ:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y

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

		MOVE.L	A0,D6			*初期位置保存

		MOVEA.L	A0,A1
		SUBA.L	#1024,A1		*１ライン上

		MOVE.L	A1,D7			*初期位置保存

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


		ADD.L	#1024-128,A0		*１ライン下に下げる
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_U		*縦６４ドット分

		MOVE.L	#0,(A1)+		*横１列６４ドット分
		MOVE.L	#0,(A1)+		*黒で消す
		MOVE.L	#0,(A1)+		* ループ展開
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+

		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+

		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+

		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+


		SUB.L	#1024,D6
		MOVEA.L	D6,A0
		SUB.L	#1024,D7
		MOVEA.L	D7,A1

		MOVE.L	#COUNT,D5
		DBRA	D4,LOOP_U

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS

***************

_G_MOVE_DZ:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y

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

		MOVE.L	A0,D6			*初期位置保存

		MOVEA.L	A0,A1
		ADDA.L	#1024,A1		*１ライン下

		MOVE.L	A1,D7			*初期位置保存

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

		MOVE.L	#0,(A1)+		*横１列64ドット分
		MOVE.L	#0,(A1)+		*黒で消す
		MOVE.L	#0,(A1)+		* ループ展開
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+

		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+

		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+

		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+
		MOVE.L	#0,(A1)+

		ADD.L	#1024,D6
		MOVEA.L	D6,A0
		ADD.L	#1024,D7
		MOVEA.L	D7,A1

		MOVE.L	#COUNT,D5
		DBRA	D4,LOOP_D

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS

****************

_G_MOVE_LZ:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y

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
		MOVE.L	A0,D6			*初期位置保存

		MOVEA.L	A0,A1
		SUBA.L	#2,A1			*１ドット左
		MOVE.L	A1,D7			*初期位置保存

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

		MOVE.W	#0,(A1)

		ADD.L	#1024-128,A0		*１ライン下に下げる
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_L		*縦64ドット分

		SUB.L	#2,D6			*左に1ドットづつ動かして
		MOVEA.L	D6,A0
		SUB.L	#2,D7
		MOVEA.L	D7,A1

		MOVE.L	#COUNT,D5		*カウンタリセット
		DBRA	D4,LOOP_L

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS


****************

_G_MOVE_RZ:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y

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
		MOVE.L	A0,D6			*初期位置保存

		MOVEA.L	A0,A1
		ADDA.L	#2,A1			*１ドット右
		MOVE.L	A1,D7			*初期位置保存

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

		MOVE.W	#0,-2(A1)

		ADD.L	#1024+128,A0		*１ライン下に下げる
		ADD.L	#1024+128,A1		

		DBRA	D5,LOOP_R		*縦64ドット分

		ADD.L	#2,D6			*右に1ドットづつ動かして
		MOVEA.L	D6,A0
		ADD.L	#2,D7
		MOVEA.L	D7,A1

		MOVE.L	#COUNT,D5		*カウンタリセット
		DBRA	D4,LOOP_R

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS
