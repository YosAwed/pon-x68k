******************************************
*	1990/11/30	version 1.00
*	1991/ 6/20	version	1.01
*	1991/ 9/17	version	1.02
*
*	Written by Shadow Mountain 影山
******************************************

	.include	doscall.mac
	.include	iocscall.mac
	.include	fdef.h

	.xdef		_apic_load

	.offset		8

_name:		ds.l	1
_x0:		ds.l	1
_y0:		ds.l	1

savesize:	equ	4*8

	.text
	.even

*******************************************************************
* apic_load( str;filename ,[int;x0] ,[int;y0] )
*******************************************************************
_apic_load:
	link	a6,#0
	movem.l	d3-d7/a3-a5,-(sp)

	bsr	init

	move.l	_name(a6),a1	* ファイルネームアドレス
	movem.l	_x0(a6),d1-d2	* d1=x0,d2=y0

	tst.w	d1
	bmi	pload2		* x0が省略された
	move.l	d1,x0
pload2:
	tst.w	d2
	bmi	pload3		* y0が省略された
	move.l	d2,y0
pload3:
	bsr	scr_chk
	tst.l	d0
	bmi	scr_err		* モードがちがう

	bsr	file_open
	tst.l	d0
	bmi	no_file_err	* ファイルがない

	move.w	d0,-(sp)	* ヘッダーチェック
	DOS	_FGETC
	cmp.b	#'P',d0
	bne	no_pic_err
	DOS	_FGETC
	cmp.b	#'I',d0
	bne	no_pic_err
	DOS	_FGETC
	cmp.b	#'C',d0
	bne	no_pic_err
pload4:
	DOS	_FGETC
	cmp.b	#$1a,d0
	bne	pload4
pload5:
	DOS	_FGETC
	tst.b	d0
	bne	pload5

	addq.l	#2,sp

	move.l	sp,sp_save
	move.l	sp_ptr,sp
	move.l	buff_end,-(sp)
	move.l	buff_size,-(sp)
	move.l	buff_start,-(sp)
	move.l	y0,-(sp)
	move.l	x0,-(sp)
	move.l	f_handle,-(sp)
	bsr	L000b18		* ロード
	move.l	sp_save,sp
	tst.l	d0
	bmi	error3

	bsr	file_close

	lea.l	normal_end,a0
	clr.l	d0		* 正常終了
	move.l	memptr,-(sp)
	DOS	_MFREE
	addq.l	#4,sp
	movem.l	(sp)+,d3-d7/a3-a5
	unlk	a6
	rts

*******************************************
* バッファサイズ等をワークに設定する
*******************************************
init:
	clr.l	memptr		* メモリ管理ポインタをクリア
	move.l	#$ffffff,-(sp)
	DOS	_MALLOC
	and.l	#$ffffff,d0	* 取り得る最大のメモリブロック
	move.l	d0,d2
	move.l	d2,(sp)
	DOS	_MALLOC		* メモリを確保する
	addq.l	#4,sp
	move.l	d0,memptr	* メモリ管理ポインタ
	bmi	no_mem_err	* 完全に確保できない

	move.l	d0,d3
	add.l	d2,d3		* 確保したメモリブロックの最終アドレス
	move.l	d3,sp_ptr	* スタックアドレス

	sub.l	#6000,d2	* スタックサイズ
	cmp.l	#128,d2
	blt	no_mem_err	* 最低128バイト必要なのになかった

	move.l	#$e00000,d1
	cmp.l	#$80400,d2
	blt	init1
	sub.l	#$80000,d2
	move.l	d0,d1
	add.l	d2,d1
init1:
	move.l	d2,buff_size	* バッファサイズ
	move.l	d0,buff_start	* バッファ先頭アドレス
	move.l	d1,buff_end	* バッファ最終アドレス
	rts

*******************************************
* グラフィック画面が使用できるかチェック
*******************************************
scr_chk:
	moveq.l	#-1,d1
	IOCS	_APAGE
	rts

*******************************************
* ファイル新規作成
*******************************************
file_create:
	move.w	#$20,-(sp)	* 通常のファイル
	move.l	a1,-(sp)
	DOS	_CREATE
	addq.l	#6,sp
	move.l	d0,f_handle	* ファイルハンドル
	rts

*******************************************
* ファイルオープン
*******************************************
file_open:
	clr.w	-(sp)
	move.l	a1,-(sp)
	DOS	_OPEN
	addq.l	#6,sp
	move.l	d0,f_handle	* ファイルハンドル
	rts

*******************************************
* ファイルクローズ
*******************************************
file_close:
	move.w	f_handle+2,-(sp)
	DOS	_CLOSE
	addq.l	#2,sp
	rts

*******************************************
* エラー処理
*******************************************
chigau_err:
	lea.l	chigau_mes,a1
	bra	error
read_err:
	lea.l	read_mes,a1
	bra	error
disk_full_err:
	lea.l	disk_full_mes,a1
	bra	error
write_err:
	lea.l	write_mes,a1	* ディスクに書き込めない
	bra	error
scr_err:
	lea.l	scr_mes,a1	* 画面が初期化されていない
	bra	error
