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
280 rem ------------------------------------------------------------------------
290 rem Wall CBM ASCII char=160, "<"=60, "="=61, ">"=62
300 rem Direction index: 0=none, 1=north, 2=south, 3=east, 4=west
305 rem w1=1, w2=2, w3=3, w4=4 are direction change 'weight' constants
310 rem We offset screen (0,0) by 1024 which is start of screen memory
320 rem Instead of y*40 for each Y coord update we add/subtract yo=40 offset
330 rem Joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
340 rem p() pacman, px=pac x coord, py=pac y coord
350 rem gx=ghost x coord, gy=ghosty coord, gl=last direction ghost moved
360 rem pc() pacman charecters, so we can toggle as moving
365 rem sr=score, 
370 rem -------------------------------
380 gosub 760: rem initialilze
390 rem ****** Move player ************
400 for i=. to 1000
410 j=peek(j2):poke py+px,sc:rem read joystick, clear Pac position
420 rem ** can move north
430 if (j and js)=. then t=py-yo:if peek(t+px)<>wa then py=t:goto 500
440 rem ** can move south
450 if (j and jn)=. then t=py+yo:if peek(t+px)<>wa then py=t:goto 500
460 rem ** can move east
470 if (j and jw)=. then t=px+w1:if peek(py+t)<>wa then px=t:goto 500
480 rem ** can move west
490 if (j and je)=. then t=px-w1:if peek(py+t)<>wa then px=t
500 if peek(py+px)<>sc then sr=sr+1:rem update score
510 pt=abs(pt-w1):poke py+px,pc(pt):rem poke new position and toggle char
520 rem -------------------------------
530 rem ****** Move Ghost 1 ***********
540 poke gy+gx,sc:n=.:s=.:e=.:w=.:rem clear old position
550 rem can move dir +1, also toward PacMan +1, also last dir +1
560 if peek(gy-yo+gx)<>wa then n=n+w4:if gy>py then n=n+w1
570 if peek(gy+yo+gx)<>wa then s=s+w4:if gy<py then s=s+w1
580 if peek(gy+gx+xo)<>wa then e=e+w4:if gx<px then e=e+w1
590 if peek(gy+gx-xo)<>wa then w=w+w4:if gx>px then w=w+w1
600 if gl=w1 then n=n+1:s=s-w3
610 if gl=w2 then s=s+1:n=n-w3
620 if gl=w3 then e=e+1:w=w-w3
630 if gl=w4 then w=w+1:w=w-w3
640 rem find largest value n, s, e, w
650 if n>s then if n>e then if n>w then gy=gy-yo:gl=w1:goto 690
660 if s>n then if s>e then if s>w then gy=gy+yo:gl=w2:goto 690
670 if e>w then gx=gx+xo:gl=w3:goto 690
680 if w>. then gx=gx-xo:gl=w4
690 poke gy+gx,gh
700 rem go to top left corner of screen and print score
710 print "{home}score ";sr
720 next i
730 print ti$
740 end
750 rem initialize variables, draw screen, etc
760 TIME$ = "000000"   :rem reset clock
770 DIM pc(1)
780 xo=1:yo=40:t=0:w4=4:w2=2:w1=1
790 jn=2:js=1:je=4:jw=8: rem joystick bits
800 n=.:s=.:e=.:w=.:rem direction bias
820 px=19:py=17*yo+1024
830 gx=3:gy=5*yo+1024:gl=3
840 pc(0)=61:pc(1)=60:wa=160:gh=65:sc=32:j2=56320:sr=.
850 rem clear screen,draw map, draw ghosts and pacman
860 print chr$(147)
870 rem draw screen
880 PRINT "{reverse on}{cyan}                                        ";
890 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
900 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
910 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
920 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
930 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
940 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
950 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
960 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
970 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
980 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
990 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1000 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1010 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1020 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1030 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1040 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1050 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1060 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1070 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1080 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1090 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1100 PRINT "{reverse off}{reverse on}                                        ";
1110 rem put pacman and shosts on screen at starting location
1120 poke gy+gx,gh
1130 rem poke g2(y)+g2(x),gh
1140 poke p(y)+p(x),pc
1150 return