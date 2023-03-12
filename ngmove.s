*
*	Copyleft Awed 
*
*	�p�Y���łۂ�i���́j��p�O���t�B�b�N���[�`���i�P�^�S�Łj
*	(N dot �ړ��o�[�W����)
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
*	(x,y)-(x+63,y+63)�͈̔͂̃O���t�B�b�N�X(512*512 65535)�����n�h�b�g
*	���U�S�h�b�g���������B
*	x,y��1��n��65535�͈̔͂ɂ��邱�ƁB����𒴂������ɂ͖\������B
*	���̃��[�`�����ĂԑO�ɃO���t�B�b�N����͏��������Ă������ƁB
*	�܂��N���b�s���O�����Ă��Ȃ��̂ŁA�������ȍ��W���A�N�Z�X����Ɣ�Ԃł��傤�B
*	���Ƃ���  G_MOVE_U(0,0,10)�Ƃ��B
*	return �Ȃ�
*
_G_MOVE_U:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y
		MOVE.L	4*15+8(SP),D3       * n

		CLR.L	-(SP)
		DOS	_SUPER
		MOVE.L	D0,(SP)

		MOVE.L	#COUNT,D4		*COUNTER �����C���p
		MOVE.L	#COUNT,D5		*COUNTER �c���C���p
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#1024,D3
		SUBA.L	D3,A1			*N���C����

LOOP_U:
		MOVE.L	(A0)+,(A1)+		*���P��64�h�b�g��
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


		ADD.L	#1024-128,A0	*�P���C�����ɉ�����
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_U		*�c�U�S�h�b�g��

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

		MOVE.L	#COUNT,D4		*COUNTER �����C���p
		MOVE.L	#COUNT,D5		*COUNTER �c���C���p
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADD.L	#1024*63,D2		*63���C����
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#1024,D3
		ADDA.L	D3,A1			*N���C����

LOOP_D:
		MOVE.L	(A0)+,(A1)+		*���P��64�h�b�g��
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

		SUB.L	#1024+128,A0		*�P���C����ɏグ��
		SUB.L	#1024+128,A1		

		DBRA	D5,LOOP_D		*�c64�h�b�g��

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

		MOVE.L	#COUNT,D4		*COUNTER �����C���p
		MOVE.L	#COUNT,D5		*COUNTER �c���C���p
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#2,D3
		SUBA.L	D3,A1			*N�h�b�g��

LOOP_L:
		MOVE.L	(A0)+,(A1)+		*���P��64�h�b�g��
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

		ADD.L	#1024-128,A0		*�P���C�����ɉ�����
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_L		*�c64�h�b�g��

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

		MOVE.L	#COUNT,D4		*COUNTER �����C���p
		MOVE.L	#COUNT,D5		*COUNTER �c���C���p
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADD.L	#64*2,D1		*�E�[
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET

		MOVEA.L	A0,A1
		MULU	#2,D3
		ADDA.L	D3,A1			*N�h�b�g�E

LOOP_R:
		MOVE.L	-(A0),-(A1)		*���P��64�h�b�g��
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

		ADD.L	#1024+128,A0		*�P���C�����ɉ�����
		ADD.L	#1024+128,A1		

		DBRA	D5,LOOP_R		*�c64�h�b�g��

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS
