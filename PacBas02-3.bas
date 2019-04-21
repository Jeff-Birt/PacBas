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
250 rem wall CBM ASCII char=160, "<"=60, ">"=62, "="=61
260 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
270 rem instead of y*40 for each screen update we add/subtract yo=(40) offset
280 rem add 1024 (0,0) which is start of screen
290 rem joyport 2 j2=peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
300 rem p() pacman, p(x) x coord, p(y) y coord
310 rem g1()&g2() ghosts, g1(x) x coord, g1(y) y coord, g1(l) last travel dir
320 rem pc() pacman charecters
330 rem -------------------------------
340 gosub 780: rem initialilze
350 rem ****** Move player ************
360 for i=. to 1000
370 j=peek(j2):poke py+px,sc:rem read joystick
380 rem ** can move north
390 if (j and js) then goto 430
400 t=py-yo:if peek(t+px)<>wa then py=t
410 goto 530
420 rem ** can move south
430 if (j and jn) then goto 470
440 t=py+yo:if peek(t+px)<>wa then py=t
450 goto 530
460 rem ** can move east
470 if (j and jw) then goto 510
480 t=px+1:if peek(py+t)<>wa then px=t
490 goto 530
500 rem ** can move west
510 if (j and je) then goto 530
520 t=px-1:if peek(py+t)<>wa then px=t
530 pt=abs(pt-1):poke py+px,pc(pt):rem poke new position and toggle char
540 rem -------------------------------
550 rem ****** Move Ghost 1 ***********
560 xt=g1(x):yt=g1(y):lt=g1(l)
570 poke yt+xt,sc:n=.:s=.:e=.:w=.:rem clear old position
580 rem can move dir +1, also toward PacMan +1, also last dir +1
590 if peek(yt-yo+xt)<>wa then n=n+1:if yt>py then n=n+1: if lt=1 then n=n+1
600 if peek(yt+yo+xt)<>wa then s=s+1:if yt<py then s=s+1: if lt=2 then s=s+1
610 if peek(yt+xt+1) <>wa then e=e+1:if xt<px then e=e+1: if lt=3 then e=e+1
620 if peek(yt+xt-1) <>wa then w=w+1:if xt>px then w=w+1: if lt=4 then w=w+1
630 rem find largest value n, s, e, w
640 if n>s then if n>e then if n>w then yt=yt-yo:lt=1:goto 680
650 if s>n then if s>e then if s>w then yt=yt+yo:lt=2:goto 680
660 if e>w then xt=xt+1:lt=3:goto 680
670 xt=xt-1:lt=4
680 poke yt+xt,gh
690 g1(x)=xt:g1(y)=yt:g1(l)=lt
700 next i
710 print ti$
720 end
730 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
740 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print peek(56320)
750 rem for z=1 to 500:next z
760 return
770 rem initialize variables, draw screen, etc
780 TIME$ = "000000"   :rem reset clock
790 DIM g1(2):DIM g2(2):DIM pc(1)
800 x=0:y=1:l=2:yo=40:t=0:w4=4:w2=2:w1=1
810 jn=2:js=1:je=4:jw=8: rem joystick bits
820 n=.:s=.:e=.:w=.:rem direction bias
830 xt=.:yt=.:lt=.
840 px=19:py=17*yo+1024
850 g1(x)=3:g1(y)=5*yo+1024:g1(l)=3
860 g2(x)=30:g2(y)=17*yo+1024:g2(l)=1
870 pc(0)=61:pc(1)=60:wa=160:gh=65:sc=32:j2=56320
880 rem clear screen,draw map, draw ghosts and pacman
890 print chr$(147)
900 rem draw screen
910 PRINT "{reverse on}{cyan}                                        ";
920 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
930 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
940 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
950 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
960 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
970 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
980 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
990 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1000 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1010 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1020 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1030 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1040 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1050 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1060 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1070 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1080 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1090 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1100 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1110 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1120 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
1130 PRINT "{reverse off}{reverse on}                                        ";
1140 rem put pacman and shosts on screen at starting location
1150 poke g1(y)+g1(x),gh
1160 poke g2(y)+g2(x),gh
1170 poke p(y)+p(x),pc
1180 return