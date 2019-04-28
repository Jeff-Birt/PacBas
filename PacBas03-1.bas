100 rem -----------------------------------------------------------------------
110 rem PacBas03-0.bas
120 rem PacMan type game in C64 BASIC - Proof of concept
130 rem -----------------------------------------------------------------------
140 gosub 820: rem initialize all variables
150 gosub 1060: rem draw first level or splash screen
160 rem the next line is the entry point to move to next level
170 gosub 650: rem prompt user to press key to start
180 gosub 910: rem here we intialize some varables between levels
190 gosub 1060: rem draw screen for 'next' level
200 rem -----------------------------------------------------------------------
210 rem main loop
220 rem -----------------------------------------------------------------------
230 rem ****** Move player ************
240 for i=. to 1000:rem step 0: rem remove 'step 0' to time 1000 loops
250 j=peek(j2) and 15:poke py+px,sc:rem read joystick, clear Pac position
260 tx=mx(j)+px:ty=my(j)+py:if peek(tx+ty)=wa then 350
270 px=tx:py=ty
280 if py<>tr then goto 310: rem skip if we are not at tunnel row
290 if px=t1 then px=t3:goto 310: rem tunnel R->L move
300 if px=t2 then px=t4:rem tunnel L->R move
310 t=py+px: rem calcualte new Pac screen position
320 if peek(t)=gf then sr=sr+pl:goto 340:rem inc score if Pac ate pellet
330 if peek(t)=pb then sr=sr+bn:rem inc score if Pac ate a an * (bonus)
340 if sr>fs then mg=2:goto 170:rem if scored 200+ we win, set message type 2
350 pt=(pt+1) and w1:poke t,pc(pt):rem poke new position and toggle char
360 rem ------------------------------------------------------------------------
370 rem ****** Move Ghost 1 ***********
380 rem:goto 660: rem disable ghost for testing
390 gt=gy+gx:poke gt,gf:n=.:s=.:e=.:w=.:rem poke prev. char to old pos
400 rem can move dir +4, also toward PacMan +1
410 if peek(gt-yo)<>wa then n=n+w4:if gy>py then n=n+w1
420 if peek(gt+yo)<>wa then s=s+w4:if gy<py then s=s+w1
430 if peek(gt+w1)<>wa then e=e+w4:if gx<px then e=e+w1
440 if peek(gt-w1)<>wa then w=w+w4:if gx>px then w=w+w1
450 rem last direction moved +1, and opposite direction -3
460 if gl=w1 then n=n+w1:s=s-w3:goto 510
470 if gl=w2 then s=s+w1:n=n-w3:goto 510
480 if gl=w3 then e=e+w1:w=w-w3:goto 510
490 if gl=w4 then w=w+w1:w=w-w3:goto 510
500 rem find largest value n, s, e, w
510 if n>s then if n>e then if n>w then gy=gy-yo:gl=w1:goto 560
520 if s>n then if s>e then if s>w then gy=gy+yo:gl=w2:goto 560
530 if e>w then gx=gx+w1:gl=w3:goto 560
540 if w>. then gx=gx-w1:gl=w4
550 rem calc. ghost pos., save char. under new pos. to restore later
560 gt=gy+gx:gf = peek(gt):poke gt,gh
570 if gt=t then mg=1:goto 170: rem got munched!
580 rem go to top left corner of screen and print score
590 print "{home}score";sr
600 next i
610 print ti$:rem only get here if the 'step 0' is removed above
620 end
630 rem -----------------------------------------------------------------------
640 rem promt user to press return key to start
650 print "{home}score";sr;mg$(mg);" return=start q=quit"
660 get a$: if a$="q" goto 720
670 if a$="" goto 660
680 sr=0:mg=0:print "{home}score";sr;mg$(mg);"                    "
690 return
700 rem -----------------------------------------------------------------------
710 rem clear screen and quit graciously
720 print chr$(147):print"thanks for playing!":end
730 rem -----------------------------------------------------------------------
740 rem Definitions of variables
750 rem Wall CBM ASCII char=160, "<"=60, "="=61, ">"=62, "."=46, "*"=42
760 rem Direction index: 0=none, 1=north, 2=south, 3=east, 4=west
770 rem We offset screen (0,0) by 1024 which is start of screen memory
780 rem Instead of y*40 for each Y coord update we add/subtract yo=40 offset
790 rem Joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
800 rem-----------------------------------------------------------------------
810 rem initialize variables that do not get reset between levels
820 dim pc(1):dim mx(16):dim my(16):
830 mx(0)=0:mx(1)=0:mx(2)=0:mx(3)=0:mx(4)=0:mx(5)=0:mx(6)=0:mx(7)=1
840 mx(8)=0:mx(9)=0:mx(10)=0:mx(11)=-1:mx(12)=0:mx(13)=0:mx(14)=0:mx(15)=0
850 my(0)=0:my(1)=0:my(2)=0:my(3)=0:my(4)=0:my(5)=40:my(6)=-40:my(7)=0
860 my(8)=0:my(9)=40:my(10)=-40:my(11)=0:my(12)=0:my(13)=40:my(14)=-40:my(15)=0
870 dim mg$(2):a$="":mg=0:sr=0
880 mg$(0)="          ":mg$(1)=" you lost!":mg$(2)=" you won! "
890 rem-----------------------------------------------------------------------
900 rem initialize variables that get reset on each level
910 TIME$ = "000000"   :rem reset clock
920 ty=0:tx=0:rem temp x and t
930 yo=40:w4=4:w2=2:w1=1:rem X,y move offsets, weight constants xo=1:
940 jn=1:js=2:jw=4:je=8:rem joystick bits
950 n=.:s=.:e=.:w=.:rem direction bias counters
960 px=.:py=.:pt=.:pb=42:t=.: rem Pac x,y,last pac char, screen char, temp
970 gx=.:gy=.:gt=.:gl=3:gf=46:rem ghost x,y,temp,last move dir, screen char
980 pl=1:bn=25:fs=199:rem pellet and bonus score vales, finsish score
990 pc(0)=61:pc(1)=60:rem pac screen characters
1000 wa=160:gh=65:sc=32:rem wall,ghost,space screen characters
1010 j2=56320:sr=.:rem j2 joyport 2, sr score
1020 tr=1504:t1=0:t2=39:t3=t2-1:t4=t1+1:rem warp tunnel coords
1030 return
1040 rem-----------------------------------------------------------------------
1050 rem clear screen,draw map, draw ghosts and pacman
1060 print chr$(147)
1070 PRINT "{reverse on}{cyan}                                        ";
1080 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1090 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1100 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1110 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1120 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1130 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1140 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1150 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1160 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1170 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1180 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1190 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1200 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1210 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1220 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1230 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1240 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1250 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1260 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1270 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1280 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1290 PRINT "{reverse off}{reverse on}                                        ";
1300 rem put pacman and ghost on screen at starting location
1310 rem must set the starting position for each here for each level
1320 px=19:py=17*yo+1024:gx=3:gy=5*yo+1024
1330 poke gy+gx,gh
1340 poke py+px,pc
1350 return