pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--brettski

function _init()
 mvadj=0.6

 plr_x=64
 plr_y=64
 pls_x=32
 pls_y=40
 frame=0
 plrlfx=plr_x
 plrlfy=plr_y
end

function _update60()
 dobutton()
end

function _draw()
 frame+=1
 --cls(0)
 --spr(1,plr_x,plr_y)
 --spr(2,pls_x,pls_y)
 pset(plr_x,plr_y,8)
end

function dobutton()
 local dir=butarr[btn()&0b1111]
 if dir>0 then
 moveplr(dirx[dir],diry[dir],dir>4)
 end
end

function moveplr(_x,_y,isdiag)
 movx=_x*mvadj
 movy=_y*mvadj
 if isdiag then
  plr_x+=movx
  plr_y+=movy
  if flr(plr_x) != flr(plrlfx) and
     flr(plr_y) != flr(plrlfy) then
    --ok to update
  elseif flr(plr_x) != flr(plrlfx) then
   plr_x=plrlfx
  elseif flr(plr_y) != flr(plrlfy) then
   plr_y=plrlfy
  end
 else
	 plr_x+=movx
	 plr_y+=movy
 end

 pls_x+=_x*mvadj--*dadj
 pls_y+=_y*mvadj--*dadj
 
 plrlfx=plr_x
 plrlfy=plr_y
 
 printh(plr_x..", "
      ..plr_y..", "
      ..movx..", "
      ..movy..", "
      ..frame)
end
-->8
-- buttons and directions
--  0 - stop
--  1 - left
--  2 - right
--  3 - l+r -> stop
--  4 - up 
--  5 - diag l/u
--  6 - diag r/u
--  7 - l+u+r -> up
--  8 - down
--  9 - diag l/d
-- 10 - diag r/d
-- 11 - l+d+r -> down
-- 12 - u+d -> stop
-- 13 - l+u+d -> left
-- 14 - r+u+d -> right

-- translate to:
-- 1 -> ⬅️
-- 2 -> ➡️
-- 3 -> ⬆️
-- 4 -> ⬇️

-- 5 -> ⬅️⬆️
-- 6 -> ⬆️➡️
-- 7 -> ➡️⬇️
-- 8 -> ⬅️⬇️
butarr={1,2,0,3,5,6,3,4,8,7,4,0,1,2}
dirx={-1,1, 0,0, -0.7, 0.7,0.7,-0.7}
diry={0 ,0,-1,1, -0.7,-0.7,0.7, 0.7}
butarr[0]=0
dirx[0]=0
diry[0]=0





-->8
-- goal move smooth, on diag
-- at speed 0.3
-- 0.3 should look like 1
__gfx__
00000000000bb0000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bccb00003cc30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000bbccbb0033cc33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000bbccccbb33cccc3300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000bddccddb355cc55300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700bddddddb3555555300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bdd88ddb3554455300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009aa900002ee20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
