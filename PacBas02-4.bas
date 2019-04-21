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
220 rem PacBas02-1.bas rearrange subroutines so most used have lower line #s
230 rem PacBas02-2.bas try JA joystick array for Pac move tests
240 rem PacBas02-3.bas new ghost logic to speed things up
250 rem PacBas02-4.bas tweak ghost hunting to avoid eating walls when going west
260 rem ------------------------------------------------------------------------
270 rem Wall CBM ASCII char=160, "<"=60, "="=61, ">"=62
280 rem Direction index: 0=none, 1=north, 2=south, 3=east, 4=west
290 rem instead of y*40 for each Y coord update we add/subtract yo=40 offset
300 rem add 1024 (0,0) which is start of screen
310 rem joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
320 rem p() pacman, p(x) x coord, p(y) y coord
330 rem g1()&g2() ghosts, g1(x) x coord, g1(y) y coord, g1(l) last travel dir
340 rem pc() pacman charecters
350 rem -------------------------------
360 gosub 780: rem initialilze
370 rem ****** Move player ************
380 for i=. to 1000
390 j=peek(j2):poke py+px,sc:rem read joystick
400 rem ** can move north
410 if (j and js) then goto 450
420 t=py-yo:if peek(t+px)<>wa then py=t
430 goto 550
440 rem ** can move south
450 if (j and jn) then goto 490
460 t=py+yo:if peek(t+px)<>wa then py=t
470 goto 550
480 rem ** can move east
490 if (j and jw) then goto 530
500 t=px+1:if peek(py+t)<>wa then px=t
510 goto 550
520 rem ** can move west
530 if (j and je) then goto 550
540 t=px-1:if peek(py+t)<>wa then px=t
550 pt=abs(pt-1):poke py+px,pc(pt):rem poke new position and toggle char
560 rem -------------------------------
570 rem ****** Move Ghost 1 ***********
580 poke gy+gx,sc:n=.:s=.:e=.:w=.:rem clear old position
590 rem can move dir +1, also toward PacMan +1, also last dir +1
600 if peek(gy-yo+gx)<>wa then n=n+xo:if gy>py then n=n+xo:if gl=w1 then n=n+w1
610 if peek(gy+yo+gx)<>wa then s=s+xo:if gy<py then s=s+xo:if gl=w2 then s=s+w1
620 if peek(gy+gx+xo)<>wa then e=e+xo:if gx<px then e=e+xo:if gl=w3 then e=e+w1
630 if peek(gy+gx-xo)<>wa then w=w+xo:if gx>px then w=w+xo:if gl=w4 then w=w+w1
640 rem find largest value n, s, e, w
650 if n>s then if n>e then if n>w then gy=gy-yo:gl=w1:goto 690
660 if s>n then if s>e then if s>w then gy=gy+yo:gl=w2:goto 690
670 if e>w then gx=gx+xo:gl=w3:goto 690
680 if w>. then gx=gx-xo:gl=w4
690 poke gy+gx,gh
700 next i
710 print ti$
720 end
730 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
740 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print peek(56320)
750 rem for z=1 to 500:next z
760 return
770 rem initialize variables, draw screen, etc
780 TIME$ = "000000"   :rem reset clock
790 DIM pc(1)
800 x=0:y=1:l=2:xo=1:yo=40:t=0:w4=4:w2=2:w1=1
810 jn=2:js=1:je=4:jw=8: rem joystick bits
820 n=.:s=.:e=.:w=.:rem direction bias
830 xt=.:yt=.:lt=.
840 px=19:py=17*yo+1024
850 gx=3:gy=5*yo+1024:gl=3
860 pc(0)=61:pc(1)=60:wa=160:gh=65:sc=32:j2=56320
870 rem clear screen,draw map, draw ghosts and pacman
880 print chr$(147)
890 rem draw screen
900 PRINT "{reverse on}{cyan}                                        ";
910 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
920 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
930 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
940 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
950 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
960 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
970 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
980 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
990 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1000 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1010 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1020 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1030 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1040 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1050 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1060 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1070 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1080 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1090 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1100 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1110 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1120 PRINT "{reverse off}{reverse on}                                        ";
1130 rem put pacman and shosts on screen at starting location
1140 poke gy+gx,gh
1150 rem poke g2(y)+g2(x),gh
1160 poke p(y)+p(x),pc
1170 return