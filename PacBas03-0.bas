100 rem -----------------------------------------------------------------------
110 rem PacBas02-9.bas
120 rem PacMan type game in C64 BASIC - Proof of concept
130 rem -----------------------------------------------------------------------
140 gosub 890: rem initialize all variables
150 gosub 1070: rem draw first level or splash screen
160 rem the next line is the entry point to move to next level
170 gosub 720: rem prompt user to press key to start
180 gosub 930: rem here we intialize some varables between levels
190 gosub 1070: rem draw screen for 'next' level
200 rem -----------------------------------------------------------------------
210 rem main loop
220 rem -----------------------------------------------------------------------
230 rem ****** Move player ************
240 for i=. to 1000 step 0: rem remove 'step 0' to time 1000 loops
250 j=peek(j2):poke py+px,sc:rem read joystick, clear Pac position
260 rem ** can move north
270 if (j and js)=. then t=py-yo:if peek(t+px)<>wa then py=t:goto 380
280 rem ** can move south
290 if (j and jn)=. then t=py+yo:if peek(t+px)<>wa then py=t:goto 380
300 rem ** can move east
310 if (j and jw)=. then t=px+w1:if peek(py+t)<>wa then px=t:goto 350
320 rem ** can move west
330 if (j and je)=. then t=px-w1:if peek(py+t)<>wa then px=t
340 rem warp tunnel code
350 if py<>ty then goto 380: rem skip if we are not at tunnel row
360 if px=t1 then px=t3:goto 380: rem tunnel R->L move
370 if px=t2 then px=t4:rem tunnel L->R move
380 t=py+px: rem calcualte new Pac screen position
390 if peek(t)=gf then sr=sr+pl:goto 410:rem inc score if Pac ate pellet
400 if peek(t)=pb then sr=sr+bn:rem inc score if Pac ate a an * (bonus)
410 if sr>fs then mg=2:goto 170:rem if scored 100+ we win, set message type 2
420 poke t,pc(abs(pt-w1)):rem poke new position and toggle char
430 rem ------------------------------------------------------------------------
440 rem ****** Move Ghost 1 ***********
450 rem:goto 660: rem disable ghost for testing
460 poke gy+gx,gf:n=.:s=.:e=.:w=.:rem poke previous char to old position
470 rem can move dir +4, also toward PacMan +1
480 if peek(gy-yo+gx)<>wa then n=n+w4:if gy>py then n=n+w1
490 if peek(gy+yo+gx)<>wa then s=s+w4:if gy<py then s=s+w1
500 if peek(gy+gx+xo)<>wa then e=e+w4:if gx<px then e=e+w1
510 if peek(gy+gx-xo)<>wa then w=w+w4:if gx>px then w=w+w1
520 rem last direction moved +1, and opposite direction -3
530 if gl=w1 then n=n+1:s=s-w3:goto 580
540 if gl=w2 then s=s+1:n=n-w3:goto 580
550 if gl=w3 then e=e+1:w=w-w3:goto 580
560 if gl=w4 then w=w+1:w=w-w3:goto 580
570 rem find largest value n, s, e, w
580 if n>s then if n>e then if n>w then gy=gy-yo:gl=w1:goto 630
590 if s>n then if s>e then if s>w then gy=gy+yo:gl=w2:goto 630
600 if e>w then gx=gx+xo:gl=w3:goto 630
610 if w>. then gx=gx-xo:gl=w4
620 rem calc. ghost pos., save char. under new pos. to restore later
630 gt=gy+gx:gf = peek(gt):poke gt,gh
640 if gt = py+px then mg=1:goto 170: rem got munched!
650 rem go to top left corner of screen and print score
660 print "{home}score";sr
670 next i
680 print ti$:rem only get here if the 'step 0' is removed above
690 end
700 rem -----------------------------------------------------------------------
710 rem promt user to press return key to start
720 print "{home}score";sr;mg$(mg);" return=start q=quit"
730 get a$: if a$="q" goto 780
740 if a$="" goto 730
750 sr=0:mg=0:print "{home}score";sr;mg$(mg);"                    "
760 return
770 rem -----------------------------------------------------------------------
780 rem clear screen and quit graciously
790 print chr$(147):print"Thanks for playing!":end
800 rem -----------------------------------------------------------------------
810 rem Definitions of variables
820 rem Wall CBM ASCII char=160, "<"=60, "="=61, ">"=62, "."=46, "*"=42
830 rem Direction index: 0=none, 1=north, 2=south, 3=east, 4=west
840 rem We offset screen (0,0) by 1024 which is start of screen memory
850 rem Instead of y*40 for each Y coord update we add/subtract yo=40 offset
860 rem Joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
870 rem-----------------------------------------------------------------------
880 rem initialize variables that do not get reset between levels
890 dim pc(1):dim mg$(2):a$="":mg=0:sr=0
900 mg$(0)="          ":mg$(1)=" you lost!":mg$(2)=" you won! "
910 rem-----------------------------------------------------------------------
920 rem initialize variables that get reset on each level
930 TIME$ = "000000"   :rem reset clock
940 xo=1:yo=40:w4=4:w2=2:w1=1:rem X,y move offsets, weight constants
950 jn=2:js=1:je=4:jw=8: rem joystick bits
960 n=.:s=.:e=.:w=.:rem direction bias counters
970 px=.:py=.:pt=.:pb=42: rem Pac x,y,temp, screen char
980 gx=.:gy=.:gt=.:gl=3:gf=46:rem ghost x,y,temp,last move dir, screen char
990 pl=1:bn=25:fs=199:rem pellet and bonus score vales, finsish score
1000 pc(0)=61:pc(1)=60:rem pac screen characters
1010 wa=160:gh=65:sc=32:rem wall,ghost,space screen characters
1020 j2=56320:sr=.:rem j2 joyport 2, sr score
1030 ty=1504:t1=0:t2=39:t3=t2-1:t4=t1+1:rem warp tunnel coords
1040 return
1050 rem-----------------------------------------------------------------------
1060 rem clear screen,draw map, draw ghosts and pacman
1070 print chr$(147)
1080 PRINT "{reverse on}{cyan}                                        ";
1090 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1100 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1110 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1120 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1130 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1140 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1150 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1160 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1170 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1180 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1190 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1200 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1210 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1220 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1230 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1240 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1250 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1260 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1270 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1280 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1290 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1300 PRINT "{reverse off}{reverse on}                                        ";
1310 rem put pacman and ghost on screen at starting location
1320 rem must set the starting position for each here for each level
1330 px=19:py=17*yo+1024:gx=3:gy=5*yo+1024
1340 poke gy+gx,gh
1350 poke py+px,pc
1360 return