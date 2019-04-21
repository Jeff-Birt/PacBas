100  TIME$ = "000000"   :rem reset clock
110 rem PacBas01.bas working path planning routine - time 2:40
120 rem PacBas01-1.bas individual arrays - time 2:44
130 rem PacBas01-2.bas 2 diminsions array for ghosts - time 2:57
140 rem PacBas01-3.bas no intermediate var for moving - time 3:41
150 rem                repeated accesing arrays very slow
160 rem PacBas01-4.bas add intermediate vars back, loop thru ghosts 3:01
170 rem PacBas01-5.bas use 1 dim array w/offset to each ghost 3:00
180 rem PacBas01-6.bas back to indiv. ghost arrays, optimizations time 2:37
190 rem wall CBM ASCII charecter = 160
200 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
210 rem instead of y*40 for each screen update we add/subtract yo=(40) offset
220 rem add 1024 (0,0) which is start of screen
230 DIM p(3):DIM g1(3):DIM g2(3):x=0:y=1:l=2:c=3:yo=40
240 p(x)=30:p(y)=17*yo+1024
250 g1(x)=3:g1(y)=5*yo+1024:g1(l)=3
260 g2(x)=30:g2(y)=17*yo+1024:g2(l)=1
270 wall=160:gh=65:w4=4:w2=2:w1=1
280 n=.:s=.:e=.:w=.:rem direction bias
290 xt=.:yt=.:lt=.
300 rem clear screen,draw map, draw ghosts
310 print chr$(147)
320 gosub 1010
330 poke g1(y)+g1(x),gh
340 poke g2(y)+g2(x),gh
350 rem do 550 random ghost moves
360 for i=1 to 550
370 gosub 440
380 next i
390 rem print exection time, end
400 print TIME$
410 end
420 rem -------------------------------
430 rem ****** Move Ghost 1 ***********
440 xt=g1(x):yt=g1(y):lt=g1(l)
450 gosub 570
460 g1(x)=xt:g1(y)=yt:g1(l)=lt
470 rem ******* Move Ghost 2 **********
480 xt=g2(x):yt=g2(y):lt=g2(l)
490 gosub 570
500 g2(x)=xt:g2(y)=yt:g2(l)=lt
510 return
520 rem -----------------------------------------------------------------------
530 rem **** Move ghost subroutine ****
540 rem check each direction and weight results,
550 rem +4 no wall, +2 desired direction, +1 last travel direction
560 rem dir 0=none, 1=north, 2=south, 3=east, 4=west, u=1 (uno)
570 poke yt+xt,32:n=.:s=.:e=.:w=.:rem clear old position
580 rem ** can move north
590 if peek(yt-yo+xt)=wall then goto 620
600 n=n+w1:if yt>p(1) then n=n+w4
610 rem ** can move south
620 if peek(yt+yo+xt)=wall then goto 650
630 s=s+w1:if yt<p(1) then s=s+w4
640 rem ** can move east
650 if peek(yt+xt+1)=wall then goto 680
660 e=e+w1:if xt<p(.) then e=e+w4
670 rem ** can move west
680 if peek(yt+xt-1)=wall then goto 720
690 w=w+w1:if xt>p(.) then w=w+w4
700 rem
710 rem ** move north **
720 if lt<>1 then goto 780
730 if w>1 or (w>. and n=.) then goto 930:rem left turn bias
740 if e>1 or (e>. and n=.) then goto 880
750 if n=. then goto 820
760 lt=1:yt=yt-yo:goto 950
770 rem ** move south **
780 if lt<>2 then goto 840
790 if e>1 or (e>. and s=.) then goto 880:rem left turn bias
800 if w>1 or (w>. and s=.) then goto 930
810 if s=. then goto 760
820 lt=2:yt=yt+yo:goto 950
830 rem ** move east **
840 if lt<>3 then goto 900
850 if n>1 or (n>. and e=.) then goto 760:rem left turn bias
860 if s>1 or (s>. and e=.) then goto 820
870 if e=. then goto 930
880 lt=3:xt=xt+1:goto 950
890 rem ** move west ** lt=4
900 if s>1 or (s>. and w=.) then goto 820:rem left turn bias
910 if n>1 or (n>. and w=.) then goto 760
920 if w=. then goto 880
930 lt=4:xt=xt-1
940 rem
950 poke yt+xt,gh
960 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
970 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print n;s;e;w
980 rem for z=1 to 500:next z
990 return
1000 rem -----------------------------------------------------------------------
1010 PRINT "{reverse on}{cyan}                                        ";
1020 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1030 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1040 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1050 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1060 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1070 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1080 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1090 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1100 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1110 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1120 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1130 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1140 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1150 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1160 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1170 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1180 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1190 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1200 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1210 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1220 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1230 PRINT "{reverse off}{reverse on}                                        ";
1240 return