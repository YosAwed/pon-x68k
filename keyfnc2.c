/********************************************************************************/
/*	�L�[���̓��[�`��							*/
/*										*/
/*	�D�揇�ʁ@�@�i�������J�[�\���L�[���e���L�[				*/
/*										*/
/*	�����F���݂̃J�[�\���ʒu�i�Ֆʂ̋󂢂Ă���ʒu�j			*/
/*										*/
/*	�A�l�F�������ׂ��s�[�X�̈ʒu�i�Ֆʑ��Έʒu�F�s�[�X�ԍ��ł͂Ȃ��j	*/
/*										*/
/*										*/
/*	Write	:  1992-05-23	Funky						*/
/*	Re-write								*/
/*								Project	K�BOX	*/
/********************************************************************************/

#include	<doslib.h>
#include	<iocslib.h>
#include	<stdio.h>
#include	<stdlib.h>

int	move_cur( int curplace );
int	move_cur_auto( int curplace ,int previous);
int	G_key( void );

static	int	Hcut = 8;	/*����������*/
static	int	Vcut = 8;	/*����������*/

#if DEBUG
void	main( void )
{
int	i;
int	move_peace;

	while (1){
		move_peace = move_cur( 22 );
		printf("move peace = %d  to  22\n",move_peace );
	}
}
#endif

int	move_cur( int curplace )
{
int	joy = 0;
int	peace = 0;

	joy = JOYGET( 0 );
	joy = ~joy;
	joy = joy & 0x0F;				/*�{�^���f�[�^�̐؂藎�Ƃ�*/
	if( joy == 0 ) {
		joy = G_key();
	}

	switch ( joy ) {
	case 1:							/*�㑀��*/
		peace = curplace + 10;
		if ( peace > (((Vcut-1)*10) + Hcut )) peace = 0;/*���ʕt���܂���i�΁j*/
		break;
	case 2:							/*������*/
		peace = curplace - 10;
		if ( peace < 1 ) peace = 0;
		break;
	case 4:							/*������*/
		peace = curplace + 1;
		if (( peace % 10 ) > Hcut ) peace = 0;
		break;
	case 8:							/*�E����*/
		peace = curplace - 1;
		if (  peace == 0 ) peace = 0;
		if (( peace % 10 ) == 0 ) peace = 0;
		break;
	case 0:
		peace = 0;
		break;
	}
	return( peace );
}
/************************************************************************/
/*	�L�[�}�g���N�X����A�L�[���������𔻒肷��			*/
/*	���ʂ́A�J�[�\���L�[�D��					*/
/*	�������������ł͓��삵�Ȃ�					*/
/************************************************************************/
int	G_key()
{
int	cur,ten1,ten2;
int	move;

	KFLUSHIO( 0xFF );/*�o�b�t�@�����܂邩��t���b�V�����邾���i�e���L�[�̎��p�j*/
	cur  = BITSNS( 7 );					/*�J�[�\���L�[�D��*/
	if ( cur == 0 ) {
		ten1 = BITSNS( 8 );
		ten2 = BITSNS( 9 );
		ten1 = ( ten1 & 0x90 );			/*�s�p�ȃL�[�f�[�^�̐؂藎�Ƃ�*/
		ten2 = ( ten2 & 0x12 );			/*�s�p�ȃL�[�f�[�^�̐؂藎�Ƃ�*/

		if ( ten1 == 0x10 && ten2 == 0 ) {
			move = 1;					/*8*/
		} else if ( ten1 == 0 && ten2 == 0x10 ) {
			move = 2;					/*2*/
		} else if ( ten1 == 0x80 && ten2 == 0 ) {
			move = 4;					/*4*/
		} else if ( ten1 == 0 && ten2 == 0x02 ) {
			move = 8;					/*6*/
		} else {
			move = 0;
		}
	} else {
		cur = ( cur & 0x78 );			/*�J�[�\���L�[�̔���*/
		if ( cur == 0x10 ) {
			move = 1;					/*��*/
		} else if ( cur == 0x40 ) {
			move = 2;					/*��*/
		} else if ( cur == 0x08 ) {
			move = 4;					/*��*/
		} else if ( cur == 0x20 ) {
			move = 8;					/*��*/
		} else {
			move = 0;
		}
	}
	return( move );
}

/* �p�Y������p���z���̓��[�`�� by Dewa */

int	move_cur_auto( int curplace , int previous )
{
int	joy = 0;
int	peace = 0;

	while (peace == 0 || peace == previous){
		joy = rand() % 4;

		switch ( joy ) {
		case 0:							/*�㑀��*/
			peace = curplace + 10;
			if ( peace > (((Vcut-1)*10) + Hcut )) peace = 0;/*���ʕt���܂���i�΁j*/
			break;
		case 1:							/*������*/
			peace = curplace - 10;
			if ( peace < 1 ) peace = 0;
			break;
		case 2:							/*������*/
			peace = curplace + 1;
			if (( peace % 10 ) > Hcut ) peace = 0;
			break;
		case 3:							/*�E����*/
			peace = curplace - 1;
			if (  peace == 0 ) peace = 0;
			if (( peace % 10 ) == 0 ) peace = 0;
			break;
		default:
			peace = 0;					/*NOT REACHED */
			break;
		}
	}
	return( peace );
}