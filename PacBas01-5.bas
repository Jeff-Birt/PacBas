990  TIME$ = "000000"   :rem reset clock
1000 rem PacBas01.bas working path planning routine - time 2:40
1002 rem PacBas01-1.bas individual arrays - time 2:44
1004 rem PacBas01-2.bas 2 diminsions array for ghosts - time 2:57
1006 rem PacBas01-3.bas no intermediate var for moving - time 3:41
1008 rem                repeaeted accesing arrays very slow
1010 rem PacBas01-4.bas add intermediate vars back, loop thru ghosts 3:01
1012 rem PacBas01-5.bas use 1 dim array w/offset to each ghost 3:00
1014 rem wall CBM ASCII charecter = 160
1016 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
1018 rem instead of calculating y*40 for each screen update we add subtract
1019 rem yoff (40) to change y position, add 1024 (0,0) offset to y as well
1020 wall=160:yoff=40:w8=8:w4=4:w2=2:w1=1
1021 n=0:s=0:e=0:w=0:rem temp direction bias
1022 DIM pa(2):DIM gh(2*3-1):g0=0:g1=3:x=0:y=1:l=2
1025 pa(x)=30:pa(y)=17*yoff+1024
1030 gh(x+g0)=3:gh(y+g0)=5*yoff+1024:gh(l+g0)=3
1040 gh(x+g1)=30:gh(y+g1)=17*yoff+1024:gh(l+g1)=1
1050 xtg=0:ytg=0:ltg=0
1175 rem clear screen,draw map, draw ghosts
1180 print chr$(147)
1190 gosub 1800
1200 poke gh(y+g0)+gh(x+g0),65
1205 poke gh(y+g1)+gh(x+g1),65
1208 rem do 550 random ghost moves
1210 for i=1 to 550
1250 gosub 1285
1260 next i
1262 rem print exection time, end
1265 print TIME$
1270 end
1275 rem -------------------------------
1280 rem ****** Move Ghosts ***********
1285 for g=. to 3
1290 xtg=gh(x+g):ytg=gh(y+g):ltg=gh(l+g)
1330 gosub 1515
1340 gh(x+g)=xtg:gh(y+g)=ytg:gh(l+g)=ltg
1380 g=g+2:next g
1480 return
1490 rem -----------------------------------------------------------------------
1495 rem **** Move ghost subroutine ****
1500 rem check each direction and weight results, 
1505 rem +4 no wall, +2 desired direction, +1 last travel direction
1510 rem dir 0=none, 1=north, 2=south, 3=east, 4=west
1515 poke ytg+xtg,32:n=.:s=.:e=.:w=.:rem clear old position
1518 rem ** can move north
1520 if peek(ytg-yoff+xtg)=wall then goto 1535
1525 n=n+w1:if ytg>pa(1) then n=n+w4
1530 rem ** can move south
1535 if peek(ytg+yoff+xtg)=wall then goto 1550
1540 s=s+w1:if ytg<pa(1) then s=s+w4
1545 rem ** can move east
1550 if peek(ytg+xtg+1)=wall then goto 1565
1555 e=e+w1:if xtg<pa(.) then e=e+w4
1560 rem ** can move west
1565 if peek(ytg+xtg-1)=wall then goto 1578
1570 w=w+w1:if xtg>pa(.) then w=w+w4
1572 rem
1575 rem ** move north **
1578 if ltg<>1 then goto 1600
1580 if w>1 or (w>. and n=.) then goto 1645:rem left turn bias
1585 if e>1 or (e>. and n=.) then goto 1630
1588 if n=. then goto 1610
1590 ltg=1:ytg=ytg-yoff:goto 1770
1595 rem ** move south **
1600 if ltg<>2 then goto 1620
1605 if e>1 or (e>. and s=.) then goto 1630:rem left turn bias
1608 if w>1 or (w>. and s=.) then goto 1645
1609 if s=. then goto 1590
1610 ltg=2:ytg=ytg+yoff:goto 1770
1615 rem ** move east **
1620 if ltg<>3 then goto 1640
1625 if n>1 or (n>. and e=.) then goto 1590:rem left turn bias
1628 if s>1 or (s>. and e=.) then goto 1610
1629 if e=. then goto 1645
1630 ltg=3:xtg=xtg+1:goto 1770
1635 rem ** move west ** ltg=4
1640 if s>1 or (s>. and w=.) then goto 1610:rem left turn bias
1642 if n>1 or (n>. and w=.) then goto 1590
1644 if w=. then goto 1630
1645 ltg=4:xtg=xtg-1
1650 rem
1770 poke ytg+xtg,65
1775 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print "              "
1780 rem poke 780,0:poke 781,0:poke 782,0: sys 65520:print n;s;e;w
1785 rem for z=1 to 500:next z
1790 return
1795 rem -----------------------------------------------------------------------
1800 PRINT "{reverse on}{cyan}                                        ";
1810 PRINT "{reverse off}{reverse on} {reverse off}*..{reverse on} {reverse off}......{reverse on} {reverse off}.........{reverse on}   {reverse off}.......{reverse on}   {reverse off}....*{reverse on} ";
1820 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off} {reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on}     {reverse off}.{reverse on}   {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1830 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on} {reverse off}.....{reverse on}  {reverse off}.... ...{reverse on} {reverse off}.........{reverse on} {reverse off}.{reverse on} ";
1840 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}....{reverse on}  {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1850 PRINT "{reverse off}{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1860 PRINT "{reverse off}{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}...........{reverse on} {reverse off}...{reverse on} ";
1870 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}......{reverse on}   {reverse off}.{reverse on}    {reverse off}..*{reverse on} {reverse off}.{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}       {reverse off}.{reverse on}   {reverse off}.{reverse on} ";
1880 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}  {reverse off}.......{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}...........{reverse on} ";
1890 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.........{reverse on}    {reverse off}........{reverse on} {reverse off}..{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on}  {reverse off} {reverse on} ";
1900 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}...{reverse on} {reverse off}....{reverse on}  {reverse off}--{reverse on}  {reverse off}.{reverse on} {reverse off} {reverse on}  {reverse off}.{reverse on} {reverse off}.........{reverse on} ";
1910 PRINT "{reverse off} ...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on} {reverse off}    {reverse on} {reverse off}......{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}."
1920 PRINT "{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off} {reverse on}    {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1930 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}...........{reverse on} {reverse off}.{reverse on}    {reverse off}.{reverse on}     {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1940 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on}       {reverse off}.{reverse on} {reverse off}............{reverse on} {reverse off}.{reverse on} ";
1950 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on} {reverse off}.............{reverse on}  {reverse off}.{reverse on}         {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1960 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}  {reverse off}.{reverse on}  {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.....{reverse on} {reverse off}.....{reverse on} {reverse off}.....{reverse on} ";
1970 PRINT "{reverse off}{reverse on} {reverse off}.....{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1980 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
1990 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}........{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
2000 PRINT "{reverse off}{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}      {reverse off}.{reverse on} {reverse off}...{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on}   {reverse off}.{reverse on} {reverse off}.{reverse on} {reverse off}.{reverse on} ";
2010 PRINT "{reverse off}{reverse on} {reverse off}*....{reverse on} {reverse off}..................{reverse on} {reverse off}...{reverse on} {reverse off}.....{reverse on} {reverse off}..*{reverse on} ";
2020 PRINT "{reverse off}{reverse on}                                        ";
2030 return