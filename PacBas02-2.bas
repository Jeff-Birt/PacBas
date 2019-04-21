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
225 rem PacBas02-2.bas try JA joystick array for Pac move tests
230 rem wall CBM ASCII char=160, "<"=60, ">"=62, "="=61
240 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
250 rem instead of y*40 for each screen update we add/subtract yo=(40) offset
260 rem add 1024 (0,0) which is start of screen
270 rem joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
280 rem p() pacman, p(x) x coord, p(y) y coord
290 rem g1()&g2() ghosts, g1(x) x coord, g1(y) y coord, g1(l) last travel dir
300 rem pc() pacman charecters
310 rem -------------------------------
315 gosub 1100: rem initialilze
320 rem ****** Move player ************
325 for i=. to 1000
330 j=peek(j2):poke py+px,sc:rem read joystick
340 rem ** can move north
350 if (j and js) then goto 390
360 t=py-yo:if peek(t+px)<>wa then py=t
370 goto 490
380 rem ** can move south
390 if (j and jn) then goto 430
400 t=py+yo:if peek(t+px)<>wa then py=t
410 goto 490
420 rem ** can move east
430 if (j and jw) then goto 470
440 t=px+1:if peek(py+t)<>wa then px=t
450 goto 490
460 rem ** can move west
470 if (j and je) then goto 490
480 t=px-1:if peek(py+t)<>wa then px=t
490 pt=abs(pt-1):poke py+px,pc(pt):rem poke new position and toggle char
520 rem -------------------------------
530 rem ****** Move Ghost 1 ***********
540 xt=g1(x):yt=g1(y):lt=g1(l)
550 gosub 660
560 g1(x)=xt:g1(y)=yt:g1(l)=lt
565 next i
566 print ti$
567 end
570 rem ******* Move Ghost 2 **********
580 rem xt=g2(x):yt=g2(y):lt=g2(l)
590 rem gosub 820
600 rem g2(x)=xt:g2(y)=yt:g2(l)=lt
610 return
620 rem -----------------------------------------------------------------------
630 rem **** Move ghost subroutine ****
640 rem check each dir and apply bias +1 no wall, +4 desired dir
650 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
660 poke yt+xt,sc:n=.:s=.:e=.:w=.:rem clear old position
670 rem ** can move north
680 if peek(yt-yo+xt)=wa then goto 710
690 n=n+w1:if yt>py then n=n+w4
700 rem ** can move south
710 if peek(yt+yo+xt)=wa then goto 740
720 s=s+w1:if yt<py then s=s+w4
730 rem ** can move east
740 if peek(yt+xt+1)=wa then goto 770
750 e=e+w1:if xt<px then e=e+w4
760 rem ** can move west
770 if peek(yt+xt-1)=wa then goto 810
780 w=w+w1:if xt>x then w=w+w4
790 rem
800 rem ** move north ** lt=last direction moved
810 if lt<>1 then goto 870
820 if w>1 or (w>. and n=.) then goto 1020:rem left turn bias
830 if e>1 or (e>. and n=.) then goto 970
840 if n=. then goto 910
850 lt=1:yt=yt-yo:goto 1040
860 rem ** move south **
870 if lt<>2 then goto 930
880 if e>1 or (e>. and s=.) then goto 970:rem left turn bias
890 if w>1 or (w>. and s=.) then goto 1020
900 if s=. then goto 850
910 lt=2:yt=yt+yo:goto 1040
920 rem ** move east **
930 if lt<>3 then goto 990
940 if n>1 or (n>. and e=.) then goto 850:rem left turn bias
950 if s>1 or (s>. and e=.) then goto 910
960 if e=. then goto 1020
970 lt=3:xt=xt+1:goto 1040
980 rem ** move west ** lt=4
990 if s>1 or (s>. and w=.) then goto 910:rem left turn bias
1000 if n>1 or (n>. and w=.) then goto 850
1010 if w=. then goto 970
1020 lt=4:xt=xt-1
1030 rem
1040 poke yt+xt,gh
1050 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
1060 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print peek(56320)
1070 rem for z=1 to 500:next z
1080 return
1090 rem initialize variables, draw screen, etc
1100 TIME$ = "000000"   :rem reset clock
1110 DIM g1(2):DIM g2(2):DIM pc(1)
1120 x=0:y=1:l=2:yo=40:t=0:w4=4:w2=2:w1=1
1125 jn=2:js=1:je=4:jw=8: rem joystick bits
1139 n=.:s=.:e=.:w=.:rem direction bias
1140 xt=.:yt=.:lt=.
1150 px=19:py=17*yo+1024
1160 g1(x)=3:g1(y)=5*yo+1024:g1(l)=3
1170 g2(x)=30:g2(y)=17*yo+1024:g2(l)=1
1180 pc(0)=61:pc(1)=60:wa=160:gh=65:sc=32:j2=56320
1190 rem clear screen,draw map, draw ghosts and pacman
1200 print chr$(147)
1210 rem draw screen
1220 PRINT "{reverse on}{cyan}                                        ";
1230 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1240 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1250 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1260 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1270 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1280 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1290 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1300 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1310 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1320 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1330 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1340 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1350 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1360 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1370 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1380 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1390 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1400 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1410 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1420 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1430 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1440 PRINT "{reverse off}{reverse on}                                        ";
1450 rem put pacman and shosts on screen at starting location
1460 poke g1(y)+g1(x),gh
1470 poke g2(y)+g2(x),gh
1480 poke p(y)+p(x),pc
1490 return