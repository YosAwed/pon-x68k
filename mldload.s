*
*	Copyleft(C)1992 Awed
*
*	MLD専用データロードルーチン
*
*	1991/06/01	First edition
*
	.xdef	_mdztransfer
*	.xdef	_getpdztitle
*	.xdef	_getmdztitle
	.xdef	_pdztransfer
	.xdef	_getpcmptr
*	.xdef	_getpcmlen
*	.xdef	_mld_check
*	.xdef	_getpcmfile

		include	doscall.mac

MLD		MACRO	@1
		MOVEQ.L	#@1,D0
		TRAP	#4
		ENDM

*********************************************************************************
*
*	int mdztransfer(char *buffer,int length)
*
*	bufferの内容をMLD内部に転送する。タイトルの設定、PCMファイルの有無や
*	データ長整頓、各種ワークエリア初期化、演奏停止をする。
*
*	lengthは1≦n≦65535の範囲にあること。これを超えた時には暴走する。
*
*	return
*		0:	正常に転送した
*		負数:	MMLバッファが不足している
*
_mdztransfer:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),A0		*Buffer
		MOVE.L	4*15+4(SP),D1		*length
		MLD	3			*転送
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS


*****************************************************************************
*
*	char *getpdztitle()
*
*	PDZファイル名の有無を調べる。現在MMLバッファにあるデータにPDZファイル
*	名が必要な場合、そのファイル名(filesearch関数用)を帰す。PDZファイル名が
*	存在しなければNULLを帰す。
*
*
*_getpdztitle:
*		MOVEM.L	D1-D7/A0-A6,-(SP)
*		MLD	22
*		MOVE.L	D0,A0
*		TST.B	(A0)
*		BEQ	nofile_getpdztitle
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS
*nofile_getpdztitle:
*		MOVEQ.L	#0,D0
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS
*
*****************************************************************************
*
*	char *getmdztitle()
*
*	MDZのタイトルを取り出す。バッファにデータが存在しなければNULが帰される。
*

*_getmdztitle:
*		MOVEM.L	D1-D7/A0-A6,-(SP)
*		MLD	6
*		TST.B	(A0)
*		BEQ	nofile_getmdztitle
*		MOVE.L	A0,D0
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS
*nofile_getmdztitle:
*		MOVEQ.L	#0,D0
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS
*
*********************************************************************************
*
*
*	int pdztransfer(char *buffer,int length)
*
*	PDZデータをMLD内部に転送する。lengthには特別な意味を持つコードがあり、
*
*	length = 0	PCMバッファをクリアする。MMLを強制的に演奏してもPCMパートは
*			実行されない。bufferの値は無意味。
*
*	length = -1	PCMバッファが使用可能状態だと強制的に設定する。bufferの値は
*			無意味。
*
*	length ≧ 1	bufferで示される位置から、lengthバイトをMLD内部に転送する。
*
*	こと、-1や0はデータロード失敗や、getpdzptr関数で得られたポインタに直接
*	データをロードした時に用いる（データ転送時間を大幅短縮する。またバッファに
*	同じデータをロードしていないかどうかチェックした後にも用いる）。
*
*	return:	0	正常に転送した
*		-1	転送に失敗した
*
*	※length ≦ 0の時、帰り値は不定です。
*

_pdztransfer:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),A1
		MOVE.L	4*15+4(SP),D1
		MLD	6
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS

*******************************************************************************
*
*	char *getpcmptr()
*
*	PCMバッファへのポインタを帰します。
*

_getpcmptr:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MLD	4
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS

*******************************************************************************
*
*	int getpcmlen()
*
*	PCMバッファの大きさを帰します。負数の時はpcmバッファへの直接アクセスが
*	禁止されています。
*

*_getpcmlen:
*		MOVEM.L	D1-D7/A0-A6,-(SP)
*		MLD	12
*		MOVE.L	D1,D0
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS

*******************************************************************************
*
*	char *getpcmfile()
*
*	PCMバッファのファイル名を返します。
*

*_getpcmfile:
*		MOVEM.L	D1-D7/A0-A6,-(SP)
*		MLD	22
*		MOVEM.L	(SP)+,D1-D7/A0-A6
*		RTS
*
*
*VER		DS.L	1	*version 

********************************************************************************
*
*	int mld_check()
*
*	MLDが常駐しているかチェックします。
*
*	return
*		value 0      常駐してない
*		　    0以外　常駐している。

_mld_check:
	MOVEM.L	D1-D7/A0-A6,-(SP)

*-------------------------------
*	Install check
*-------------------------------
chkkp:
	move.l	$90.w,a0	; Vector address
	sub.l	#16,a0
	lea	head(pc),a1	; ID
	moveq.l	#12-1,d0
chkkp_loop:
	cmp.b	(a1)+,(a0)+	; Check 12 Bytes.
	bne	chkkp_err
	dbra	d0,chkkp_loop
	moveq.l	#-1,d0		; Installed.
	bra	bye
chkkp_err:
	moveq.l	#0,d0		; Not Install.
bye:
	MOVEM.L	(SP)+,D1-D7/A0-A6
	RTS


head:	dc.b	"  Rie'MIDI  "
