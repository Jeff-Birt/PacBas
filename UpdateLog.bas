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
280 rem PacBas02-7.bas keep ghost from eating pellets, warp tunnels (311 lt)
290 rem PacBas02-8.bas add proper game over (331 lt)
300 rem PacBas02-9.bas clean up variables (337 lt)
310 rem PacBas03-0.bas add 'q' to quit option (335 lt)
320 rem PacBas03-1.bas try a differnet player movement routine (329 lt)