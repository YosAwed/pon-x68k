*
*	Copyleft(C)1992 Awed
*
*	MLD��p�f�[�^���[�h���[�`��
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
*	buffer�̓��e��MLD�����ɓ]������B�^�C�g���̐ݒ�APCM�t�@�C���̗L����
*	�f�[�^�����ځA�e�탏�[�N�G���A�������A���t��~������B
*
*	length��1��n��65535�͈̔͂ɂ��邱�ƁB����𒴂������ɂ͖\������B
*
*	return
*		0:	����ɓ]������
*		����:	MML�o�b�t�@���s�����Ă���
*
_mdztransfer:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),A0		*Buffer
		MOVE.L	4*15+4(SP),D1		*length
		MLD	3			*�]��
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS


*****************************************************************************
*
*	char *getpdztitle()
*
*	PDZ�t�@�C�����̗L���𒲂ׂ�B����MML�o�b�t�@�ɂ���f�[�^��PDZ�t�@�C��
*	�����K�v�ȏꍇ�A���̃t�@�C����(filesearch�֐��p)���A���BPDZ�t�@�C������
*	���݂��Ȃ����NULL���A���B
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
*	MDZ�̃^�C�g�������o���B�o�b�t�@�Ƀf�[�^�����݂��Ȃ����NUL���A�����B
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
*	PDZ�f�[�^��MLD�����ɓ]������Blength�ɂ͓��ʂȈӖ������R�[�h������A
*
*	length = 0	PCM�o�b�t�@���N���A����BMML�������I�ɉ��t���Ă�PCM�p�[�g��
*			���s����Ȃ��Bbuffer�̒l�͖��Ӗ��B
*
*	length = -1	PCM�o�b�t�@���g�p�\��Ԃ��Ƌ����I�ɐݒ肷��Bbuffer�̒l��
*			���Ӗ��B
*
*	length �� 1	buffer�Ŏ������ʒu����Alength�o�C�g��MLD�����ɓ]������B
*
*	���ƁA-1��0�̓f�[�^���[�h���s��Agetpdzptr�֐��œ���ꂽ�|�C���^�ɒ���
*	�f�[�^�����[�h�������ɗp����i�f�[�^�]�����Ԃ�啝�Z�k����B�܂��o�b�t�@��
*	�����f�[�^�����[�h���Ă��Ȃ����ǂ����`�F�b�N������ɂ��p����j�B
*
*	return:	0	����ɓ]������
*		-1	�]���Ɏ��s����
*
*	��length �� 0�̎��A�A��l�͕s��ł��B
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
*	PCM�o�b�t�@�ւ̃|�C���^���A���܂��B
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
*	PCM�o�b�t�@�̑傫�����A���܂��B�����̎���pcm�o�b�t�@�ւ̒��ڃA�N�Z�X��
*	�֎~����Ă��܂��B
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
*	PCM�o�b�t�@�̃t�@�C������Ԃ��܂��B
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
*	MLD���풓���Ă��邩�`�F�b�N���܂��B
*
*	return
*		value 0      �풓���ĂȂ�
*		�@    0�ȊO�@�풓���Ă���B

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