point_err:
	lea.l	point_mes,a1	* 座標がおかしい
	bra	error
no_mem_err:
	lea.l	no_mem_mes,a1	* メモリがたりない
	bra	error
no_pic_err:
	addq.l	#2,sp
	lea.l	no_pic_mes,a1	* ＰＩＣファイルと違う
	bra	error
no_file_err:
	lea.l	no_file_mes,a1	* ファイルが見つからない

error:
	move.l	memptr,d0
	beq	error2
	move.l	d0,-(sp)
	DOS	_MFREE		* メモリが確保されているなら解放する
	addq.l	#4,sp
error2:
	move.l	#1,d0		* エラーコード
	movem.l	(sp)+,d3-d7/a3-a5
	unlk	a6
	rts			* 異常終了

error3:
	move.l	d0,d7
	bsr	file_close
	cmp.l	#-32,d7
	beq	point_err
	cmp.l	#-8,d7
	beq	no_mem_err
	cmp.l	#-31,d7
	beq	no_pic_err
	cmp.l	#-35,d7
	beq	disk_full_err
	cmp.l	#-36,d7
	beq	read_err
	cmp.l	#-38,d7
	beq	chigau_err

	lea.l	dummy_mes,a1
	bra	error



*******************************************


L000a54:
	movea.l	a7,a1
	movem.l	d3-d7/a3-a6,-(a7)
	link	a6,#-1072
	move.l	a6,-(a7)
	lea.l	$0004(a7),a6
	clr.l	-(a7)
	DOS	_SUPER
	move.l	d0,(a7)
	bsr	L000a7e
	move.l	d0,d1
	DOS	_SUPER
	addq.l	#4,a7
	movea.l	(a7)+,a6
	unlk	a6
	move.l	d1,d0
	movem.l	(a7)+,d3-d7/a3-a6
	rts

L000a7e:
	move.l	a7,$042a(a6)
	move.w	$0006(a1),$0428(a6)
	move.w	$000a(a1),d0
	cmp.w	#$0003,d0
	bhi	L001678
	move.w	d0,$0402(a6)
	move.w	$000e(a1),d0
	move.w	$0012(a1),d2
	move.w	$0016(a1),d1
	move.w	$001a(a1),d3
	bsr	L000c2e
	movea.l	$001c(a1),a0
	move.l	$0020(a1),d0
	bsr	L000c16
	movea.l	$041c(a6),a5
	move.l	$0420(a6),d6
	moveq.l	#$10,d7
	moveq.l	#$00,d5
	move.l	$0024(a1),$0424(a6)
	move.b	$00e80028,-(a7)
	bsr	L000c00
	moveq.l	#$00,d0
	bsr	L0015b0
	move.w	$0402(a6),d0
	move.b	L000b14(pc,d0.w),d0
	bsr	L0015b0
	move.w	$0414(a6),d0
	bsr	L0015b0
	move.w	$0416(a6),d0
	bsr	L0015b0
	bsr	L001586
	bsr	L00162a
	bsr	L000f32
	move.b	(a7)+,$00e80028
	bsr	L00151a
	bsr	L00160c
	moveq.l	#$00,d0
	rts

L000b14:
	.dc.b	$04,$08,$0f,$10
L000b18:
	movea.l	a7,a1
	movem.l	d3-d7/a3-a6,-(a7)
	link	a6,#-1072
	move.l	a6,-(a7)
	lea.l	$0004(a7),a6
	clr.l	-(a7)
	DOS	_SUPER
	move.l	d0,(a7)
	bsr	L000b42
	move.l	d0,d1
	DOS	_SUPER
	addq.l	#4,a7
	movea.l	(a7)+,a6
	unlk	a6
	move.l	d1,d0
	movem.l	(a7)+,d3-d7/a3-a6
	rts

L000b42:
	move.l	a7,$042a(a6)
	move.w	$0006(a1),$0428(a6)
	movea.l	$0010(a1),a0
	move.l	$0014(a1),d0
	bsr	L000c16
	moveq.l	#$00,d6
	moveq.l	#$00,d7
	clr.b	$042e(a6)
	move.l	$0018(a1),$0424(a6)
	bsr	L0015a6
	tst.w	d0
	bne	L00166a
	bsr	L0015a6
	subq.w	#1,d0
	cmp.w	#$0010,d0
	bcc	L00166a
	move.b	L000bc0(pc,d0.w),d0
	bmi	L00166a
	move.w	d0,$0402(a6)
	bsr	L0015a6
	subq.w	#1,d0
	move.w	d0,d1
	bsr	L0015a6
	subq.w	#1,d0
	move.w	d0,d3
	move.w	$000a(a1),d0
	move.w	$000e(a1),d2
	add.w	d0,d1
	add.w	d2,d3
	bsr	L000c2e
	bsr	L000bd0
	bsr	L001566
	bsr	L00162a
	bsr	L000cc0
	bsr	L00151a
	moveq.l	#$00,d0
	rts

L000bc0:
	.dc.b	$ff,$ff,$ff,$00,$ff,$ff,$ff,$01
	.dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$02,$03

