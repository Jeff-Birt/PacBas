100 rem -----------------------------------------------------------------------
110 rem PacMan type game in C64 BASIC - Proof of concept
120 rem -----------------------------------------------------------------------
130 gosub 920: rem initialize all variables
140 gosub 1070: rem draw first level or splash screen
150 rem the next line is the entry point to move to next level
160 gosub 710: rem prompt user to press key to start
170 gosub 960: rem here we intialize some varables between levels
180 gosub 1070: rem draw screen for 'next' level
190 rem -----------------------------------------------------------------------
200 rem main loop
210 rem -----------------------------------------------------------------------
220 rem ****** Move player ************
230 for i=. to 1000 step 0: rem remove 'step 0' to time 1000 loops
240 j=peek(j2):poke py+px,sc:rem read joystick, clear Pac position
250 rem ** can move north
260 if (j and js)=. then t=py-yo:if peek(t+px)<>wa then py=t:goto 370
270 rem ** can move south
280 if (j and jn)=. then t=py+yo:if peek(t+px)<>wa then py=t:goto 370
290 rem ** can move east
300 if (j and jw)=. then t=px+w1:if peek(py+t)<>wa then px=t:goto 340
310 rem ** can move west
320 if (j and je)=. then t=px-w1:if peek(py+t)<>wa then px=t
330 rem warp tunnel code
340 if py<>ty then goto 370: rem skip if we are not at tunnel row
350 if px=t1 then px=t3:goto 370: rem tunnel R->L move
360 if px=t2 then px=t4:rem tunnel L->R move
370 t=py+px: rem calcualte new Pac screen position
380 if peek(t)=gf then sr=sr+1:goto 400:rem inc score if Pac ate pellet
390 if peek(t)=pb then sr=sr+25:rem inc score if Pac ate a an * (bonus)
400 if sr>99 then mg=2:goto 160:rem if scored 100+ we win, set message type 2
410 pt=abs(pt-w1):poke t,pc(pt):rem poke new position and toggle char
420 rem ------------------------------------------------------------------------
430 rem ****** Move Ghost 1 ***********
440 rem:goto 830: rem disable ghost for testing
450 poke gy+gx,gf:n=.:s=.:e=.:w=.:rem poke previous char to old position
460 rem can move dir +4, also toward PacMan +1
470 if peek(gy-yo+gx)<>wa then n=n+w4:if gy>py then n=n+w1
480 if peek(gy+yo+gx)<>wa then s=s+w4:if gy<py then s=s+w1
490 if peek(gy+gx+xo)<>wa then e=e+w4:if gx<px then e=e+w1
500 if peek(gy+gx-xo)<>wa then w=w+w4:if gx>px then w=w+w1
510 rem last direction moved +1, and opposite direction -3
520 if gl=w1 then n=n+1:s=s-w3:goto 570
530 if gl=w2 then s=s+1:n=n-w3:goto 570
540 if gl=w3 then e=e+1:w=w-w3:goto 570
550 if gl=w4 then w=w+1:w=w-w3:goto 570
560 rem find largest value n, s, e, w
570 if n>s then if n>e then if n>w then gy=gy-yo:gl=w1:goto 620
580 if s>n then if s>e then if s>w then gy=gy+yo:gl=w2:goto 620
590 if e>w then gx=gx+xo:gl=w3:goto 620
600 if w>. then gx=gx-xo:gl=w4
610 rem calc. ghost pos., save char. under new pos. to restore later
620 gt=gy+gx:gf = peek(gt):poke gt,gh
630 if gt = py+px then mg=1:goto 160: rem got munched!
640 rem go to top left corner of screen and print score
650 print "{home}score";sr
660 next i
670 print ti$:rem only get here if the 'step 0' is removed above
680 end
690 rem -----------------------------------------------------------------------
700 rem promt user to press key to start
710 print "{home}score";sr;mg$(mg);" any key to start"
720 get a$: if a$="" goto 720
730 sr=0:mg=0:print "{home}score";sr;mg$(mg);"                      "
740 return
750 rem -----------------------------------------------------------------------
760 rem Definitions of variables
770 rem Wall CBM ASCII char=160, "<"=60, "="=61, ">"=62, "."=46, "*"=42
780 rem Direction index: 0=none, 1=north, 2=south, 3=east, 4=west
790 rem w1=1, w2=2, w3=3, w4=4 are direction change 'weight' constants
800 rem We offset screen (0,0) by 1024 which is start of screen memory
810 rem Instead of y*40 for each Y coord update we add/subtract yo=40 offset
820 rem Joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
830 rem p() pacman, px=pac x coord, py=pac y coord
840 rem gx=ghost x coord, gy=ghosty coord, gl=last direction ghost moved
850 rem gf=previous charecter under ghost, gt=temp for ghost position
860 rem pc() pacman charecters, so we can toggle as moving
870 rem sr=score,
880 rem RH warp tunnel (39, 1504), LH warp tunnel (0,1504)
890 rem Tunnel Y t1=1504, Tunnel X1 t2=0, X2 t3=39
900 rem-----------------------------------------------------------------------
910 rem initialize variables that do not get reset between levels
920 dim pc(1):dim mg$(2):a$="":mg=0:sr=0
930 mg$(0)="          ":mg$(1)=" you lost!":mg$(2)=" you won! "
940 rem-----------------------------------------------------------------------
950 rem initialize variables that get reset on each level
960 TIME$ = "000000"   :rem reset clock
970 xo=1:yo=40:t=0:w4=4:w2=2:w1=1
980 jn=2:js=1:je=4:jw=8: rem joystick bits
990 n=.:s=.:e=.:w=.:rem direction bias
1000 px=19:py=17*yo+1024:pb=42
1010 gx=3:gy=5*yo+1024:gl=3:gf=46:gt=.
1020 pc(0)=61:pc(1)=60:wa=160:gh=65:sc=32:j2=56320:sr=.
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
1320 poke gy+gx,gh
1330 poke py+px,pc
1340 return