*
*	Copyleft(C)1992 Awed 
*
*	MLD専用コントロールルーチン
*
*	1992/06/01	first edition

	.xdef	_mdzplay
	.xdef	_mdzstop
	.xdef	_mdzcont
*	.xdef	_mdzstatus
	.xdef	_mdzfadeout
*	.xdef	_mdzsetfade
*	.xdef	_mdzgetclock
*	.xdef	_mdzgetwork
*	.xdef	_setmask
	.xdef	_getloopcounter

MLD		MACRO	@1
		MOVEQ.L	#@1,D0
		TRAP	#4
		ENDM

************************************************************************
*
*	void mdzplay()
*
*	演奏を開始します。
*
_mdzplay:
		MOVEM.L	D0-D7/A0-A6,-(SP)
		CLR.L	D1
		MLD	9
		MOVEM.L	(SP)+,D0-D7/A0-A6
		RTS

************************************************************************
*
*	void mdzstop()
*
*	演奏を停止します。
*
_mdzstop:
		MOVEM.L	D0-D7/A0-A6,-(SP)
		MLD	10
		MOVEM.L	(SP)+,D0-D7/A0-A6
		RTS

************************************************************************
*
*	void mdzcont()
*
*	演奏を再開します。
*
_mdzcont:
		MOVEM.L	D0-D7/A0-A6,-(SP)
		MLD	28
		MOVEM.L	(SP)+,D0-D7/A0-A6
		RTS

************************************************************************
*
*	int mdzstatus()
*
*	演奏状態を帰します。
*
*_mdzstatus:
*		MOVEM.L	D1-D7/A0-A6,-(SP)
*		MLD	7
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS

************************************************************************
*
*	void mdzfadeout()
*
*	フェードアウトします。
*
_mdzfadeout:
		MOVEM.L	D0-D7/A0-A6,-(SP)
		MLD	18
		MOVEM.L	(SP)+,D0-D7/A0-A6
		RTS

************************************************************************
*
*	void mdzsetfade(int speed)
*
*	フェードアウト速度を設定します。
*
*_mdzsetfade:
*		MOVEM.L	D0-D7/A0-A6,-(SP)
*		MOVE.L	4*16(SP),D1
*		MLD	14
*		MOVEM.L	(SP)+,D0-D7/A0-A6
*		RTS
*
************************************************************************
*
*	int mdzgetclock()
*
*	演奏開始からの時間(OPM割り込み回数)を帰します。
*
*_mdzgetclock:
*		MOVEM.L	D1-D7/A0-A6,-(SP)
*		MLD	11
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS
*
************************************************************************
*
*	char *mdzgetwork()
*
*	ワークエリアへのポインタを帰します。
*
*_mdzgetwork:
*		MOVEM.L	D1-D7/A0-A6,-(SP)
*		MLD	10
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS
*
************************************************************************
*
*	void setmask(int trackstatus)
*
*	トラックのマスクをします。
*
*_setmask:
*		MOVEM.L	D0-D7/A0-A6,-(SP)
*		MOVE.L	4*16(SP),D1
*		MLD	21
*		MOVEM.L	(SP)+,D0-D7/A0-A6
*		RTS

************************************************************************
*
*	short int getloopcounter( void )
*
*	ループカウンターを返します。
*
_getloopcounter:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MLD	29
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS
