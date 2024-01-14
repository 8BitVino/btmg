   10 REM (B)itmap (T)ile (M)ap (G)enerator - BTMG. Make a simple 14 x 14 bitmap game field
   20 REM by 8BitVino. v1.0
   30 REM Based on original code snippets from Agon demo sprite https://github.com/The-8bit-Noob
   40 REM Bitmaps generated using https://github.com/robogeek42/agon_sped
   50 MB%=&40000 : REM MEMORY BANK &40000.
   60 DIM graphics 1024 : REM ARRAY FOR PIXELS ?.
   70 DIM the_map%(13,13)
   80 VDU 23,27,16 : REM CLEAR ALL SPRITE DATA.
   90 REM MAP DATA
  100 REM Each data point corresponds to the bitmap numbering
  110 DATA 1,1,1,1,1,9,8,1,1,1,1,1,1,1
  120 DATA 1,1,1,1,9,6,4,8,1,1,1,1,1,1
  130 DATA 1,1,1,5,6,4,4,4,4,8,1,1,1,1
  140 DATA 1,1,9,6,6,4,4,0,6,4,4,4,8,1
  150 DATA 1,1,6,6,4,4,5,4,4,2,4,3,4,1
  160 DATA 2,4,4,3,6,4,3,6,3,2,3,4,4,1
  170 DATA 2,2,2,4,4,0,4,4,2,5,4,4,4,8
  180 DATA 10,2,2,2,5,2,5,4,2,3,4,6,4,7
  190 DATA 1,10,2,0,6,4,2,2,3,0,6,4,7,1
  200 DATA 1,1,4,6,5,4,6,6,3,3,3,1,1,1
  210 DATA 1,1,4,4,6,6,4,4,3,3,1,1,1,1
  220 DATA 1,1,4,6,7,1,1,10,4,3,1,1,1,1
  230 DATA 1,1,10,6,1,1,1,1,10,4,4,4,8,1
  240 DATA 1,1,1,4,1,1,1,1,1,5,4,6,7,1
  250 REM ***** LOAD BITMAPS TO MEMORY *****.
  260 REM THE PATHS BELOW NEED TO POINT TO YOUR .rgb IMAGE FILES ON YOUR SDCARD.
  270 PROCload_bitmap("lake.rgb",0,16,16) : REM CALL PROCload_bitmap (n,w,h).
  280 PROCload_bitmap("sea.rgb",1,16,16)
  290 PROCload_bitmap("mount.rgb",2,16,16)
  300 PROCload_bitmap("cities.rgb",3,16,16)
  310 PROCload_bitmap("grass.rgb",4,16,16)
  320 PROCload_bitmap("villages.rgb",5,16,16)
  330 PROCload_bitmap("trees.rgb",6,16,16)
  340 PROCload_bitmap("gbbs.rgb",7,16,16)
  350 PROCload_bitmap("bsgb.rgb",8,16,16)
  360 PROCload_bitmap("sbbg.rgb",9,16,16)
  370 PROCload_bitmap("bgsb.rgb",10,16,16)
  380 REM G=GRASS, B=BOTH (GRASS AND SEA), S=SEA
  390 MODE 8 : REM SET SCREEN MODE.
  400 VDU 17,128+7 : REM SET BG COLOUR TO GRAY.
  410 CLS : REM CLEAR THE SCREEN.
  420 VDU 23,1,0 : REM DISABLE CURSOR.
  430 PROCload_map : REM
  440 PROCprint_map
  450 REM Insert your game loop here
  460 END
  470 REM ***** LOAD BITMAP IMAGE INTO VDP RAM *****.
  480 REM F$ = FILENAME/PATH OF BITMAP FROM LINES
  490 REM N% - BITMAP NUMBER.
  500 REM W% - BITMAP WIDTH.
  510 REM H% - BITMAP HEIGHT.
  520 :
  530 DEF PROCload_bitmap(F$,N%,W%,H%) : REM ***** PROCload_bitmap *****.
  540 OSCLI("LOAD " + F$ + " " + STR$(MB%+graphics)) : REM OPERATING SYSTEM CLI COMMAND.
  550 VDU 23,27,0,N% : REM SELECT SPRITE n (equating to buffer ID numbered 64000+n).
  560 VDU 23,27,1,W%;H%; : REM LOAD COLOUR BITMAP DATA INTO CURRENT SPRITE.
  570 FOR I%=0 TO (W%*H%*3)-1 STEP 3 : REM LOOP 16x16x3 EACH PIXEL R,G,B - 1 FOR LINE END.
  580   r% = ?(graphics+I%+0) : REM RED DATA.
  590   g% = ?(graphics+I%+1) : REM GREEN DATA.
  600   b% = ?(graphics+I%+2) : REM BLUE DATA.
  610   a% = r% OR g% OR b% : REM alpha ?.
  620   VDU r%, g%, b%, a% : REM unsure ?.
  630 NEXT : REM LOOP NEXT PIXEL.
  640 ENDPROC : REM ***** END PROCload_bitmap *****.
  650 :
  660 DEFPROCload_map
  670 REM reads the data points corresponding to bitmaps and saves to a 14 x 14 array (the_map)
  680 RESTORE 110 :REM ensure that this line corresponds to the first data read point
  690 FOR i=0TO13
  700   FOR j=0TO13
  710     READ K%:the_map%(i,j)=K%
  720   NEXT
  730 NEXT
  740 ENDPROC
  750 :
  760 DEFPROCprint_map
  770 REM outputs each map location and moves 16 pixels to next. End of each line resets location
  780 XLOC%=16:YLOC%=16
  790 FOR j=0TO13
  800   FOR i=0TO13
  810     g%=the_map%(i,j) :REM sets a temporary variable for the location to be outputed
  820     VDU 23,27,0,g% : REM select the specified bitmap
  830     VDU 23,27,3,YLOC%;XLOC%;   : REM displays the bitmap
  840     XLOC%=XLOC%+16 :REM update the X location to move to the right
  850     IF i=13 THEN YLOC%=YLOC%+16:XLOC%=16 :REM at end of row move to start next line and down
  860   NEXT
  870 NEXT
  880 ENDPROC