L000bd0:
	move.w	$0402(a6),d0
	moveq.l	#$00,d1
	move.b	L000c0e(pc,d0.w),d1
	cmp.b	$00e80028,d1
	beq	L000bfe

	bra	err_scr			* 画面モードが違う

*	.comment note			* ここから
					*   ↓
	move.b	L000c12(pc,d0.w),d0	*   ↓
	moveq.l	#$df,d1			*   ↓
	or.b	$00e82601,d1		*   ↓
	move.w	d0,-(a7)		*   ↓
	move.w	#$0010,-(a7)		*   ↓
	DOS	_CONCTRL		*   ↓
	addq.l	#4,a7			*   ↓
note	and.b	d1,$00e82601		* ここまで注釈

L000bfe:
	rts

L000c00:
	move.w	$0402(a6),d0
	move.b	L000c0e(pc,d0.w),$00e80028
	rts

L000c0e:
	.dc.b	$04,$01,$03,$03
L000c12:
	.dc.b	$01,$04,$05,$05
L000c16:
	and.w	#$fffe,d0
	cmp.l	#$00000080,d0
	blt	L00166e
	move.l	d0,$0420(a6)
	move.l	a0,$041c(a6)
	rts

L000c2e:
	movem.l	d0-d5,-(a7)
	movem.w	d0-d3,$0404(a6)
	cmp.w	d0,d1
	bcs	L001674
	cmp.w	d2,d3
	bcs	L001674
	move.w	#$0200,d4
	move.w	d4,d5
	tst.w	$0402(a6)
	bne	L000c52
	add.w	d4,d4
L000c52:
	cmpi.w	#$0002,$0402(a6)
	bcc	L000c5c
	add.w	d5,d5
L000c5c:
	move.w	d4,$0410(a6)
	cmp.w	d4,d0
	bcc	L001674
	cmp.w	d4,d1
	bcc	L001674
	cmp.w	d5,d2
	bcc	L001674
	cmp.w	d5,d3
	bcc	L001674
	move.w	d1,d4
	sub.w	d0,d4
	addq.w	#1,d4
	move.w	d4,$0414(a6)
	move.w	d3,d4
	sub.w	d2,d4
	addq.w	#1,d4
	move.w	d4,$0416(a6)
	move.w	d2,d4
	add.w	d4,d4
	mulu.w	$0410(a6),d4
	add.w	d0,d0
	move.w	d0,$0418(a6)
	add.w	d0,d4
*	add.l	#$00c00000,d4
	add.l	$95c,d4
	move.l	d4,$040c(a6)
	add.w	d1,d1
	move.w	d1,$041a(a6)
	move.w	$0410(a6),d0
	sub.w	$0414(a6),d0
	add.w	d0,d0
	move.w	d0,$0412(a6)
	movem.l	(a7)+,d0-d5
	rts

L000cc0:
	move.w	$0414(a6),d0
	mulu.w	$0416(a6),d0
	cmp.l	#$00080000,d0
	bls	L000cf6
	move.w	$0416(a6),-(a7)
	move.w	#$0200,$0416(a6)
	bsr	L000cf6
	move.w	(a7)+,d0
	sub.w	#$0200,d0
	move.w	d0,$0416(a6)
	addi.w	#$0010,$040c(a6)
	bsr	L000cf6
	move.w	#$0200,$0416(a6)
	rts

L000cf6:
	bsr	L00151a
	movea.l	$040c(a6),a0
	movea.l	$0424(a6),a1
	bsr	L001450
	move.w	$0416(a6),d0
	subq.w	#1,d0
L000d0c:
	move.w	d0,-(a7)
	moveq.l	#$00,d4
	move.w	$0414(a6),d4
L000d14:
	cmp.l	d3,d4
	bcs	L000f0c
	sub.w	d3,d4
	subq.w	#1,d3
	beq	L000d26
	move.w	d3,d0
	bsr	L000f24
L000d26:
	move.w	$0402(a6),d1
	bne	L000d4c
	subq.w	#4,d7
	bcc	L000d40
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L000d3c
	bsr	L0015ba
L000d3c:
	swap.w	d5
	move.w	(a5)+,d5
L000d40:
	move.l	d5,d2
	lsr.l	d7,d2
	and.w	#$000f,d2
	bra	L000e2a
L000d4c:
	subq.w	#1,d1
	bne	L000d70
	subq.w	#8,d7
	bcc	L000d64
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L000d60
	bsr	L0015ba
L000d60:
	swap.w	d5
	move.w	(a5)+,d5
L000d64:
	move.l	d5,d2
	lsr.l	d7,d2
	and.w	#$00ff,d2
	bra	L000e2a
L000d70:
	dbf	d7,L000d80
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L000d7e
	bsr	L0015ba
L000d7e:
	move.w	(a5)+,d5
L000d80:
	btst.l	d7,d5
	bne	L000dd6
	cmpi.w	#$0003,$0402(a6)
	beq	L000daa
	sub.w	#$000f,d7
	bcc	L000da2
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L000d9e
	bsr	L0015ba
L000d9e:
	swap.w	d5
	move.w	(a5)+,d5
