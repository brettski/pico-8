pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- it slug
-- brettski

function _init()
 debug={}
 t=0
 initanidata()
 --left,right,up,down;0-3
 dirx={-1,1,0,0}
 diry={0,0,-1,1}
 
 _upd=updategame
 _drw=drawgame
 startgame()
end

function _update()
 t+=1
 _upd()
end

function _draw()
 _drw()
 drawindow()
 drawdebug()
end

function startgame()
 buttonbuf=-1
 movefn=nil
 actdrawfn=nil
 plr_x=3
 plr_y=3
 plr_ox=0
 plr_oy=0
 plr_sox=0
 plr_soy=0
 plr_flp=false
 plr_mov=nil
 plr_t=0

 windows={}
 menu0=nil --base menu window 
 loadlevel(0)
end

function loadlevel(_lvl)
 --will handle items like setting
 --default camera for this level
 --etc.

	--gets sprites to animate desks
--	function getdeskani()
	 for x=0,127 do
	  for y=0,63 do
	   local spt=mget(x,y)
	   if fget(spt,2) then
	    local da={spt,spt-16,spt-32}
	    add(deskani,da)
	    add(deskanix,x*8)
	    add(deskaniy,y*8)
	    mset(x,y,61)
	   end
	  end
	 end
	--end
end
-->8
--updates

function updategame()
 if menu0 then
  if getbutton()==4 then
   menu0.dur=0
   menu0=nil
  end
 else
  movefn=moveplayer
  actdrawfn=drawplr
  dobuttonbuf()
  dobutton(buttonbuf)
  buttonbuf=-1
 end
end

function dobuttonbuf()
 if buttonbuf==-1 then
  buttonbuf=getbutton()
 end
end

function getbutton()
	for i=0,5 do
	 if btnp(i) then
	  return i
	 end
	end
	return -1
end

function dobutton(butt)
 if butt<0 then return end
 if butt<4 then
  movefn(dirx[butt+1],diry[butt+1])
  --plr_x+=dirx[butt+1]
  --plr_y+=diry[butt+1]
 elseif butt==4 then -- 🅾️
  openmenu()
 --menu buttons here 🅾️❎
 --🅾️ switch modes
 --❎ select
 end
end

function update_plrturn()
 dobuttonbuf()
 plr_t=min(plr_t+0.125,1)

 plr_mov()
 if plr_t==1 then
  _upd=updategame
 end
end

function movwalk()
 plr_ox=plr_sox*(1-plr_t)
 plr_oy=plr_soy*(1-plr_t)
end

-->8
--drawing

function drawgame()
 cls(0)
 map()
 drawspr(waterc,14*8,4*8,28,false)
 dodeskani()
 --drawspr(plr_ani,plr_x*8+plr_ox,plr_y*8+plr_oy,dfltani_spd,plr_flp)
 actdrawfn()
end

function drawplr()
  drawspr(plr_ani,
   plr_x*8+plr_ox,
   plr_y*8+plr_oy,
   dfltani_spd,
   plr_flp,
   true) 
end

function drawindow()
 for w in all(windows) do
  local wx,wy,ww,wh=w.x,w.y,w.w,w.h
  rectfill(wx,wy,wx+ww-1,wy+wh-1,9)
  rect(wx+1,wy+1,wx+ww-2,wy+wh-2,2)
  
  -- needs to be updated
  -- for frame, etc.
  wy+=4
  wx+=4
  clip(wx,wy,ww,wy)
  for txt in all(w.txt) do
   print(txt,wx,wy,o)
   wy+=6
  end
  clip() 
  if w.dur then
   w.dur-=1
   if w.dur<=0 then
    local dif=w.h/2
    w.y+=dif/2
    w.h-=dif
    if w.h<3 then
     del(windows,w)
    end
   end
  end
 end
end

