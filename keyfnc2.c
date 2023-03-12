/********************************************************************************/
/*	キー入力ルーチン							*/
/*										*/
/*	優先順位　　Ｊｏｙ＞カーソルキー＞テンキー				*/
/*										*/
/*	引数：現在のカーソル位置（盤面の空いている位置）			*/
/*										*/
/*	帰値：動かすべきピースの位置（盤面相対位置：ピース番号ではない）	*/
/*										*/
/*										*/
/*	Write	:  1992-05-23	Funky						*/
/*	Re-write								*/
/*								Project	K･BOX	*/
/********************************************************************************/

#include	<doslib.h>
#include	<iocslib.h>
#include	<stdio.h>
#include	<stdlib.h>

int	move_cur( int curplace );
int	move_cur_auto( int curplace ,int previous);
int	G_key( void );

static	int	Hcut = 8;	/*水平分割数*/
static	int	Vcut = 8;	/*垂直分割数*/

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
	joy = joy & 0x0F;				/*ボタンデータの切り落とし*/
	if( joy == 0 ) {
		joy = G_key();
	}

	switch ( joy ) {
	case 1:							/*上操作*/
		peace = curplace + 10;
		if ( peace > (((Vcut-1)*10) + Hcut )) peace = 0;/*括弧付けまくり（笑）*/
		break;
	case 2:							/*下操作*/
		peace = curplace - 10;
		if ( peace < 1 ) peace = 0;
		break;
	case 4:							/*左操作*/
		peace = curplace + 1;
		if (( peace % 10 ) > Hcut ) peace = 0;
		break;
	case 8:							/*右操作*/
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
/*	キーマトリクスから、キー押し下げを判定する			*/
/*	判別は、カーソルキー優先					*/
/*	複数押し下げでは動作しない					*/
/************************************************************************/
int	G_key()
{
int	cur,ten1,ten2;
int	move;

	KFLUSHIO( 0xFF );/*バッファが溜まるからフラッシュするだけ（テンキーの時用）*/
	cur  = BITSNS( 7 );					/*カーソルキー優先*/
	if ( cur == 0 ) {
		ten1 = BITSNS( 8 );
		ten2 = BITSNS( 9 );
		ten1 = ( ten1 & 0x90 );			/*不用なキーデータの切り落とし*/
		ten2 = ( ten2 & 0x12 );			/*不用なキーデータの切り落とし*/

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
		cur = ( cur & 0x78 );			/*カーソルキーの判定*/
		if ( cur == 0x10 ) {
			move = 1;					/*↑*/
		} else if ( cur == 0x40 ) {
			move = 2;					/*↓*/
		} else if ( cur == 0x08 ) {
			move = 4;					/*←*/
		} else if ( cur == 0x20 ) {
			move = 8;					/*→*/
		} else {
			move = 0;
		}
	}
	return( move );
}

/* パズル制作用仮想入力ルーチン by Dewa */

int	move_cur_auto( int curplace , int previous )
{
int	joy = 0;
int	peace = 0;

	while (peace == 0 || peace == previous){
		joy = rand() % 4;

		switch ( joy ) {
		case 0:							/*上操作*/
			peace = curplace + 10;
			if ( peace > (((Vcut-1)*10) + Hcut )) peace = 0;/*括弧付けまくり（笑）*/
			break;
		case 1:							/*下操作*/
			peace = curplace - 10;
			if ( peace < 1 ) peace = 0;
			break;
		case 2:							/*左操作*/
			peace = curplace + 1;
			if (( peace % 10 ) > Hcut ) peace = 0;
			break;
		case 3:							/*右操作*/
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