L000da2:
	move.l	d5,d2
	lsr.l	d7,d2
	add.w	d2,d2
	bra	L000dc4
L000daa:
	sub.w	#$0010,d7
	bcc	L000dc0
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L000dbc
	bsr	L0015ba
L000dbc:
	swap.w	d5
	move.w	(a5)+,d5
L000dc0:
	move.l	d5,d2
	lsr.l	d7,d2
L000dc4:
	move.w	$0400(a6),d1
	move.w	$02(a6,d1.w),d1
	move.w	d1,$0400(a6)
	move.w	d2,$00(a6,d1.w)
	bra	L000e2a
L000dd6:
	subq.w	#7,d7
	bcc	L000dea
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L000de6
	bsr	L0015ba
L000de6:
	swap.w	d5
	move.w	(a5)+,d5
L000dea:
	move.l	d5,d0
	lsr.l	d7,d0
	and.w	#$007f,d0
	lsl.w	#3,d0
	cmp.w	$0400(a6),d0
	beq	L000e26
	move.w	$02(a6,d0.w),d1
	move.w	$04(a6,d0.w),d2
	move.w	d1,$02(a6,d2.w)
	move.w	d2,$04(a6,d1.w)
	move.w	$0400(a6),d1
	move.w	$02(a6,d1.w),d2
	move.w	d0,$02(a6,d1.w)
	move.w	d2,$02(a6,d0.w)
	move.w	d0,$04(a6,d2.w)
	move.w	d1,$04(a6,d0.w)
	move.w	d0,$0400(a6)
L000e26:
	move.w	$00(a6,d0.w),d2
L000e2a:
	movea.l	a0,a2
	movea.l	a1,a3
	move.w	d2,(a0)+
	addq.l	#1,a1
	dbf	d7,L000e42
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L000e40
	bsr	L0015ba
L000e40:
	move.w	(a5)+,d5
L000e42:
	btst.l	d7,d5
	beq	L000f00
	move.w	$0410(a6),d0
	add.w	d0,d0
	move.w	$0414(a6),d1
L000e52:
	dbf	d7,L000e62
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L000e60
	bsr	L0015ba
L000e60:
	move.w	(a5)+,d5
L000e62:
	btst.l	d7,d5
	bne	L000ecc
	dbf	d7,L000e76
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L000e74
	bsr	L0015ba
L000e74:
	move.w	(a5)+,d5
L000e76:
	btst.l	d7,d5
	beq	L000e88
	lea.l	-$02(a2,d0.w),a2
	lea.l	-$01(a3,d1.w),a3
	move.w	d2,(a2)
	st.b	(a3)
	bra	L000e52
L000e88:
	dbf	d7,L000e98
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L000e96
	bsr	L0015ba
L000e96:
	move.w	(a5)+,d5
L000e98:
	btst.l	d7,d5
	beq	L000f00
	dbf	d7,L000eac
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L000eaa
	bsr	L0015ba
L000eaa:
	move.w	(a5)+,d5
L000eac:
	btst.l	d7,d5
	bne	L000ebe
	lea.l	-$04(a2,d0.w),a2
	lea.l	-$02(a3,d1.w),a3
	move.w	d2,(a2)
	st.b	(a3)
	bra	L000e52
L000ebe:
	lea.l	$04(a2,d0.w),a2
	lea.l	$02(a3,d1.w),a3
	move.w	d2,(a2)
	st.b	(a3)
	bra	L000e52
L000ecc:
	dbf	d7,L000edc
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L000eda
	bsr	L0015ba
L000eda:
	move.w	(a5)+,d5
L000edc:
	btst.l	d7,d5
	bne	L000ef0
	lea.l	$00(a2,d0.w),a2
	lea.l	$00(a3,d1.w),a3
	move.w	d2,(a2)
	st.b	(a3)
	bra	L000e52
L000ef0:
	lea.l	$02(a2,d0.w),a2
	lea.l	$01(a3,d1.w),a3
	move.w	d2,(a2)
	st.b	(a3)
	bra	L000e52
L000f00:
	bsr	L001450
	tst.l	d4
	bne	L000d14
	bra	L000f12
L000f0c:
	move.w	d4,d0
	bsr	L000f24
	sub.l	d4,d3
L000f12:
	adda.w	$0412(a6),a0
	move.w	(a7)+,d0
	dbf	d0,L000d0c
	rts

L000f1e:
	tst.b	(a1)+
	beq	L000f2a
	move.w	(a0)+,d2
L000f24:
	dbf	d0,L000f1e
	rts

L000f2a:
	move.w	d2,(a0)+
	dbf	d0,L000f1e
	rts

L000f32:
	move.w	$0414(a6),d0
	mulu.w	$0416(a6),d0
	cmp.l	#$00080000,d0
	bls	L000f68
	move.w	$0416(a6),-(a7)
	move.w	#$0200,$0416(a6)
	bsr	L000f68
	move.w	(a7)+,d0
	sub.w	#$0200,d0
	move.w	d0,$0416(a6)
	addi.w	#$0010,$040c(a6)
	bsr	L000f68
	move.w	#$0200,$0416(a6)
	rts