function getframe(ani,spd)
 return ani[flr(t/spd)%#ani+1]
end

function dodeskani()
 for i=1,#deskani do
  drawspr(deskani[i],
   deskanix[i],
   deskaniy[i],
   dfltani_spd,
   false)
 end
end

function drawspr(_sprts,_x,_y,spd,flp,trnsp)
 trnsp=trnsp or false
 palt(0,trnsp)
 spr(getframe(_sprts,spd),_x,_y,1,1,flp)
 pal()
end

function drawdebug()
 cursor(1,109)
 color(8)
 for txt in all(debug) do
  print(txt)
 end
end
-->8
--utils


-->8
--data

-- init animation data
function initanidata()
 dfltani_spd=10
 plr_ani={16,17,18,19}
 --cur_ani={20,21}
 waterc={49,50,51,52}
 deskani={}
 deskanix={}
 deskaniy={}
end
-->8
--gameplay

function moveplayer(_dx,_dy)
 local destx,desty=
  plr_x+_dx,plr_y+_dy
 local tile=mget(destx,desty)
 
 if _dx<0 then 
 	plr_flp=true 
 elseif _dx>0 then
 --keep same if 0
  plr_flp=false
 end
 
 if fget(tile,1) then
  --desk
  --todo find which one
  showmsg("can i help you?",90) 
 elseif fget(tile,0) then --solid
  --todo add bump
  return
 else --ok to walk
  plr_x+=_dx
  plr_y+=_dy
  plr_sox,plr_soy=-_dx*8,-_dy*8
  plr_ox,plr_oy=plr_sox,plr_soy
  plr_t=0
  _upd=update_plrturn
  plr_mov=movwalk
 end
end

-->8
--ui

function addwindow(_x,_y,_w,_h,_txt)
 local w={
  x=_x,
  y=_y,
  w=_w,
  h=_h,
  txt=_txt,
 }
 add(windows, w)
 return w
end

function showmsg(msg,dur)
 local w=addwindow(20,60,#msg*4+8,13,{msg})
 w.dur=dur or 90
end

function openmenu()
 menu0=addwindow(9,9,50,50,{"hi","brett"})
end

__gfx__
00000000000000000000000000000000000000000000000004444400004444400000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000004aaa400004ffff00000000000000000000000000000000000000000000000000000000000000000
007007000000000000000000000000000000000000000000043f3400004fc9c00000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000fff00000ff44400000000000000000000000000000000000000000000000000000000000000000
0007700000000000000000000000000000000000000000000ccfcc00004ffff00000000000000000000000000000000000000000000000000000000000000000
0070070000000000000000000000000000000000000000000fcccf00033ee8e00000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000001010000f33333f0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000101000001101100000000000000000000000000000000000000000000000000000000000000000
00000000099999900000000009999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999990099999900999999009999990077007700660066000000000000000000000000000000000000000000000000000000000000000000000000000000000
0999999009f3f3000999999009f3f300070000700600006000000000000000000000000000000000000000000000000000000000000000000000000000000000
09f3f30000ffff0009f3f30000ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ffff0000ffff0000ffff0000ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
41156140411561000115610001156140070000700600006000000000000000000000000000000000000000000000000000000000000000000000000000000000
02255200022552100225520012255200077007700660066000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000100010000000010010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555550
0056665000cccc0000cccc0000cccc0000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000050050000005
005555500cc66cc00cc66cc00cc66cc00cc66cc00000000000000000000000000000000000000000000000000000000000000000000000000000500050000005
556667500c6666c00c6666c00c6666c00c6666c00000000000000000000000000000000000000000000000000000000000000000000000000000000050051005
056177500c6cccc00cccc6c00cc6ccc00cc6ccc00000000000000000000000000000000000000000000000000000000000000000000000000500000050015005
056115500cccc6c00ccdccc00cccccc00cccc6c00000000000000000000000000000000000000000000000000000000000000000000000000050000050000005
056115500cc6ccc00cccccc00c6c6cc00c6cdcc00000000000000000000000000000000000000000000000000000000000000000050000000000000050000005
055555500cccccc00c6c6cc00cccc6c00cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000005555550
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000001111100000000000444440000000000aaaaa0000000000000aaa0000000
00000000000000000000000000000000000000000000000000000000000000000000019991000000000004fff4000000000000fff000000000000afffa000000
000000000000000000000000000000000000000000000000000000000000000000000139310000000000446f640000000000001f1000000000000acfca000000
00000000000000000000000000000000000000000000000000000000000000000000119991100000000004fff4000000000000fff00000000000aafffaa00000
000000000000000000000000000000000000000000000000000000000000000000010229221000000000099f9900000000000ccfcc0000000000a22f22a00000
0000000000000000000000000000000000000000000000000000000000000000000002e2e2000000000009eee900000000000fcccf0000000000af222f000000
0000000000000000000000000000000000000000000000000000000000000000994445444544444099444444444444409944f44444444440994444f4f4444440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000011111000000000044444000000000000aaaaa0000000000000aa0000000
0000000000000000000000000000000000000000000000000000000000000000000001999100000000004fff4000000000000afff000000000000afffa000000
00000000000000000000000000000000000000000000000000000000000000000000013931000000000046f6400000000000001f1000000000000acfca000000
0000000000000000000000000000000000000000000000000000000000000000000011999110000000004fff44000000000000fff00000000000aafffaa00000
00000000000000000000000000000000000000000000000000000000000000000000122922010000000009f99900000000000ccfcc0000000000a22f22a00000
0000000000000000000000000000000000000000000000000000000000000000000002e2e2000000000009eee900000000000fcccf0000000000af222f000000
0000000000000000000000000000000000000000000000000000000000000000994444d4d444444099444f444444444099444f444444444099444f444f444440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000011111000000000004444400000000000aaaa0000000000000aaa0000000
00000000000000000000000000000000000000000000000000000000000000000000019991000000000004fff4000000000000fffa00000000000afffa000000
000000000000000000000000000000000000000000000000000000000000000000000139310000000000046f640000000000001f1000000000000acfca000000
00000000000000000000000000000000000000000000000000000000000000000000119991100000000044fff4000000000000fff00000000000aafffaa00000
000000000000000000000000000000000000000000000000000000000000000000001229221000000000099f9900000000000ccfcc0000000000a22f22a00000
0000000000000000000000000000000000000000000000000000000000000000000002e2e2000000000009eee900000000000fcccf0000000000af222f0a0000
0000000000000000000000000000000000000000000000000000000000000000994445444544444099444f444f44444099444f444f44444099444f444f444440
00000000000000000000000000000000000000000000000000000000000000009444111111d444409444111111d444409444666666d444409444666666d44440
00000000000000000000000000000000000000000000000000000000000000009444111111144440944411111114444094446666666444409444666666644440
00000000000000000000000000000000000000000000000000000000000000004444111711d444404444111711d444404444666566d444404444666566d44440
00000000000000000000000000000000000000000000000000000000000000004444d11111d444404444d11111d444404444d66666d444404444d66666d44440
00000000000000000000000000000000000000000000000000000000000000000944444444444400044000000000440004000000000004000400000000000400
00000000000000000000000000000000000000000000000000000000000000000940000000004400044000000000440004000000000004000400000000000400
00000000000000000000000000000000000000000000000000000000000000000440000000009400044000000000440004000000000004000400000000000400
00000000000000000000000000000000000000000000000000000000000000000440000000009400044000000000940004000000000004000400000000000400
000000000000000000000000333333333334aaaa4aaaa43300000000000000000000000000000000000000000000000000000000000000004666666556666664
00000000000000000000000033333333333444444444443300000000000000000000000000000000000000000000000000000000000000004666666556666664
000000000000000000000000333333333334aaaa4aaaa433000000000000000000000000000000000000000000000000000000000000000040d0000000000d04
000000000000000000000000333333333334aaaa4aaaa43300000000000000000000000000000000000000000000000000000000000000006d000000000000d6
000000000000000000000000333333333334aaaa4aaaa43300000000000000000000000000000000000000000000000000000000000000006000000000000006
00000654444444444560000033333333333444444444443300000000000000000000000000000000000000000000000000000000000000006000000000000006
00000554444444944550000066666666666666666666666600000000000000000000000000000000000000000000000000000000000000006000000000000006
00000444494444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000000000006
00000444000000004440000000000000000000009444449494444494944444949444449494444494000000000000000000000000000000006000000000000006
00000944000000009490000000000000000000004444444444444444444444444444444444444444000000000000000000000000000000006000000000000006
00000444000000004490000000000000000000004444944444449444444494444444944444449444000000000000000000000000000000006005505000550006
00000949000000004440000000000000000000001111111111111111111111111111111111111111000000000000000000000000000000006005005000505006
00000444000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006005505000550006
00000449000000004440000044444444444444440566666666650000166666666666666666665000000000000000000000000000000000006d050050005050d6
0000044400000000944000004444aaaa4aaaa44406000000000600006000000000000000000060000000000000000000000000000000000060d5005550505d06
0000044400000000444000004444aaaa4aaaa4440608200570060000603330333000333033306000000000000000000000000000000000006666666666666666
00000444944444944440000000000000000000000608900750060000603030303030303030306000000000000000000000000000000000000000000000000000
00000554444444444550000000000000000000000600000000060000603330333000333033306000000000000000000000000000000000000000000000000000
00000654444494444560000000000000000000000600000000060000603030303030303030306000000000000000000000000000000000000000000000000000
00000111111111111110000000000000000000000605700310060000603330333000333033306000000000000000000000000000000000000000000000000000
0000010000000000001000000000000000000000060cc00370060000600000000000000000006000000000000000000000000000000000000000000000000000
00000100000000000010000000a0000000a000000600000000060000600000000000000000006000000000000000000000000000000000000000000000000000
00000100000000000010000000000000000000000600000000060000600000000000000000006000000000000000000000000000000000000000000000000000
0000010000000000001000000000000000000000060b500850060000609900002220222022206000000000000000000000000000000000000000000000000000
00000100001000000000010000100000000000000609900890060000609090902020202020206000000000000000000000000000000000000000000000000000
00000100001000000000010000100000000000000600000000060000609090002020202020206000000000000000000000000000000000000000000000000000
00000100001000000000010000100000000000000600000000060000609090902020202020206000000000000000000000000000000000000000000000000000
0000010000100000000001000010000000000000060cc00bb0060000609990002220222022206000000000000000000000000000000000000000000000000000
00000100001000000000010000100000000000000600000000060000600000000000000000006000000000000000000000000000000000000000000000000000
0000010000100000000001000010000000a000000566666666650000566666666666666666665000000000000000000000000000000000000000000000000000
00000100001000000000010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111111000000000010000100000111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101000000000000000003000100000000000000000303030307070707000000000000000003030303070707070000000000000000070707070707070701010101000000000303030303030303
0001000000000000000000000000000001000101010101010101000000000000010101000000000000000000000000000100010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
8081818193948181818193948181818200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9083838384858383838384858383839200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
903e3e3e3e68693e006c6d000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
903e3e3e3e78793e007c7d000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
903e3e3e3e3e3e3e000000000000319200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
903e3e3e3e6a6b3e006e6f000000309200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
903e3e3e3e7a7b3e007e7f000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
903e3e3e3e3e3e3e000000000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
903e3e3e3e3e003e000000000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9000000000000000000000000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9000000000000000000000000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9000000000000000000000000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9000000000000000000000000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a09596979899a1a1a1a1a1a1a18e8fa200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b2a5a6a7a8a9000000000000009e9fb300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0b5b6b7b8b9b4b4b4b4b4b4b4b4b4b100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
