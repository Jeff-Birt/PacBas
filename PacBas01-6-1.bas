100  TIME$ = "000000"   :rem reset clock
110 rem PacBas01.bas working path planning routine - time 2:40
120 rem PacBas01-1.bas individual arrays - time 2:44
130 rem PacBas01-2.bas 2 diminsions array for ghosts - time 2:57
140 rem PacBas01-3.bas no intermediate var for moving - time 3:41
150 rem                repeated accesing arrays very slow
160 rem PacBas01-4.bas add intermediate vars back, loop thru ghosts 3:01
170 rem PacBas01-5.bas use 1 dim array w/offset to each ghost 3:00
180 rem PacBas01-6.bas back to indiv. ghost arrays, optimizations time 2:37
190 rem PacBas01-6-1.bas simplify ghost logic time 2:30, 2:21 ghost stuck
200 rem wall CBM ASCII charecter = 160
210 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
220 rem instead of y*40 for each screen update we add/subtract yo=(40) offset
230 rem add 1024 (0,0) which is start of screen
240 DIM p(3):DIM g1(3):DIM g2(3):x=0:y=1:l=2:c=3:yo=40
250 p(x)=30:p(y)=17*yo+1024
260 g1(x)=3:g1(y)=5*yo+1024:g1(l)=3
270 g2(x)=30:g2(y)=17*yo+1024:g2(l)=1
280 wall=160:gh=65:w4=4:w2=2:w1=1:sc=32
290 n=.:s=.:e=.:w=.:rem direction bias
300 xt=.:yt=.:lt=.
310 rem clear screen,draw map, draw ghosts
320 print chr$(147)
330 gosub 1060
340 poke g1(y)+g1(x),gh
350 poke g2(y)+g2(x),gh
360 rem do 550 random ghost moves
370 for i=1 to 550
380 gosub 450
390 next i
400 rem print exection time, end
410 print TIME$
420 end
430 rem -------------------------------
440 rem ****** Move Ghost 1 ***********
450 xt=g1(x):yt=g1(y):lt=g1(l)
460 gosub 580
470 g1(x)=xt:g1(y)=yt:g1(l)=lt
480 rem ******* Move Ghost 2 **********
490 xt=g2(x):yt=g2(y):lt=g2(l)
500 gosub 580
510 g2(x)=xt:g2(y)=yt:g2(l)=lt
520 return
530 rem -----------------------------------------------------------------------
540 rem **** Move ghost subroutine ****
550 rem check each direction and weight results,
560 rem +4 no wall, +2 desired direction, +1 last travel direction
570 rem dir 0=none, 1=north, 2=south, 3=east, 4=west, u=1 (uno)
580 poke yt+xt,sc:n=.:s=.:e=.:w=.:rem clear old position
590 rem ** can move north
600 if peek(yt-yo+xt)=wall then goto 630
610 n=n+w1:if yt>p(1) then n=n+w4
620 rem ** can move south
630 if peek(yt+yo+xt)=wall then goto 660
640 s=s+w1:if yt<p(1) then s=s+w4
650 rem ** can move east
660 if peek(yt+xt+1)=wall then goto 690
670 e=e+w1:if xt<p(.) then e=e+w4
680 rem ** can move west
690 if peek(yt+xt-1)=wall then goto 730
700 w=w+w1:if xt>p(.) then w=w+w4
710 rem
720 rem ** move north **
730 if lt<>1 then goto 800
740 if n<>. then goto 780
750 if w>. then goto 980:rem left turn bias
760 if e>. then goto 920
770 goto 850
780 lt=1:yt=yt-yo:goto 1000
790 rem ** move south **
800 if lt<>2 then goto 870
810 if s<>. then goto 850
820 if e>. then goto 920:rem left turn bias
830 if w>. then goto 980
840 if goto 780
850 lt=2:yt=yt+yo:goto 1000
860 rem ** move east **
870 if lt<>3 then goto 950
880 if e<>. then goto 920
890 if n>. then goto 780:rem left turn bias
900 if s>. then goto 850
910 igoto 980
920 lt=3:xt=xt+1:goto 1000
930 rem ** move west ** lt=4
940 if w<>. then goto 980
950 if s>. then goto 850:rem left turn bias
960 if n>. then goto 780
970 goto 920
980 lt=4:xt=xt-1
990 rem
1000 poke yt+xt,gh
1010 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
1020 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print n;s;e;w
1030 rem for z=1 to 500:next z
1040 return
1050 rem -----------------------------------------------------------------------
1060 PRINT "{reverse on}{cyan}                                        ";
1070 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1080 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1090 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1100 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1110 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1120 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1130 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1140 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1150 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1160 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1170 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1180 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1190 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1200 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1210 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1220 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1230 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1240 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1250 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1260 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1270 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1280 PRINT "{reverse off}{reverse on}                                        ";
1290 return