L000f68:
	bsr	L0014d2
	movea.l	$040c(a6),a0
	movea.l	$0424(a6),a1
	moveq.l	#$00,d3
	move.w	$0416(a6),d1
	subq.w	#1,d1
L000f7c:
	move.w	$0414(a6),d2
	subq.w	#1,d2
L000f82:
	addq.l	#1,d3
	addq.l	#2,a0
	tst.b	(a1)+
	dbne	d2,L000f82
	beq	L000fa8
	move.l	d3,d0
	bsr	L00135e
	move.w	-$0002(a0),d0
	move.w	d1,-(a7)
	bsr	L00122a
	move.w	(a7)+,d1
	bsr	L000fba
	moveq.l	#$00,d3
	dbf	d2,L000f82
L000fa8:
	adda.w	$0412(a6),a0
	dbf	d1,L000f7c
	addq.l	#1,d3
	move.l	d3,d0
	bsr	L00135e
	rts

L000fba:
	movem.l	d1-d3/a0-a1,-(a7)
	move.w	-(a0),d2
	subq.l	#1,a1
	move.l	a0,d4
	move.w	$0410(a6),d0
	add.w	d0,d0
	movea.w	d0,a2
	movea.w	$0414(a6),a3
	subq.w	#1,d0
	and.w	d0,d4
	moveq.l	#$00,d3
	move.w	d1,d3
	bra	L0011e6
L000fdc:
	adda.w	a2,a0
	adda.w	a3,a1
	tst.b	(a1)
	beq	L00102c
	cmp.w	(a0),d2
	bne	L00102c
	bset.l	#$1f,d3
	bne	L001002
	dbf	d7,L001000
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L000ffe
	bsr	L0015ea
L000ffe:
	moveq.l	#$00,d5
L001000:
	bset.l	d7,d5
L001002:
	dbf	d7,L001014
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001012
	bsr	L0015ea
L001012:
	moveq.l	#$00,d5
L001014:
	bset.l	d7,d5
	dbf	d7,L001028
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001026
	bsr	L0015ea
L001026:
	moveq.l	#$00,d5
L001028:
	bra	L0011e4
L00102c:
	subq.w	#2,d4
	cmp.w	$0418(a6),d4
	blt	L001088
	tst.b	-$0001(a1)
	beq	L001088
	cmp.w	-$0002(a0),d2
	bne	L001088
	subq.l	#2,a0
	subq.l	#1,a1
	bset.l	#$1f,d3
	bne	L00105e
	dbf	d7,L00105c
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L00105a
	bsr	L0015ea
L00105a:
	moveq.l	#$00,d5
L00105c:
	bset.l	d7,d5
L00105e:
	dbf	d7,L001070
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L00106e
	bsr	L0015ea
L00106e:
	moveq.l	#$00,d5
L001070:
	dbf	d7,L001082
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001080
	bsr	L0015ea
L001080:
	moveq.l	#$00,d5
L001082:
	bset.l	d7,d5
	bra	L0011e4
L001088:
	addq.w	#4,d4
	cmp.w	$041a(a6),d4
	bgt	L0010e6
	tst.b	$0001(a1)
	beq	L0010e6
	cmp.w	$0002(a0),d2
	bne	L0010e6
	addq.l	#2,a0
	addq.l	#1,a1
	bset.l	#$1f,d3
	bne	L0010ba
	dbf	d7,L0010b8
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0010b6
	bsr	L0015ea
L0010b6:
	moveq.l	#$00,d5
L0010b8:
	bset.l	d7,d5
L0010ba:
	dbf	d7,L0010cc
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0010ca
	bsr	L0015ea
L0010ca:
	moveq.l	#$00,d5
L0010cc:
	bset.l	d7,d5
	dbf	d7,L0010e0
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0010de
	bsr	L0015ea
L0010de:
	moveq.l	#$00,d5
L0010e0:
	bset.l	d7,d5
	bra	L0011e4
L0010e6:
	subq.w	#6,d4
	cmp.w	$0418(a6),d4
	blt	L001166
	tst.b	-$0002(a1)
	beq	L001166
	cmp.w	-$0004(a0),d2
	bne	L001166
	subq.l	#4,a0
	subq.l	#2,a1
	bset.l	#$1f,d3
	bne	L001118
	dbf	d7,L001116
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001114
	bsr	L0015ea
L001114:
	moveq.l	#$00,d5
L001116:
	bset.l	d7,d5
L001118:
	dbf	d7,L00112a
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001128
	bsr	L0015ea
L001128:
	moveq.l	#$00,d5
L00112a:
	dbf	d7,L00113c
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L00113a
	bsr	L0015ea
L00113a:
	moveq.l	#$00,d5
L00113c:
	dbf	d7,L00114e
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L00114c
	bsr	L0015ea
L00114c:
	moveq.l	#$00,d5
L00114e:
	bset.l	d7,d5
	dbf	d7,L001162
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001160
	bsr	L0015ea
L001160:
	moveq.l	#$00,d5
L001162:
	bra.w	L0011e4
