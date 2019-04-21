100 rem PacBas - PacMan clone in C64 Basic!
110 rem PacBas01.bas working path planning routine - time 2:40
120 rem PacBas01-1.bas individual arrays - time 2:44
130 rem PacBas01-2.bas 2 diminsions array for ghosts - time 2:57
140 rem PacBas01-3.bas no intermediate var for moving - time 3:41
150 rem                repeated accesing arrays very slow
160 rem PacBas01-4.bas add intermediate vars back, loop thru ghosts 3:01
170 rem PacBas01-5.bas use 1 dim array w/offset to each ghost 3:00
180 rem PacBas01-6.bas back to indiv. ghost arrays, optimizations time 2:37
190 rem PacBas01-7.bas add keyboard control of player (PacMan)
200 rem PacBas01-8.bas try to improve speed of player, see JoyTest.bas
210 rem PacBas01-9.bas improve program flow
220 rem PacBas02-1.bas rearrange subroutines use lower line#s (324 lt)
230 rem PacBas02-2.bas try JA joystick array for Pac move tests
240 rem PacBas02-3.bas new ghost logic to speed things up (239 lt)
250 rem PacBas02-4.bas tweak ghost to avoid eating walls moving west
260 rem PacBas02-5.bas simplify the Pac move section, add score print (239 lt)
270 rem PacBas02-6.bas keep score improve shost tracking (300 lt)
280 rem PacBas02-7.bas keep ghost from eating pellets, warp tunnels (311 lt)
290 rem ------------------------------------------------------------------------
300 rem Wall CBM ASCII char=160, "<"=60, "="=61, ">"=62
310 rem Direction index: 0=none, 1=north, 2=south, 3=east, 4=west
320 rem w1=1, w2=2, w3=3, w4=4 are direction change 'weight' constants
330 rem We offset screen (0,0) by 1024 which is start of screen memory
340 rem Instead of y*40 for each Y coord update we add/subtract yo=40 offset
350 rem Joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
360 rem p() pacman, px=pac x coord, py=pac y coord
370 rem gx=ghost x coord, gy=ghosty coord, gl=last direction ghost moved
380 rem gf=previous charecter under ghost, gt=temp for ghost position
390 rem pc() pacman charecters, so we can toggle as moving
400 rem sr=score,
410 rem RH warp tunnel (39, 1504), LH warp tunnel (0,1504)
420 rem Tunnel Y t1=1504, Tunnel X1 t2=0, X2 t3=39
430 rem ------------------------------------------------------------------------
440 gosub 880: rem initialilze
450 rem ****** Move player ************
460 for i=. to 1000
470 j=peek(j2):poke py+px,sc:rem read joystick, clear Pac position
480 rem ** can move north
490 if (j and js)=. then t=py-yo:if peek(t+px)<>wa then py=t:goto 590
500 rem ** can move south
510 if (j and jn)=. then t=py+yo:if peek(t+px)<>wa then py=t:goto 590
520 rem ** can move east
530 if (j and jw)=. then t=px+w1:if peek(py+t)<>wa then px=t:goto 590
540 rem ** can move west
550 if (j and je)=. then t=px-w1:if peek(py+t)<>wa then px=t
560 if py<>ty then goto 590
570 if px=t1 then px=t3:goto 590
580 if px=t2 then px=t4
590 t=py+px:if peek(t)<>sc then sr=sr+1:rem update score
600 pt=abs(pt-w1):poke t,pc(pt):rem poke new position and toggle char
610 rem ------------------------------------------------------------------------
620 rem ****** Move Ghost 1 ***********
630 rem:goto 760: rem disable ghost for testing
640 poke gy+gx,gf:n=.:s=.:e=.:w=.:rem clear old position
650 rem can move dir +1, also toward PacMan +1, also last dir +1
660 if peek(gy-yo+gx)<>wa then n=n+w4:if gy>py then n=n+w1
670 if peek(gy+yo+gx)<>wa then s=s+w4:if gy<py then s=s+w1
680 if peek(gy+gx+xo)<>wa then e=e+w4:if gx<px then e=e+w1
690 if peek(gy+gx-xo)<>wa then w=w+w4:if gx>px then w=w+w1
700 if gl=w1 then n=n+1:s=s-w3:goto 750
710 if gl=w2 then s=s+1:n=n-w3:goto 750
720 if gl=w3 then e=e+1:w=w-w3:goto 750
730 if gl=w4 then w=w+1:w=w-w3:goto 750
740 rem find largest value n, s, e, w
750 if n>s then if n>e then if n>w then gy=gy-yo:gl=w1:goto 790
760 if s>n then if s>e then if s>w then gy=gy+yo:gl=w2:goto 790
770 if e>w then gx=gx+xo:gl=w3:goto 790
780 if w>. then gx=gx-xo:gl=w4
790 gt=gy+gx:gf = peek(gt):poke gt,gh
800 if gt = py+px then end: rem got munched!
810 rem go to top left corner of screen and print score
820 print "{home}score ";sr
830 next i
840 print ti$
850 end
860 rem-------------------------------------------------------------------------
870 rem initialize variables, draw screen, etc
880 TIME$ = "000000"   :rem reset clock
890 DIM pc(1)
900 xo=1:yo=40:t=0:w4=4:w2=2:w1=1
910 jn=2:js=1:je=4:jw=8: rem joystick bits
920 n=.:s=.:e=.:w=.:rem direction bias
930 px=19:py=17*yo+1024
940 gx=3:gy=5*yo+1024:gl=3:gf=46:gt=.
950 pc(0)=61:pc(1)=60:wa=160:gh=65:sc=32:j2=56320:sr=.
960 ty=1504:t1=0:t2=39:t3=t2-1:t4=t1+1:rem warp tunnel coords
970 rem clear screen,draw map, draw ghosts and pacman
980 print chr$(147)
990 rem draw screen
1000 PRINT "{reverse on}{cyan}                                        ";
1010 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1020 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1030 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1040 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1050 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1060 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1070 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1080 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1090 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1100 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1110 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1120 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1130 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1140 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1150 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1160 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1170 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1180 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1190 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1200 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1210 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1220 PRINT "{reverse off}{reverse on}                                        ";
1230 rem put pacman and ghost on screen at starting location
1240 poke gy+gx,gh
1250 poke p(y)+p(x),pc
1260 return