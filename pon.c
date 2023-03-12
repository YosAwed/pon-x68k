/* おくとぱすＸのパズルでＧｏＧｏ！　main program     */
/*            		  first edition 92/ 5/24       */
/*    		            2nd edition 92/ 6/04       */
/*      	            3nd edition 92/ 6/06       */
/*          	    	4th edition 92/ 6/20       */
/*         	     	    5th edition 92/11/18       */
/*         	     	    6th edition 93/01/16       */
/*         	     	    7th edition 93/01/30       */
/*         	     	    8th edition 93/02/21       */
/*        	                                       */
/*			     by Awed                           */
/*			        Kurinpa                        */
/*			       	  		                       */

#include <stdio.h>
#include <stdlib.h>
#include <io.h>
#include <iocslib.h>
#include <math.h>
#include <doslib.h>
#include <graph.h>
#include <basic0.h>
#include <sprite.h>
#include "sp_pattern.h"


#define	TRYNUM	 	1000
#define MAXPIECE	64
#define	RANKNUM	 	100
#define RANKUP		10

volatile unsigned short *x0 = (unsigned short*)0xe80018;
volatile unsigned short *y0 = (unsigned short*)0xe8001a;
volatile unsigned short *x1 = (unsigned short*)0xe8001c;
volatile unsigned short *y1 = (unsigned short*)0xe8001e;
volatile unsigned short *x2 = (unsigned short*)0xe80020;
volatile unsigned short *y2 = (unsigned short*)0xe80022;
volatile unsigned short *x3 = (unsigned short*)0xe80024;
volatile unsigned short *y3 = (unsigned short*)0xe80026;


extern int	move_cur( int curplace );
extern int	move_cur_auto( int curplace ,int previous);
extern void	G_MOVE_U(int x, int y, int n);
extern void	G_MOVE_D(int x, int y, int n);
extern void	G_MOVE_R(int x, int y, int n);
extern void	G_MOVE_L(int x, int y, int n);
extern void	G_MOVE_UZ(int x, int y);
extern void	G_MOVE_DZ(int x, int y);
extern void	G_MOVE_LZ(int x, int y);
extern void	G_MOVE_RZ(int x, int y);
extern void	apic_load(char *fname , int x, int y);
extern void	Dot_put(int x, int y, int color);

extern void	mdzplay();
extern void	mdzstop();
extern int	mdztransfer(char *buffer, int length);
extern short int getloopcounter();
/*extern int	pdztransfer(char *buffer, int length);*/

void	wait(int num);
void	swap(char a[], int i, int j);
void	gameover();
void	sp_ini();
void	make_r_window(int x, int y,int round);
void	make_s_window(int space, int trylimit);
void 	reset_screen();
void 	move_screen();
void 	delay(int d);
void	erase_staff(unsigned char* back);

FILE *musfp;
/*FILE *pcm1,*pcm2,*pcm3;*/
char *buffer,*m1,*m2,*m3,*m4,*m5,*m6;
char *pbuf1,*pbuf2,*pbuf3;
/*char *p1,*p2,*p3;
int plen1,plen2,plen3;*/
int length ;
int loopc;