L001166:
	addq.w	#8,d4
	cmp.w	$041a(a6),d4
	bgt	L0011ea
	tst.b	$0002(a1)
	beq	L0011ea
	cmp.w	$0004(a0),d2
	bne	L0011ea
	addq.l	#4,a0
	addq.l	#2,a1
	bset.l	#$1f,d3
	bne	L001198
	dbf	d7,L001196
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001194
	bsr	L0015ea
L001194:
	moveq.l	#$00,d5
L001196:
	bset.l	d7,d5
L001198:
	dbf	d7,L0011aa
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0011a8
	bsr	L0015ea
L0011a8:
	moveq.l	#$00,d5
L0011aa:
	dbf	d7,L0011bc
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0011ba
	bsr	L0015ea
L0011ba:
	moveq.l	#$00,d5
L0011bc:
	dbf	d7,L0011ce
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0011cc
	bsr	L0015ea
L0011cc:
	moveq.l	#$00,d5
L0011ce:
	bset.l	d7,d5
	dbf	d7,L0011e2
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0011e0
	bsr	L0015ea
L0011e0:
	moveq.l	#$00,d5
L0011e2:
	bset.l	d7,d5
L0011e4:
	clr.b	(a1)
L0011e6:
	dbf	d3,L000fdc
L0011ea:
	tst.l	d3
	bpl	L001212
	dbf	d7,L001200
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0011fe
	bsr	L0015ea
L0011fe:
	moveq.l	#$00,d5
L001200:
	dbf	d7,L001212
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001210
	bsr	L0015ea
L001210:
	moveq.l	#$00,d5
L001212:
	dbf	d7,L001224
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001222
	bsr	L0015ea
L001222:
	moveq.l	#$00,d5
L001224:
	movem.l	(a7)+,d1-d3/a0-a1
	rts

L00122a:
	move.w	$0402(a6),d1
	bne	L001250
	ext.l	d0
	subq.w	#4,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L00124e
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L00124a
	bsr	L0015ea
L00124a:
	clr.w	d5
	swap.w	d5
L00124e:
	rts

L001250:
	subq.w	#1,d1
	bne	L001274
	ext.l	d0
	subq.w	#8,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L001272
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L00126e
	bsr	L0015ea
L00126e:
	clr.w	d5
	swap.w	d5
L001272:
	rts

L001274:
	lea.l	-$0008(a6),a2
	moveq.l	#$7f,d1
L00127a:
	lea.l	$0008(a2),a2
	cmp.w	(a2),d0
	dbeq	d1,L00127a
	bne	L0012ea
	eori.w	#$007f,d1
	movem.w	d1-d2,-(a7)
	lsl.w	#3,d1
	cmp.w	$0400(a6),d1
	beq	L0012c2
	move.w	$02(a6,d1.w),d0
	move.w	$04(a6,d1.w),d2
	move.w	d0,$02(a6,d2.w)
	move.w	d2,$04(a6,d0.w)
	move.w	$0400(a6),d0
	move.w	$02(a6,d0.w),d2
	move.w	d1,$02(a6,d0.w)
	move.w	d2,$02(a6,d1.w)
	move.w	d1,$04(a6,d2.w)
	move.w	d0,$04(a6,d1.w)
	move.w	d1,$0400(a6)
L0012c2:
	movem.w	(a7)+,d1-d2
	ext.l	d1
	or.b	#$80,d1
	subq.w	#8,d7
	rol.l	d7,d1
	or.l	d1,d5
	tst.w	d7
	bpl	L0012e8
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0012e4
	bsr	L0015ea
L0012e4:
	clr.w	d5
	swap.w	d5
L0012e8:
	rts

L0012ea:
	move.w	$0400(a6),d1
	move.w	$02(a6,d1.w),d1
	move.w	d1,$0400(a6)
	move.w	d0,$00(a6,d1.w)
	cmpi.w	#$0003,$0402(a6)
	beq	L001326
	lsr.w	#1,d0
	ext.l	d0
	sub.w	#$0010,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L001324
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001320
	bsr	L0015ea
L001320:
	clr.w	d5
	swap.w	d5
L001324:
	rts

L001326:
	dbf	d7,L001338
	moveq.l	#$0f,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001336
	bsr	L0015ea
L001336:
	moveq.l	#$00,d5
L001338:
	and.l	#$0000ffff,d0
	sub.w	#$0010,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L00135c
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001358
	bsr	L0015ea
L001358:
	clr.w	d5
	swap.w	d5
L00135c:
	rts

L00135e:
	movem.l	d0-d4,-(a7)
	move.l	d0,d4
	moveq.l	#$00,d1
	moveq.l	#$00,d3
	moveq.l	#$01,d2
L00136a:
	addq.w	#1,d1
	add.l	d2,d2
	add.l	d2,d3
	cmp.l	d3,d4
	bhi	L00136a
	addq.l	#1,d4
	sub.l	d2,d4
	subq.l	#1,d2
	and.l	d2,d4
	subq.l	#1,d2
	cmp.w	#$0010,d1
	bhi	L0013c2
	sub.w	d1,d7
	rol.l	d7,d2
	or.l	d2,d5
	tst.w	d7
	bpl	L0013a0
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L00139c
	bsr	L0015ea
