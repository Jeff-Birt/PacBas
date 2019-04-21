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
195 rem PacBas01-8.bas try to improve speed of player, see JoyTest.bas
200 rem "<"=60, ">"=62, "="=61
210 rem wall CBM ASCII charecter = 160
220 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
230 rem instead of y*40 for each screen update we add/subtract yo=(40) offset
240 rem add 1024 (0,0) which is start of screen
250 rem joyport 2 peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
260 DIM p(3):DIM g1(3):DIM g2(3):DIM pc(1)
265 x=0:y=1:l=2:c=3:yo=40:p1=0:p2=1
270 p(x)=19:p(y)=17*yo+1024
280 g1(x)=3:g1(y)=5*yo+1024:g1(l)=3
290 g2(x)=30:g2(y)=17*yo+1024:g2(l)=1
295 pc(p1)=61:pc(p2)=60
300 wa=160:gh=65:sc=32:t=0:w4=4:w2=2:w1=1
310 n=.:s=.:e=.:w=.:rem direction bias
320 xt=.:yt=.:lt=.
330 rem clear screen,draw map, draw ghosts
340 print chr$(147)
350 gosub 1260
360 poke g1(y)+g1(x),gh
370 poke g2(y)+g2(x),gh
375 poke p(y)+p(x),pc
380 rem do 550 random ghost moves
390 for i=1 to 550
400 gosub 480
410 gosub 690
420 next i
430 rem print exection time, end
440 print TIME$
450 end
460 rem -------------------------------
470 rem ****** Move player ************
480 j=peek(56320):poke p(y)+p(x),sc
490 rem ** can move north
500 if (j and 1) then goto 550
510 t=p(y)-yo
520 if peek(t+p(x))=wa then goto 650
530 p(y)=t:goto 650
540 rem ** can move south
550 if (j and 2) then goto 600
560 t=p(y)+yo
570 if peek(t+p(x))=wa then goto 650
580 p(y)=t:goto 650
590 rem ** can move east
600 if (j and 8) then goto 625
605 t=p(x)+1
610 if peek(p(y)+t)=wa then goto 650
615 p(x)=t:goto 650
620 rem ** can move west
625 if (j and 4) then goto 650
630 t=p(x)-1
635 if peek(p(y)+t)=wa then goto 650
640 p(x)=t
650 pt=abs(pt-1):poke p(y)+p(x),pc(pt)
660 return
670 rem -------------------------------
680 rem ****** Move Ghost 1 ***********
690 xt=g1(x):yt=g1(y):lt=g1(l)
700 gosub 820
710 g1(x)=xt:g1(y)=yt:g1(l)=lt
720 rem ******* Move Ghost 2 **********
730 rem xt=g2(x):yt=g2(y):lt=g2(l)
740 rem gosub 820
750 rem g2(x)=xt:g2(y)=yt:g2(l)=lt
760 return
770 rem -----------------------------------------------------------------------
780 rem **** Move ghost subroutine ****
790 rem check each direction and weight results,
800 rem +1 no wall, +4 desired direction
810 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
820 poke yt+xt,32:n=.:s=.:e=.:w=.:rem clear old position
830 rem ** can move north
840 if peek(yt-yo+xt)=wa then goto 870
850 n=n+w1:if yt>p(1) then n=n+w4
860 rem ** can move south
870 if peek(yt+yo+xt)=wa then goto 900
880 s=s+w1:if yt<p(1) then s=s+w4
890 rem ** can move east
900 if peek(yt+xt+1)=wa then goto 930
910 e=e+w1:if xt<p(.) then e=e+w4
920 rem ** can move west
930 if peek(yt+xt-1)=wa then goto 970
940 w=w+w1:if xt>p(.) then w=w+w4
950 rem
960 rem ** move north **
970 if lt<>1 then goto 1030
980 if w>1 or (w>. and n=.) then goto 1180:rem left turn bias
990 if e>1 or (e>. and n=.) then goto 1130
1000 if n=. then goto 1070
1010 lt=1:yt=yt-yo:goto 1200
1020 rem ** move south **
1030 if lt<>2 then goto 1090
1040 if e>1 or (e>. and s=.) then goto 1130:rem left turn bias
1050 if w>1 or (w>. and s=.) then goto 1180
1060 if s=. then goto 1010
1070 lt=2:yt=yt+yo:goto 1200
1080 rem ** move east **
1090 if lt<>3 then goto 1150
1100 if n>1 or (n>. and e=.) then goto 1010:rem left turn bias
1110 if s>1 or (s>. and e=.) then goto 1070
1120 if e=. then goto 1180
1130 lt=3:xt=xt+1:goto 1200
1140 rem ** move west ** lt=4
1150 if s>1 or (s>. and w=.) then goto 1070:rem left turn bias
1160 if n>1 or (n>. and w=.) then goto 1010
1170 if w=. then goto 1130
1180 lt=4:xt=xt-1
1190 rem
1200 poke yt+xt,gh
1210 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
1220 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print peek(56320)
1230 rem for z=1 to 500:next z
1240 return
1250 rem -----------------------------------------------------------------------
1260 PRINT "{reverse on}{cyan}                                        ";
1270 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1280 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1290 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1300 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1310 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1320 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1330 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1340 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1350 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1360 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1370 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1380 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1390 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1400 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1410 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1420 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1430 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1440 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1450 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1460 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1470 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1480 PRINT "{reverse off}{reverse on}                                        ";
1490 return