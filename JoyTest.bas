100 rem JoyTest01-1.bas same move routine as PacBas1-7
110 rem time no moves 0:27, random move 0:34
120 rem combined if statements no move 0:53, random move 0:43
130 rem seperate if statements diffrently, no move 0:27, random move 0:34
140 rem got rid of d variable, no moves 0:26, random move 0:32
150 rem add precalc test/change, i.e. t=p(y)-yo, no move 0:27, random 0:31
160 rem precalc px=p(x), py=p(y), no move 0:31, random 0:34
170 rem back to previous, add var for space char, no move 0:26, random 0:30
180 rem add changing pac charecter, no move 0:30, random 0:34
185 rem use var j2=56320, no move 0:27, random move 0:32
190 rem instead of y*40 for each screen update we add/subtract yo=(40) offset
200 rem add 1024 (0,0) which is start of screen
210 rem joyport 2 peek(56320) bit-function 4-fire,3-rt,2-left,1-dn,0-up
220 rem "<"=60, ">"=62, "="=61
230 TIME$ = "000000":rem reset clock
240 DIM p(3):DIM pc(1):yo=40:x=0:y=1:p1=0:p2=1
250 p(x)=19:p(y)=17*yo+1024:pc(p1)=61:pc(p2)=60
260 wa=160:sc=32:t=0:j2=56320
270 print chr$(147):rem clear screen
280 poke p(y)+p(x),pc
290 rem do 550 player moves
300 for i=1 to 550
310 gosub 380
320 next i
330 rem print exection time, end
340 print TIME$
350 end
360 rem -------------------------------
370 rem ****** Move player ************
380 j=peek(j2):poke p(y)+p(x),sc
390 rem ** can move north
400 if (j and 1) then goto 440
410 t=p(y)-yo:if peek(t+p(x))<>wa then p(y)=t
420 goto 540
430 rem ** can move south
440 if (j and 2) then goto 480
450 t=p(y)+yo:if peek(t+p(x))<>wa then p(y)=t
460 goto 540
470 rem ** can move east
480 if (j and 8) then goto 520
490 t=p(x)+1:if peek(p(y)+t)<>wa then p(x)=t
500 goto 540
510 rem ** can move west
520 if (j and 4) then goto 540
530 t=p(x)-1:if peek(p(y)+t)<>wa then p(x)=t
540 pt=abs(pt-1):poke p(y)+p(x),pc(pt)
550 return
560 rem ****** End Move Player ******
570 rem -----------------------------