L00139c:
	clr.w	d5
	swap.w	d5
L0013a0:
	sub.w	d1,d7
	rol.l	d7,d4
	or.l	d4,d5
	tst.w	d7
	bpl	L0013bc
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0013b8
	bsr	L0015ea
L0013b8:
	clr.w	d5
	swap.w	d5
L0013bc:
	movem.l	(a7)+,d0-d4
	rts

L0013c2:
	moveq.l	#$10,d3
	sub.w	d3,d1
	move.l	d2,d0
	clr.w	d0
	swap.w	d0
	sub.w	d1,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L0013e8
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L0013e4
	bsr	L0015ea
L0013e4:
	clr.w	d5
	swap.w	d5
L0013e8:
	moveq.l	#$00,d0
	move.w	d2,d0
	sub.w	d3,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L001408
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001404
	bsr	L0015ea
L001404:
	clr.w	d5
	swap.w	d5
L001408:
	move.l	d4,d0
	clr.w	d0
	swap.w	d0
	sub.w	d1,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L00142a
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001426
	bsr	L0015ea
L001426:
	clr.w	d5
	swap.w	d5
L00142a:
	moveq.l	#$00,d0
	move.w	d4,d0
	sub.w	d3,d7
	rol.l	d7,d0
	or.l	d0,d5
	tst.w	d7
	bpl	L00144a
	add.w	#$0010,d7
	move.w	d5,(a5)+
	subq.l	#2,d6
	bne	L001446
	bsr	L0015ea
L001446:
	clr.w	d5
	swap.w	d5
L00144a:
	movem.l	(a7)+,d0-d4
	rts

L001450:
	moveq.l	#$00,d0
L001452:
	addq.w	#1,d0
	dbf	d7,L001464
	moveq.l	#$0f,d7
	subq.l	#2,d6
	bcc	L001462
	bsr	L0015ba
L001462:
	move.w	(a5)+,d5
L001464:
	btst.l	d7,d5
	bne	L001452
	moveq.l	#$01,d3
	lsl.l	d0,d3
	subq.l	#1,d3
	cmp.w	#$0010,d0
	bcc	L001492
	sub.w	d0,d7
	bcc	L001488
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L001484
	bsr	L0015ba
L001484:
	swap.w	d5
	move.w	(a5)+,d5
L001488:
	move.l	d5,d1
	lsr.l	d7,d1
	and.l	d3,d1
	add.l	d1,d3
	rts

L001492:
	sub.w	#$0010,d0
	sub.w	d0,d7
	bcc	L0014aa
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L0014a6
	bsr	L0015ba
L0014a6:
	swap.w	d5
	move.w	(a5)+,d5
L0014aa:
	move.l	d5,d1
	lsr.l	d7,d1
	sub.w	#$0010,d7
	bcc	L0014c4
	add.w	#$0010,d7
	subq.l	#2,d6
	bcc	L0014c0
	bsr	L0015ba
L0014c0:
	swap.w	d5
	move.w	(a5)+,d5
L0014c4:
	move.l	d5,d0
	lsr.l	d7,d0
	swap.w	d1
	move.w	d0,d1
	and.l	d3,d1
	add.l	d1,d3
	rts

L0014d2:
	movem.l	d0-d4/a0-a1,-(a7)
	moveq.l	#$ff,d2
	cmpi.w	#$0002,$0402(a6)
	bne	L0014e2
	subq.w	#1,d2
L0014e2:
	movea.l	$040c(a6),a0
	movea.l	$0424(a6),a1
	move.w	(a0),d0
	not.w	d0
	move.w	$0416(a6),d3
	subq.w	#1,d3
L0014f4:
	move.w	$0414(a6),d4
	subq.w	#1,d4
L0014fa:
	move.w	(a0),d1
	and.w	d2,d1
	cmp.w	d1,d0
	sne.b	(a1)+
	beq	L001506
	move.w	d1,d0
L001506:
	move.w	d1,(a0)+
	dbf	d4,L0014fa
	adda.w	$0412(a6),a0
	dbf	d3,L0014f4
	movem.l	(a7)+,d0-d4/a0-a1
	rts

L00151a:
	movem.l	d0-d7/a0-a2,-(a7)
	movea.l	$0424(a6),a0
	move.w	$0414(a6),d0
	mulu.w	$0416(a6),d0
	adda.l	d0,a0
	moveq.l	#$7f,d1
	and.w	d0,d1
	lsr.l	#7,d0
	moveq.l	#$00,d2
	move.l	d2,d3
	move.l	d2,d4
	move.l	d2,d5
	move.l	d2,d6
	move.l	d2,d7
	movea.l	d2,a1
	movea.l	d2,a2
	bra	L001546
L001544:
	move.b	d2,-(a0)
L001546:
	dbf	d1,L001544
	bra	L00155c
L00154c:
	movem.l	d2-d7/a1-a2,-(a0)
	movem.l	d2-d7/a1-a2,-(a0)
	movem.l	d2-d7/a1-a2,-(a0)
	movem.l	d2-d7/a1-a2,-(a0)
L00155c:
	dbf	d0,L00154c
	movem.l	(a7)+,d0-d7/a0-a2
	rts

L001566:
	moveq.l	#$0f,d1
	move.w	$0402(a6),d0
	beq	L001576
	subq.w	#1,d0
	bne	L001584
	move.w	#$00ff,d1
L001576:
	lea.l	$00e82000,a0
L00157c:
	bsr	L0015a6
	move.w	d0,(a0)+
	dbf	d1,L00157c
L001584:
	rts

L001586:
	moveq.l	#$0f,d1
	move.w	$0402(a6),d0
	beq	L001596
	subq.w	#1,d0
	bne	L0015a4
	move.w	#$00ff,d1
L001596:
	lea.l	$00e82000,a0
L00159c:
	move.w	(a0)+,d0
	bsr	L0015b0
	dbf	d1,L00159c
L0015a4:
	rts

L0015a6:
	subq.l	#2,d6
	bcc	L0015ac
	bsr	L0015ba
L0015ac:
	move.w	(a5)+,d0
	rts

L0015b0:
	move.w	d0,(a5)+
	subq.l	#2,d6
	bne	L0015b8
	bsr	L0015ba
L0015b8:
	rts

L0015ba:
	move.l	d0,-(a7)
	tst.b	$042e(a6)
	bne	L001662
	movea.l	$041c(a6),a5
	move.l	$0420(a6),-(a7)
	pea.l	(a5)
	move.w	$0428(a6),-(a7)
	DOS	_READ
	addq.l	#6,a7
	cmp.l	(a7)+,d0
	beq	L0015e4
	tst.l	d0
	bmi	L001672
	st.b	$042e(a6)
L0015e4:
	add.l	d0,d6
	move.l	(a7)+,d0
	rts

L0015ea:
	move.l	d0,-(a7)
	movea.l	$041c(a6),a5
	move.l	$0420(a6),-(a7)
	pea.l	(a5)
	move.w	$0428(a6),-(a7)
	DOS	_WRITE
	addq.l	#6,a7
	tst.l	d0
	bmi	L001672
	cmp.l	(a7)+,d0
	bne	L001666
	add.l	d0,d6
	move.l	(a7)+,d0
	rts

L00160c:
	move.w	d5,(a5)+
	suba.l	$041c(a6),a5
	move.l	a5,-(a7)
	move.l	$041c(a6),-(a7)
	move.w	$0428(a6),-(a7)
	DOS	_WRITE
	addq.l	#6,a7
	tst.l	d0
	bmi	L001672
	cmp.l	(a7)+,d0
	bne	L001666
	rts

L00162a:
	movem.l	d0-d2/a0,-(a7)
	movea.l	a6,a0
	moveq.l	#$08,d1
	move.w	#$03f8,d2
	moveq.l	#$7f,d0
L001638:
	clr.w	(a0)+
	move.w	d1,(a0)+
	addq.w	#8,d1
	cmp.w	#$0400,d1
	bne	L001646
	clr.w	d1
L001646:
	move.w	d2,(a0)+
	addq.w	#8,d2
	cmp.w	#$0400,d2
	bne	L001652
	clr.w	d2
L001652:
	addq.l	#2,a0
	dbf	d0,L001638
	clr.w	$0400(a6)
	movem.l	(a7)+,d0-d2/a0
	rts

err_scr:
	moveq.l	#-38,d0		* 画面モードが違う
	bra	L00167a
L001662:
	moveq.l	#$dc,d0
	bra	L00167a
L001666:
	moveq.l	#$dd,d0
	bra	L00167a
L00166a:
	moveq.l	#$e1,d0
	bra	L00167a
L00166e:
	moveq.l	#$f8,d0
	bra	L00167a
L001672:
	bra	L00167a
L001674:
	moveq.l	#$e0,d0
	bra	L00167a
L001678:
	moveq.l	#$df,d0
L00167a:
	movea.l	$042a(a6),a7
	rts


*******************************************

	.data

normal_end:
	dc.w	0
	dc.l	0
	dc.l	0
x0:
	ds.l	1
y0:
	ds.l	1
x1:
	ds.l	1
y1:
	ds.l	1
scrn:
	ds.w	1
f_handle:
	ds.l	1
buff_size:
	ds.l	1
buff_start:
	ds.l	1
buff_end:
	ds.l	1
memptr:
	ds.l	1
sp_ptr:
	ds.l	1
sp_save:
	ds.l	1

*******************************
*	エラーメッセージ
*******************************
chigau_mes:
	dc.b	'画面モードがへん',0,0
read_mes:
	dc.b	'これ以上読めないのぉ',0,0
disk_full_mes:
	dc.b	'ディスクフル',0,0
write_mes:
	dc.b	'ディスクがへん',0,0
scr_mes:
	dc.b	'グラフィック画面が初期化されてないぞ',0,0
point_mes:
	dc.b	'位置の指定がおかしいの',0,0
no_mem_mes:
	dc.b	'メモリがたりないのぉ増やしてね',0,0
no_pic_mes:
	dc.b	'データ形式がおかしいの',0,0
no_file_mes:
	dc.b	'ファイルが見つからないの',0,0
dummy_mes:
	dc.b	0

	.end
