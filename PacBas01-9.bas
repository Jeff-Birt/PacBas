100  TIME$ = "000000"   :rem reset clock
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
220 rem wall CBM ASCII char=160, "<"=60, ">"=62, "="=61
230 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
240 rem instead of y*40 for each screen update we add/subtract yo=(40) offset
250 rem add 1024 (0,0) which is start of screen
260 rem joyport 2 peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
270 rem p() pacman, p(x) x coord, p(y) y coord
280 rem g1()&g2() ghosts, g1(x) x coord, g1(y) y coord, g1(l) last travel dir
290 rem pc() pacman charecters
300 DIM p(1):DIM g1(2):DIM g2(2):DIM pc(1)
310 x=0:y=1:l=2:yo=40:t=0:w4=4:w2=2:w1=1
320 n=.:s=.:e=.:w=.:rem direction bias
330 xt=.:yt=.:lt=.
340 p(x)=19:p(y)=17*yo+1024
350 g1(x)=3:g1(y)=5*yo+1024:g1(l)=3
360 g2(x)=30:g2(y)=17*yo+1024:g2(l)=1
370 pc(0)=61:pc(1)=60:wa=160:gh=65:sc=32:j2=56320
380 rem clear screen,draw map, draw ghosts and pacman
390 print chr$(147)
400 gosub 1240
410 poke g1(y)+g1(x),gh
420 poke g2(y)+g2(x),gh
430 poke p(y)+p(x),pc
440 rem -------------------------------
450 rem ****** Move player ************
460 j=peek(j2):poke p(y)+p(x),sc
470 rem ** can move north
480 if (j and 1) then goto 520
490 t=p(y)-yo:if peek(t+p(x))<>wa then p(y)=t
500 goto 620
510 rem ** can move south
520 if (j and 2) then goto 560
530 t=p(y)+yo:if peek(t+p(x))<>wa then p(y)=t
540 goto 620
550 rem ** can move east
560 if (j and 8) then goto 600
570 t=p(x)+1:if peek(p(y)+t)<>wa then p(x)=t
580 goto 620
590 rem ** can move west
600 if (j and 4) then goto 620
610 t=p(x)-1:if peek(p(y)+t)<>wa then p(x)=t
620 pt=abs(pt-1):poke p(y)+p(x),pc(pt)
630 gosub 670
640 goto 460
650 rem -------------------------------
660 rem ****** Move Ghost 1 ***********
670 xt=g1(x):yt=g1(y):lt=g1(l)
680 gosub 800
690 g1(x)=xt:g1(y)=yt:g1(l)=lt
700 rem ******* Move Ghost 2 **********
710 rem xt=g2(x):yt=g2(y):lt=g2(l)
720 rem gosub 820
730 rem g2(x)=xt:g2(y)=yt:g2(l)=lt
740 return
750 rem -----------------------------------------------------------------------
760 rem **** Move ghost subroutine ****
770 rem check each dir and apply bias +1 no wall, +4 desired dir
790 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
800 poke yt+xt,sc:n=.:s=.:e=.:w=.:rem clear old position
810 rem ** can move north
820 if peek(yt-yo+xt)=wa then goto 850
830 n=n+w1:if yt>p(1) then n=n+w4
840 rem ** can move south
850 if peek(yt+yo+xt)=wa then goto 880
860 s=s+w1:if yt<p(1) then s=s+w4
870 rem ** can move east
880 if peek(yt+xt+1)=wa then goto 910
890 e=e+w1:if xt<p(.) then e=e+w4
900 rem ** can move west
910 if peek(yt+xt-1)=wa then goto 950
920 w=w+w1:if xt>p(.) then w=w+w4
930 rem
940 rem ** move north **
950 if lt<>1 then goto 1010
960 if w>1 or (w>. and n=.) then goto 1160:rem left turn bias
970 if e>1 or (e>. and n=.) then goto 1110
980 if n=. then goto 1050
990 lt=1:yt=yt-yo:goto 1180
1000 rem ** move south **
1010 if lt<>2 then goto 1070
1020 if e>1 or (e>. and s=.) then goto 1110:rem left turn bias
1030 if w>1 or (w>. and s=.) then goto 1160
1040 if s=. then goto 990
1050 lt=2:yt=yt+yo:goto 1180
1060 rem ** move east **
1070 if lt<>3 then goto 1130
1080 if n>1 or (n>. and e=.) then goto 990:rem left turn bias
1090 if s>1 or (s>. and e=.) then goto 1050
1100 if e=. then goto 1160
1110 lt=3:xt=xt+1:goto 1180
1120 rem ** move west ** lt=4
1130 if s>1 or (s>. and w=.) then goto 1050:rem left turn bias
1140 if n>1 or (n>. and w=.) then goto 990
1150 if w=. then goto 1110
1160 lt=4:xt=xt-1
1170 rem
1180 poke yt+xt,gh
1190 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
1200 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print peek(56320)
1210 rem for z=1 to 500:next z
1220 return
1230 rem -----------------------------------------------------------------------
1240 PRINT "{reverse on}{cyan}                                        ";
1250 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1260 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1270 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1280 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1290 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1300 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1310 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1320 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1330 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1340 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1350 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1360 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1370 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1380 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1390 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1400 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1410 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1420 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1430 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1440 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1450 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1460 PRINT "{reverse off}{reverse on}                                        ";
1470 return