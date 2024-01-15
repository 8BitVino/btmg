   10 REM (B)itmap (T)ile (M)ap (G)enerator - BTMG. Make a RANDOM 14 x 14 bitmap game field
   20 REM by 8BitVino. v1.0
   30 REM Based on original code snippets from Agon demo sprite https://github.com/The-8bit-Noob
   40 REM Bitmaps generated using https://github.com/robogeek42/agon_sped
   50 MB%=&40000 : REM MEMORY BANK &40000.
   60 DIM graphics 1024 : REM ARRAY FOR PIXELS ?.
   70 DIM the_map%(14,14)
   80 DIM object%(224) :REM Store location special coordinates in a 1x225 array (1 per tile). Can extend later for special properties on a tile
   90 VDU 23,27,16 : REM CLEAR ALL SPRITE DATA.
  100 REM MAP DATA
  110 REM Each data point corresponds to the bitmap numbering
  120 DATA 1,1,1,1,1,1,9,8,1,1,1,1,1,1,1
  130 DATA 1,1,1,1,1,9,6,4,8,1,1,1,1,1,1
  140 DATA 1,1,1,1,5,6,4,4,4,4,8,1,1,1,1
  150 DATA 1,1,1,9,6,6,4,4,0,6,4,4,4,8,1
  160 DATA 1,1,1,6,6,4,4,5,4,4,2,4,3,4,1
  170 DATA 1,2,4,4,3,6,4,3,6,3,2,3,4,4,1
  180 DATA 1,2,2,2,4,4,0,4,4,2,5,4,4,4,8
  190 DATA 1,10,2,2,2,5,2,5,4,2,3,4,6,4,7
  200 DATA 1,1,10,2,0,6,4,2,2,3,0,6,4,7,1
  210 DATA 1,1,1,4,6,5,4,6,6,3,3,3,1,1,1
  220 DATA 1,1,1,4,4,6,6,4,4,3,3,1,1,1,1
  230 DATA 1,1,1,4,6,7,1,1,10,4,3,1,1,1,1
  240 DATA 1,1,1,10,6,1,1,1,1,10,4,4,4,8,1
  250 DATA 1,1,1,1,4,1,1,1,1,1,5,4,6,7,1
  260 DATA 1,1,1,1,1,1,1,1,1,1,1,10,4,1,1
  270 REM ***** LOAD BITMAPS TO MEMORY *****.
  280 REM THE PATHS BELOW NEED TO POINT TO YOUR .rgb IMAGE FILES ON YOUR SDCARD.
  290 PROCload_bitmap("lake.rgb",0,16,16) : REM CALL PROCload_bitmap (n,w,h).
  300 PROCload_bitmap("sea.rgb",1,16,16)
  310 PROCload_bitmap("mount.rgb",2,16,16)
  320 PROCload_bitmap("cities.rgb",3,16,16)
  330 PROCload_bitmap("grass.rgb",4,16,16)
  340 PROCload_bitmap("villages.rgb",5,16,16)
  350 PROCload_bitmap("trees.rgb",6,16,16)
  360 PROCload_bitmap("gbbs.rgb",7,16,16)
  370 PROCload_bitmap("bsgb.rgb",8,16,16)
  380 PROCload_bitmap("sbbg.rgb",9,16,16)
  390 PROCload_bitmap("bgsb.rgb",10,16,16)
  400 REM G=GRASS, B=BOTH (GRASS AND SEA), S=SEA
  410 MODE 8 : REM SET SCREEN MODE.
  420 VDU 17,128+7 : REM SET BG COLOUR TO GRAY.
  430 CLS : REM CLEAR THE SCREEN.
  440 VDU 23,1,0 : REM DISABLE CURSOR.
  450 REM PROCload_map : REM dont use on random map
  460 PROCrandobjects
  470 PROCinsertrand
  480 PROCprint_map
  490 REM PROCrandobjects
  500 REM Insert your game loop here
  510 END
  520 REM ***** LOAD BITMAP IMAGE INTO VDP RAM *****.
  530 REM F$ = FILENAME/PATH OF BITMAP FROM LINES
  540 REM N% - BITMAP NUMBER.
  550 REM W% - BITMAP WIDTH.
  560 REM H% - BITMAP HEIGHT.
  570 :
  580 DEF PROCload_bitmap(F$,N%,W%,H%) : REM ***** PROCload_bitmap *****.
  590 OSCLI("LOAD " + F$ + " " + STR$(MB%+graphics)) : REM OPERATING SYSTEM CLI COMMAND.
  600 VDU 23,27,0,N% : REM SELECT SPRITE n (equating to buffer ID numbered 64000+n).
  610 VDU 23,27,1,W%;H%; : REM LOAD COLOUR BITMAP DATA INTO CURRENT SPRITE.
  620 FOR I%=0 TO (W%*H%*3)-1 STEP 3 : REM LOOP 16x16x3 EACH PIXEL R,G,B - 1 FOR LINE END.
  630   r% = ?(graphics+I%+0) : REM RED DATA.
  640   g% = ?(graphics+I%+1) : REM GREEN DATA.
  650   b% = ?(graphics+I%+2) : REM BLUE DATA.
  660   a% = r% OR g% OR b% : REM alpha ?.
  670   VDU r%, g%, b%, a% : REM unsure ?.
  680 NEXT : REM LOOP NEXT PIXEL.
  690 ENDPROC : REM ***** END PROCload_bitmap *****.
  700 :
  710 DEFPROCload_map
  720 REM reads the data points corresponding to bitmaps and saves to a 14 x 14 array (the_map)
  730 RESTORE 120 :REM ensure that this line corresponds to the first data read point
  740 FOR i=0TO14
  750   FOR j=0TO14
  760     READ K%:the_map%(i,j)=K%
  770   NEXT
  780 NEXT
  790 ENDPROC
  800 :
  810 DEFPROCprint_map
  820 REM outputs each map location and moves 16 pixels to next. End of each line resets location
  830 XLOC%=0:YLOC%=0
  840 FOR j=0TO14
  850   FOR i=0TO14
  860     g%=the_map%(i,j) :REM sets a temporary variable for the location to be outputed
  870     VDU 23,27,0,g% : REM select the specified bitmap
  880     VDU 23,27,3,YLOC%;XLOC%;   : REM displays the bitmap
  890     XLOC%=XLOC%+16 :REM update the X location to move to the right
  900     IF i=14 THEN YLOC%=YLOC%+16:XLOC%=0 :REM at end of row move to start next line and down
  910   NEXT
  920 NEXT
  930 ENDPROC
  940 DEFPROCrandobjects
  950 FOR e=0TO224
  960   object%(e)=RND(11)-1  :REM use random number generator 1-11 and substract one
  970   REM  PRINT object%(e)
  980 NEXT
  990 ENDPROC
 1000 DEFPROCinsertrand
 1010 FOR e=0TO224
 1020   XCORD%=e MOD 15 : REM Clever maths. Finds XCORD% by doing array value MODULUS 15.
 1030   YCORD%=e DIV 15 : REM Clever maths. Finds YCORD% by doing array value DIV by 15.
 1040   the_map%(XCORD%,YCORD%)=object%(e)
 1050 NEXT
 1060 ENDPROC
