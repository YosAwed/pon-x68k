
		.public		_Dot_put

		.text
*-------------------------------------------------------
*	void	Dot_put( int x, int y, int data);	
*							
*	entry : d0, x position	( 0 - 511 )		
*		d1, y potition	( 0 - 511 )		
*		d2, putdata	( 0 - $ffff )		
*							
*	return : none					
*-------------------------------------------------------
_Dot_put
		movem.l		4(sp),d0-d2
		move.l		d3,-(sp)

		movea.l		#$c00000,a0		* GraphicVramAddress
		moveq		#10,d3
		lsl.l		#01,d0
		lsl.l		d3,d1
		add.l		d1,d0
		adda.l		d0,a0

		move.w		d2,(a0)

		move.l		(sp)+,d3
		rts

		.end