void 
main()
{

	int blankplace;
	int previous;
	int move_p;
	int ranknum;          /*パズル初期化移動回数　多いほど難しいはず。*/
	int tmp;

	int i, x , y , c , idx ;	/* タイトルロゴ（その他）座標変数 */
	int    x2, y2, c2, idx2;



	int trylimit;	    /*試行上限*/
	int ccol;
	char sflag;
	char round=1;
	static char buf[MAXPIECE*MAXPIECE*2];
	static char virtualmap[78];
	static unsigned char area[135252];	/* タイトルロゴ用バッファ */

	static unsigned char graphic[(99+1) * (22+1) * 2+1];
	static unsigned char music[((199-99)+1) * (22+1) * 2+1];
	static unsigned char testplay[((299-199)+1) * ((22)+1) * 2+1];
	static unsigned char prog[((399-299)+1) * ((22)+1) * 2+1];
	static unsigned char subprog[((511-397)+1) * ((22)+1) * 2+1];
	static unsigned char sp_thank[(114+1) * ((43-26)+1) * 2+1];
	static unsigned char allright[((272-117)+1) * ((44-25)+1) * 2+1];
	static unsigned char project[((434-278)+1) * ((48-25)+1) * 2+1];
	static unsigned char awed[84 * 22 * 2+1];
	static unsigned char kuri[((158-91)+1) * ((71-050)+1) * 2+1];
	static unsigned char funk[((244-160)+1) * ((71-50)+1) * 2+1];
	static unsigned char hary[((315-250)+1) * ((71-50)+1) * 2+1];
	static unsigned char sobo[((386-322)+1) * ((71-50)+1) * 2+1];
	static unsigned char lue[((452-397)+1) * ((71-50)+1) * 2+1];
	static unsigned char oct[115 * 22 * 2+1];
	static unsigned char back[151 * 51 * 2+1];

	unsigned int usp;

	struct BOXPTR boxptr;
	struct GETPTR getptr;

/*  音楽演奏関係 */

	musfp = fopen("musicdat.mpz","rb");
	length = filelength( fileno ( musfp ));

/* m1 ??? 2363 byte */
	m1 = buffer = (char *)malloc(13000);
/* m2 ending 2377 byte*/
	m2 = m1 + 2363;
/* m3 real dream(OPM) 2434 byte*/
	m3 = m2 + 2377;
/* m4 real dream 2267 byte*/
	m4 = m3 + 2434;
/* m5 title theme 2661 byte*/
	m5 = m4 + 2267;
	m6 = m5 + 2661;
	fread(buffer , 1 , length , musfp);


	CRTMOD(12);
	G_CLR_ON();
	C_CUROFF();
	C_FNKMOD(3);
	MS_CUROF();

/*スプライト初期化*/
	sp_ini();

	C_CLS_AL();
	CONTRAST(0);
	wait(3);

	apic_load("\\pic_data\\staff.pic",0,0);

/*すたっふ取り込み　なんの工夫もしていない（笑）*/
	get(  0,  0, 99, 22,graphic,sizeof(graphic));
	get( 99,  0,199, 22,music,sizeof(music));
	get(199,  0,299, 22,testplay,sizeof(testplay));
	get(299,  0,399, 22,prog,sizeof(prog));
	get(397,  0,511, 22,subprog,sizeof(subprog));
	get(  0, 26,114, 43,sp_thank,sizeof(sp_thank));
	get(117, 25,272, 44,allright,sizeof(allright));
	get(278, 25,434, 48,project,sizeof(project));
	get(  0, 50, 83, 71,awed,sizeof(awed));
	get( 91, 50,158, 71,kuri,sizeof(kuri));
	get(160, 50,244, 71,funk,sizeof(funk));
	get(250, 50,315, 71,hary,sizeof(hary));
	get(322, 50,386, 71,sobo,sizeof(sobo));
	get(397, 50,452, 71,lue,sizeof(lue));
	get(  0, 73,114, 94,oct,sizeof(oct));
	get(  0, 100,150,150,back,sizeof(back));




/***** 取り込み（タイトルロゴ） *****/
	apic_load("\\pic_data\\title.pic",0,0);
	get(000,000,220,305,area,sizeof(area));



/* top loop */
/*while (0){*/
while (round < 4){

/* init value */
	ranknum = RANKNUM; 
	sflag = 0;
	round =1;

	mdzstop();
	/*private work  or title music*/
/*	pdztransfer(p1 ,plen1 );*/
	mdztransfer(m5 ,2261 );
	mdzplay();
	C_CLS_AL();
	CONTRAST(0);
	wait(3);
	apic_load("\\pic_data\\op.pic",0,0);
	usp = SUPER(0);
	CONTRAST(15);
	
	KFLUSHIO( 0xFF );/*バッファが溜まるからフラッシュするだけ（テンキーの時用）*/
	while( (i = JOYGET(0) == 0xff) && (i = KEYSNS() == 0)) {
		move_screen();
	}
					/* ジョイスティックかキーが押されるまで待つ */
	reset_screen();
/*もしくはコンフィグレーション*/



/* タイトルロゴ表示するし */
	idx  = 20332;
	idx2 = 135692;
	for(y=46; y<306; y+=1) {
/*		if (fmod((double)y,2.0) == 0 ) { */
		if (!(y % 2)) {
			for(x=0; x<221; x+=1) {
				c = (area[idx]<<8)+area[idx+1];
				if (c != 0xfffe)
					Dot_put(x,y,c);
				idx += 2;
			}
			idx2 -= 442;
		} else {
			for(x2=220; x2>=0; x2-=1) {
				y2 = (306 + 46) - y ;
				c2 = (area[idx2]<<8)+area[idx2+1];
				if (c2 != 0xfffe)
					Dot_put(x2,y2,c2);
				idx2 -= 2;
			}
			idx += 442;
		}
	}

	SUPER(usp);

	wait(5);
	CRTMOD(12);
	G_CLR_ON();
/* round loop */
	while ((round < 4) && (sflag != 2)){ 
		blankplace=78;
		previous=0;
		C_CLS_AL();
		for (i = 0; i <= 78 ; i++)
			virtualmap[i] = i;
		trylimit = TRYNUM;
		sflag =0;

		boxptr.x1=511-63;
		boxptr.y1=511-63;
		boxptr.x2=511;
		boxptr.y2=511;
		boxptr.color=0;
		boxptr.linestyle=0xffff;

		getptr.x1=511-63;
		getptr.y1=511-63;
		getptr.x2=511;
		getptr.y2=511;
		getptr.buf_start=(unsigned char *)buf;
		getptr.buf_end=(unsigned char *)(buf+sizeof(buf));

/*乱数の種はほかにするように。デバッグのため固定。*/
/*		srand(round);*/
		srand(TIMEGET());

		CONTRAST(0);

/*音楽演奏*/
		mdzstop();
		/*real dream or round BGM?*/
		switch (round) { 
			case 1:
				mdztransfer(m4 ,2267 );
				break;
			case 2:
				mdztransfer(m4 ,2267 );
				break;
			case 3:
				mdztransfer(m4 ,2267 );
				break;
			default:
				printf("Fatal Error! on mdzplay\n");
				break;
		} 

		mdzplay();

		switch (round) { 
			case 1:
				apic_load("\\pic_data\\gcc_1.pic",0,0); /*完成した絵を表示する*/
				break;
			case 2:
				apic_load("\\pic_data\\mg_1.pic",0,0);
				break;
			case 3:
				apic_load("\\pic_data\\oni_1.pic",0,0);
				break;
			default:
				printf("絵のデータがないのぉ\n");
				break;

		} 

		CONTRAST(15);
		GETGRM(&getptr);

		KFLUSHIO( 0xFF );/*バッファが溜まるからフラッシュするだけ（テンキーの時用）*/
		ccol = 0;
		sp_disp(1);
		make_r_window(140,140,round);
/*		locate(22,11);
		printf("らうんど　");*/

/*		switch (round){
			case 1:
				printf("いち");
				break;
			case 2:
				printf("にっ");
				break;
			case 3:
				printf("さん");
				break;
		}
*/
/*		locate(24,16);
		printf("Hit Any Key!!");
*/
		while( (i = JOYGET(0) == 0xff) && (i = KEYSNS() == 0)){ 
			TPALET(3,3000);
/*			ccol = (ccol + 1) % 65535;
*/
		}
						/* ジョイスティックかキーが押されるまで待つ */

		C_CLS_AL();
		sp_off(0,127);

/*右下を消す*/
		for( i = 0 ; i < 32 ; i++){
			delay(500);
			BOX(&boxptr);
			boxptr.x1+=1;
			boxptr.y1+=1;
			boxptr.x2-=1;
			boxptr.y2-=1;
		}	

		for ( i = 0 ; i < ranknum ; i++){

			move_p = move_cur_auto(blankplace,previous);
			if (move_p !=0){
				tmp = blankplace - move_p;
				x = ((move_p-1)%10)*64;
				y = (move_p/10)*64;
				switch(tmp) {
					case -10:
						G_MOVE_U(x,y,64);
						break;
					case  -1:
						G_MOVE_L(x,y,64);
						break;
					case   1:
						G_MOVE_R(x,y,64);
						break;
					case  10:
						G_MOVE_D(x,y,64);
						break;
					default:
						break;
				}
				fill(x,y,x+63,y+63,0);
				swap (virtualmap , blankplace , move_p);
				previous = blankplace;
				blankplace = move_p;
			}
		}
/* キー入力*/

		TPALET(3,1000);

		make_s_window(blankplace,trylimit);
/*		locate(0,0);
		printf("limit %d  \n",trylimit);
*/

	while(i = K_KEYBIT(0) != 2){          /* debug */
/*		while(1){*/
			move_p = move_cur(blankplace);
			if (move_p !=0){
				tmp = blankplace - move_p;
				x = ((move_p-1)%10)*64;
				y = (move_p/10)*64;
				switch(tmp) {
					case -10:
						G_MOVE_UZ(x,y);
						break;
					case  -1:
						G_MOVE_LZ(x,y);
						break;
					case   1:
						G_MOVE_RZ(x,y);
						break;
					case  10:
						G_MOVE_DZ(x,y);
						break;
					default:
						break;
				}
				swap (virtualmap , move_p , blankplace);
				blankplace = move_p;
				TPALET(3,1000);
				--trylimit;
				make_s_window(blankplace,trylimit);
				sp_disp(1);
/*				locate(0,0);
				printf("limit %d  \n",--trylimit);*/
/*危険音楽とかいうのもいいかも*/
/*			if (trylimit == 5 ) { 	mdzstop();
						mdztransfer( m1,799);
						mdzplay();} 
*/
				if (trylimit <= 0 ) {	gameover();
							sflag = 2; 
							break; }
			}
			for (i = 0 ; i <= 77 ; i++){
				if (virtualmap[i] != i) { sflag = 0; break;} 
				sflag = 1;
			}
			if (sflag) break;
		}
		if (sflag !=2) {
/*　ファンファーレでも入れるのがよろしいかと。 */
			mdzstop();
			mdztransfer(m6,634);
			mdzplay();
			C_CLS_AL();
			sp_off(0,127);
			PUTGRM(&getptr);

			while ( (loopc = (int)getloopcounter()) == 0);

			KFLUSHIO( 0xFF );
			while( (i = JOYGET(0) == 0xff) && (i = KEYSNS() == 0)); 
					/* ジョイスティックかキーが押されるまで待つ */


/* show time routine */
			CONTRAST(0);
			C_CLS_AL();
/*ショータイム用のＢＧＭを鳴らしたい*/
			mdzstop();	
/*			pdztransfer(p3 ,plen3 );*/
			mdztransfer(m3 ,2434 );
			mdzplay();

			switch (round) { 
				case 1:
					apic_load("\\pic_data\\gcc_2.pic",0,0); /*完成した絵を表示する*/
					break;
				case 2:
					apic_load("\\pic_data\\mg_2.pic",0,0);
					break;
				case 3:
					apic_load("\\pic_data\\oni_2.pic",0,0);
					break;
				default:
					printf("絵のデータがないのぉ。\n");
					break;
			}

			CONTRAST(15);
			KFLUSHIO( 0xFF );/*バッファが溜まるからフラッシュするだけ（テンキーの時用）*/
			while( (i = JOYGET(0) == 0xff) && (i = KEYSNS() == 0)); 
					/* ジョイスティックかキーが押されるまで待つ */

			round ++; 
			ranknum += RANKUP;
		}
	} /* end of round loop */
}/* end of top loop (title back)*/

/* ending */

	CONTRAST(0);
	wait(2);
	mdzstop();
	mdztransfer(m1,2363);
	mdzplay();
	apic_load("\\pic_data\\ending.pic",0,0);
	CONTRAST(15);

/* スタッフロール */

	put(53,316,53+100,316+22,prog,sizeof(prog));
	wait(2);
	put(80,347,80+83,347+21,awed,sizeof(awed));
	wait(4);
	erase_staff(back);

	put(53,316,53+114,316+22,subprog,sizeof(subprog));
	wait(2);
	put(80,347,80+84,347+21,funk,sizeof(funk));
	wait(4);
	erase_staff(back);

	put(53,316,53+114,316+22,subprog,sizeof(subprog));
	wait(2);
	put(80,347,80+67,347+21,kuri,sizeof(kuri));
	wait(4);
	erase_staff(back);

	put(53,316,53+114,316+22,subprog,sizeof(subprog));
	wait(2);
	put(80,347,80+55,347+21,lue,sizeof(lue));
	wait(4);
	erase_staff(back);

	put(53,316,53+114,316+17,sp_thank,sizeof(sp_thank));
	wait(2);
	put(80,347,80+65,347+21,hary,sizeof(hary));
	wait(4);
	erase_staff(back);

	put(53,316,53+100,316+22,music,sizeof(music));
	wait(2);
	put(80,347,80+67,347+21,kuri,sizeof(kuri));
	wait(4);
	erase_staff(back);

	put(53,316,53+100,316+22,testplay,sizeof(testplay));
	wait(2);
	put(80,347,80+64,347+21,sobo,sizeof(sobo));
	wait(4);
	erase_staff(back);

	put(53,316,53+99,316+22,graphic,sizeof(graphic));
	wait(2);
	put(80,347,80+114,347+21,oct,sizeof(oct));
	wait(4);
	erase_staff(back);

	put(53,316,53+155,316+19,allright,sizeof(allright));
	put(60,372,60+156,372+23,project,sizeof(project));
	wait(4);

/*while(1);*/




/*	printf("Programed by Awed/Kurinpa\n");
	printf("Presented by K.BOX\n");
	printf("お疲れさまにゃん。\n");
*/

	C_CURON();
	C_FNKMOD(0);
	G_CLR_ON();
	exit(0);


}

void
erase_staff(back)
unsigned char back[];
{

	put(53,316,53+150,316+50,back,15403);
}

void
gameover()
{
	int i;
	int ccol=0;
	mdzstop();
	G_CLR_ON();
	C_CLS_AL();
	mdztransfer(m2,2377);
/*	pdztransfer(p2,plen2);*/
	mdzplay();
	wait(2);
	locate(22,13);
	printf("げ～む　お～ば～");
	KFLUSHIO( 0xFF );/*バッファが溜まるからフラッシュするだけ（テンキーの時用）*/
	while( (i = JOYGET(0) == 0xff) && (i = KEYSNS() == 0)){
		TPALET(3,ccol);
		ccol = (ccol + 10) % 65535;
	}
}

void wait(waittime)	/* ウェイト関数 秒単位に指定しましゅ */
int	waittime;
{
	int time1, time2;
	time1 = TIMEGET();
	time2 = time1 + waittime;
	while(time1<time2) {
		time1 = TIMEGET();
	}
}



void
swap(char a[] , int i, int j)
{
	char *temp;
	temp = (char *)a[i];
	a[i] = a[j];
	a[j] = temp;
}

void
sp_ini()
{
/*	screen(1,3,1,1);*/
	sp_clr(0,255);
	sp_off(0,127);
	sp_disp(1);

	sp_def(0,c0,1);
	sp_def(1,c1,1);
	sp_def(2,c2,1);
	sp_def(3,c3,1);
	sp_def(4,c4,1);
	sp_def(5,c5,1);
	sp_def(6,c6,1);
	sp_def(7,c7,1);
	sp_def(8,c8,1);

	sp_def(9,c9,1);
	sp_def(10,c10,1);
	sp_def(11,c11,1);
	sp_def(12,c12,1);
	sp_def(13,c13,1);
	sp_def(14,c14,1);
	sp_def(15,c15,1);
	sp_def(16,c16,1);
	sp_def(17,c17,1);
	sp_def(18,c18,1);
	sp_def(19,c19,1);
	sp_def(20,c20,1);
	sp_def(21,c21,1);
	sp_def(22,c22,1);
	sp_def(23,c23,1);
	sp_def(24,c24,1);
	sp_def(25,c25,1);
	sp_def(26,c26,1);
	sp_def(27,c27,1);
	sp_def(28,c28,1);
	sp_def(29,c29,1);
	sp_def(30,c30,1);
	sp_def(31,c31,1);
	sp_def(32,c32,1);
	sp_def(33,c33,1);
	sp_def(34,c34,1);
	sp_def(35,c35,1);
	sp_def(36,c36,1);
	sp_def(37,c37,1);
	sp_def(38,c38,1);


   sp_color(0,0,1);
   sp_color(1,2114,1);
   sp_color(2,16814,1);
   sp_color(3,37630,1);
   sp_color(4,43774,1);
   sp_color(5,49982,1);
   sp_color(6,13776,1);
   sp_color(7,40920,1);
   sp_color(8,45018,1);
   sp_color(9,49116,1);
   sp_color(10,63360,1);
   sp_color(11,65506,1);
   sp_color(12,65514,1);
   sp_color(13,21140,1);
   sp_color(14,33824,1);
   sp_color(15,65534,1);


}

void
make_r_window(x,y,round)
int x,y,round;
{
/*	int x=140,y=140;
*/
	sp_move(0,x,y,0);
	sp_move(1,x+16*1,y,1);
	sp_move(2,x+16*2,y,1);
	sp_move(3,x+16*3,y,1);
	sp_move(4,x+16*4,y,1);
	sp_move(5,x+16*5,y,1);
	sp_move(6,x+16*6,y,1);
	sp_move(7,x+16*7,y,1);
	sp_move(8,x+16*8,y,1);
	sp_move(9,x+16*9,y,1);
	sp_move(10,x+16*10,y,1);
	sp_move(11,x+16*11,y,2);

	sp_move(12,x,y+16,6);
	sp_move(13,x+16*1,y+16,8);
	sp_move(14,x+16*2,y+16,8);
	sp_move(15,x+16*3,y+16,8);
	sp_move(16,x+16*4,y+16,8);
	sp_move(17,x+16*5,y+16,8);
	sp_move(18,x+16*6,y+16,8);
	sp_move(19,x+16*7,y+16,8);
switch (round){
	case 1:sp_move(20,x+16*8,y+16 +4,10); break;
	case 2:sp_move(20,x+16*8,y+16 +4,11); break;
	case 3:sp_move(20,x+16*8,y+16 +4,12); break;
}
	sp_move(21,x+16*8,y+16,8);
	sp_move(22,x+16*9,y+16,8);
	sp_move(23,x+16*10,y+16,8);
	sp_move(24,x+16*11,y+16,7);

	sp_move(25,x,y+16*2,6);
	sp_move(26,x+16*1,y+16*2,8);
	sp_move(27,x+16*2,y+16*2,8);
	sp_move(28,x+16*3,y+16*2,19);
	sp_move(29,x+16*3,y+16*2,8);
	sp_move(30,x+16*4,y+16*2,20);
	sp_move(31,x+16*4,y+16*2,8);
	sp_move(32,x+16*5,y+16*2,21);
	sp_move(33,x+16*5,y+16*2,8);
	sp_move(34,x+16*6,y+16*2,22);
	sp_move(35,x+16*6,y+16*2,8);
	sp_move(36,x+16*7,y+16*2,23);
	sp_move(37,x+16*7,y+16*2,8);
switch (round){
	case 1:sp_move(38,x+16*8,y+16*2 +4,26); break;
	case 2:sp_move(38,x+16*8,y+16*2 +4,27); break;
	case 3:sp_move(38,x+16*8,y+16*2 +4,28); break;
}
	sp_move(39,x+16*8,y+16*2,8);

	sp_move(40,x+16*9,y+16*2,8);
	sp_move(41,x+16*10,y+16*2,8);
	sp_move(42,x+16*11,y+16*2,7);

	sp_move(43,x,y+16*3,6);
	sp_move(44,x+16*1,y+16*3,8);
	sp_move(45,x+16*2,y+16*3,8);
	sp_move(46,x+16*3,y+16*3,8);
	sp_move(47,x+16*4,y+16*3,8);
	sp_move(48,x+16*5,y+16*3,8);
	sp_move(49,x+16*6,y+16*3,8);
	sp_move(50,x+16*7,y+16*3,8);
	sp_move(51,x+16*8,y+16*3,8);
	sp_move(52,x+16*9,y+16*3,8);
	sp_move(53,x+16*10,y+16*3,8);
	sp_move(54,x+16*11,y+16*3,7);

	sp_move(55,x,     y+16*4,3);
	sp_move(56,x+16*1,y+16*4,4);
	sp_move(57,x+16*2,y+16*4,4);
	sp_move(58,x+16*3,y+16*4,4);
	sp_move(59,x+16*4,y+16*4,4);
	sp_move(60,x+16*5,y+16*4,4);
	sp_move(61,x+16*6,y+16*4,4);
	sp_move(62,x+16*7,y+16*4,4);
	sp_move(63,x+16*8,y+16*4,4);
	sp_move(64,x+16*9,y+16*4,4);
	sp_move(65,x+16*10,y+16*4,4);
	sp_move(66,x+16*11,y+16*4,5);

	sp_off(67,127);
}

void
make_s_window(blank,try)
int blank,try;
{
	int x,y;
	char numstr[5];
	if (( (int)blank / 10 ) > 4) y = 0; else y = 512 - 2*16;
	if (( blank % 10 ) > 4) x = 0; else x = 512 - 8*16;


	sp_move(0,x      +1,y+16 -3,35); /* L */
	sp_move(1,x+16*1 +1,y+16 -3,36); /* im */
	sp_move(2,x+16*2 +1,y+16 -3,37); /* i */
	sp_move(3,x+16*3 +1,y+16 -3,38); /* t */

	sprintf((char *)numstr,"%4d",try);

	sp_move(4,x+16*4,y, numstr[0] == ' ' ? 24 : numstr[0] - '0' + 9);
	sp_move(5,x+16*5,y, numstr[1] == ' ' ? 24 : numstr[1] - '0' + 9);
	sp_move(6,x+16*6,y, numstr[2] == ' ' ? 24 : numstr[2] - '0' + 9);
	sp_move(7,x+16*7,y, numstr[3] == ' ' ? 24 : numstr[3] - '0' + 9);

	sp_move(8,x+16*4,y+16, numstr[0] == ' ' ? 24 : numstr[0] - '0' + 25);
	sp_move(9,x+16*5,y+16, numstr[1] == ' ' ? 24 : numstr[1] - '0' + 25);
	sp_move(10,x+16*6,y+16, numstr[2] == ' ' ? 24 : numstr[2] - '0' + 25);
	sp_move(11,x+16*7,y+16, numstr[3] == ' ' ? 24 : numstr[3] - '0' + 25);

	sp_move(12,x,     y,0);
	sp_move(13,x+16*1,y,1);
	sp_move(14,x+16*2,y,1);
	sp_move(15,x+16*3,y,1);
	sp_move(16,x+16*4,y,1);
	sp_move(17,x+16*5,y,1);
	sp_move(18,x+16*6,y,1);
	sp_move(19,x+16*7,y,2);

	sp_move(20,x,     y+16,3);
	sp_move(21,x+16*1,y+16,4);
	sp_move(22,x+16*2,y+16,4);
	sp_move(23,x+16*3,y+16,4);
	sp_move(24,x+16*4,y+16,4);
	sp_move(25,x+16*5,y+16,4);
	sp_move(26,x+16*6,y+16,4);
	sp_move(27,x+16*7,y+16,5);


	sp_off(28,127);

}

void move_screen()
{
	unsigned int i,j;
	for (i=127; i>=0; delay(5000),i--){
		if (!((j = JOYGET(0) == 0xff) && (j = KEYSNS() == 0))) break; 
		*x0 = 511-i;
		*y0 = 511-i;
		*x1 = 511-i;
		*y1 = i;
		*x2 = i;
		*y2 = 511-i;
		*x3 = i;
		*y3 = i;
	}
}

void reset_screen()
{
	*x0=*y0=*x1=*y2=511;
	*y1=*x2=*x3=*y3=0;
}

void delay(j)
int j;
{
	unsigned int i,k=0;
	for(i = 0; i< j; i++)
		k += k;
}
