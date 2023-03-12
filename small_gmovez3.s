*
*	Copyleft Awed 
*
*	�p�Y���łۂ�i���́j��p�O���t�B�b�N���[�`���i�P�^�S�Łj
*	�i���肸��E�񃉃X�^�[�ް�ޭ�݁j
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
*	(x,y)-(x+63,y+63)�͈̔͂̃O���t�B�b�N�X(512*512 65535)�����1�h�b�g
*	���U�S�h�b�g���������B
*	x,y��1��n��65535�͈̔͂ɂ��邱�ƁB����𒴂������ɂ͖\������B
*	���̃��[�`�����ĂԑO�ɃO���t�B�b�N����͏��������Ă������ƁB
*	�܂��N���b�s���O�����Ă��Ȃ��̂ŁA�������ȍ��W���A�N�Z�X����Ɣ�Ԃł��傤�B
*	���Ƃ���  G_MOVE_UZ(0,0)�Ƃ��B
*	return �Ȃ�
*
_G_MOVE_UZ:
		MOVEM.L	D1-D7/A0-A6,-(SP)
		MOVE.L	4*15(SP),D1         * x
		MOVE.L	4*15+4(SP),D2       * y

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

		MOVE.L	A0,D6			*�����ʒu�ۑ�

		MOVEA.L	A0,A1
		SUBA.L	#1024,A1		*�P���C����

		MOVE.L	A1,D7			*�����ʒu�ۑ�

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


		ADD.L	#1024-128,A0		*�P���C�����ɉ�����
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_U		*�c�U�S�h�b�g��

		MOVE.L	#0,(A1)+		*���P��U�S�h�b�g��
		MOVE.L	#0,(A1)+		*���ŏ���
		MOVE.L	#0,(A1)+		* ���[�v�W�J
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

		MOVE.L	#COUNT,D4		*COUNTER �����C���p
		MOVE.L	#COUNT,D5		*COUNTER �c���C���p
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADD.L	#1024*63,D2		*63���C����
		ADDA.L	D2,A0			* AXIS Y SET

		MOVE.L	A0,D6			*�����ʒu�ۑ�

		MOVEA.L	A0,A1
		ADDA.L	#1024,A1		*�P���C����

		MOVE.L	A1,D7			*�����ʒu�ۑ�

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

		MOVE.L	#0,(A1)+		*���P��64�h�b�g��
		MOVE.L	#0,(A1)+		*���ŏ���
		MOVE.L	#0,(A1)+		* ���[�v�W�J
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

		MOVE.L	#COUNT,D4		*COUNTER �����C���p
		MOVE.L	#COUNT,D5		*COUNTER �c���C���p
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET
		MOVE.L	A0,D6			*�����ʒu�ۑ�

		MOVEA.L	A0,A1
		SUBA.L	#2,A1			*�P�h�b�g��
		MOVE.L	A1,D7			*�����ʒu�ۑ�

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

		MOVE.W	#0,(A1)

		ADD.L	#1024-128,A0		*�P���C�����ɉ�����
		ADD.L	#1024-128,A1		

		DBRA	D5,LOOP_L		*�c64�h�b�g��

		SUB.L	#2,D6			*����1�h�b�g�Â�������
		MOVEA.L	D6,A0
		SUB.L	#2,D7
		MOVEA.L	D7,A1

		MOVE.L	#COUNT,D5		*�J�E���^���Z�b�g
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

		MOVE.L	#COUNT,D4		*COUNTER �����C���p
		MOVE.L	#COUNT,D5		*COUNTER �c���C���p
		MOVE.L	#GRAM,A0		*GRAM TOP
		ASL.L	D1	
		ADD.L	#64*2,D1		*�E�[
		ADDA.L	D1,A0			* AXIS X SET
		MULU	#1024,D2
		ADDA.L	D2,A0			* AXIS Y SET
		MOVE.L	A0,D6			*�����ʒu�ۑ�

		MOVEA.L	A0,A1
		ADDA.L	#2,A1			*�P�h�b�g�E
		MOVE.L	A1,D7			*�����ʒu�ۑ�

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

		MOVE.W	#0,-2(A1)

		ADD.L	#1024+128,A0		*�P���C�����ɉ�����
		ADD.L	#1024+128,A1		

		DBRA	D5,LOOP_R		*�c64�h�b�g��

		ADD.L	#2,D6			*�E��1�h�b�g�Â�������
		MOVEA.L	D6,A0
		ADD.L	#2,D7
		MOVEA.L	D7,A1

		MOVE.L	#COUNT,D5		*�J�E���^���Z�b�g
		DBRA	D4,LOOP_R

		DOS	_SUPER
		ADDQ.W	#4,SP
		MOVEM.L	(SP)+,D1-D7/A0-A6
		RTS
