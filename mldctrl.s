*
*	Copyleft(C)1992 Awed 
*
*	MLD��p�R���g���[�����[�`��
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
*	���t���J�n���܂��B
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
*	���t���~���܂��B
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
*	���t���ĊJ���܂��B
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
*	���t��Ԃ��A���܂��B
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
*	�t�F�[�h�A�E�g���܂��B
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
*	�t�F�[�h�A�E�g���x��ݒ肵�܂��B
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
*	���t�J�n����̎���(OPM���荞�݉�)���A���܂��B
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
*	���[�N�G���A�ւ̃|�C���^���A���܂��B
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
*	�g���b�N�̃}�X�N�����܂��B
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
*	���[�v�J�E���^�[��Ԃ��܂��B
*
_getloopcounter:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MLD	29
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS
