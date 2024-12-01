pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--brettski

function _init()
 mvadj=0.3

 plr_x=32
 plr_y=80
 pls_x=32
 pls_y=40
 px=0
 py=0
end

function _update()
 dobutton()
end

function _draw()
 cls(0)
 spr(1,plr_x,plr_y)
 spr(2,pls_x,pls_y)
 print(px..":"..py)
end

function dobutton()
 if btn(0) then moveplr(-1,0) end
 if btn(1) then moveplr(1,0) end
 if btn(2) then moveplr(0,-1) end
 if btn(3) then moveplr(0,1) end
end

function moveplr(_x,_y)
 px=_x
 py=_y
 local dadj=1
 if _x !=0 and _y != 0 then
  dadj=0.5
 end
 plr_x+=_x*mvadj*dadj
 plr_y+=_y*mvadj*dadj
 pls_x+=_x*mvadj--*dadj
 pls_y+=_y*mvadj--*dadj
end
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