pico-8 cartridge // http://www.pico-8.com
version 24
__lua__
--cannon
--brettski

function _init()
 startgame()
end

function _update60()
 t+=1
 upd_bg()
 --upd_cannon()
 _upd()
end

function _draw()
 cls(12)
 drw_bg()
 --drw_game()
 --drw_cannon()
 _drw()
 print("plry:"..plry,1,1)
 print("mapfg_dx:"..mapfg_dx,1,7)
 --print("x1,y1,a:"..canx1..","..cany1..","..canang,1,17)
 print("plrdst:"..plrdst,1,13)
 print("plrsi:"..plrsi,1,19)
end
-->8
--startup

function startgame()
 t=0
 --background
 mapfg_x=0 --foreground
 mapfg_dx=0--1
 map1_x=0
 map1_dx=0--0.33
 --player
 --plrxspd=0
 --plryspd=0
 plrdy=1
 plrx,plry=3*8,14*8
 plrxmax=56
 plrani={1,3,5,7}
 plrbncy=0.75 --bounciness
 plrdia=8 --diameter
 plrdst=0 --distance
 plrhit=0 --times hit ground
 plrsi=1 --plr sprite index
 --cannon
 --14*8=112
 canx0=8 --center x
 cany0=108 --center y
 canx1=32 --calculated
 cany1=108 -- ""
 canlen=24 --cannon length
 canang=0 --cannon angle
 canmaxa=45
 canmina=0
 isfire=false
 --meter
 metx0=8
 mety0=111
 meth=4
 metw=24
 metval=1 --1 to metw-1
 metdir=1 --1 or -1 direction
 mfire=1
 --environment
 gvty=1.5
 drag=0.1
 grnd=0.8 --ground drag
 --items
 items={}
 itemy=113
 
 --gameloops
 _drw=drw_cannon
 _upd=upd_cannon
end
-->8
--updates

function upd_bg()
 mapfg_x-=mapfg_dx
 plrdst+=flr(mapfg_dx/10)
 if mapfg_x<-127 then
  mapfg_x=0
 end
 map1_x-=map1_dx
 if map1_x<-127 then
  map1_x=0
 end
end

--allows adj and fire
function upd_cannon()
 --meter
 if metdir>0 and metval>metw-2 then
  metdir=-1  
 elseif metdir<0 and metval<2 then
  metdir=1
 end
 metval=metval+metdir
 local b=getbutton()
 if b==2 then 
  canang+=2
  canang=min(canang,canmaxa)
 elseif b==3 then 
  canang-=2
  canang=max(canang,canmina)
 elseif b==5 then
  --❎, fire
  isfire=true
  mfire=metval
  plrx=canx1
  plry=cany1-7
  mapfg_dx,plrdy=firecan(canang,mfire)
 end
 if (b==2 or b==3)
  and not isfire then
  a=canang/360
  canx1=canx0+cos(a)*canlen
  cany1=cany0+sin(a)*canlen
 end
 if isfire then
  canx0+=mapfg_x
  canx1+=mapfg_x
  metx0+=mapfg_x
  plrx-=mapfg_x
  plrx=min(plrx,plrxmax)
  if canx0<canlen*-2 then
   _drw=drw_game
   _upd=upd_game
  end
 end
end

--moves player after fire
function upd_game()
 plrdy+=gvty

 plry+=plrdy
 if plry>119-plrdia then
  plrdy*=-1*plrbncy
  mapfg_dx*=grnd
  plrhit+=1
  if mapfg_dx >0 then
   plrsi=plrhit%3+1
  end
 end
 plry=min(plry,112)

 mapfg_dx-=drag
 mapfg_dx=max(mapfg_dx,0)
 updateitems(mapfg_dx)
 additem()

end

--show score at end of turn
function upd_showscore()
 --🅾️ to play again
end


-->8
--drawing

function drw_bg()
 map(16,0,map1_x,0,16,16)
 map(16,0,map1_x+128,0,16,16)
 map(0,0,mapfg_x,0,16,16)
 map(0,0,mapfg_x+128,0,16,16)

end

function drw_game()
 local ps=plrani[plrsi]
 spr(ps,plrx,plry,2,1)
 for it in all(items) do
  spr(it.snum,it.x,itemy,2,1)
 end
end

function drw_cannon()
 line(canx0,cany0-2,canx1,cany1-2,6)
 line(canx0,cany0-1,canx1,cany1-1,13)
 line(canx0,cany0,canx1,cany1,5)
 line(canx0,cany0+1,canx1,cany1+1,13)
 line(canx0,cany0+2,canx1,cany1+2,6)
 --meter
 rect(metx0,mety0,metx0+metw,mety0+meth,1)
 rectfill(metx0+1,mety0+1,metx0+metval,mety0+meth-1,8)
 if isfire then
  drw_game()
 end
end

function drw_showscore()

end
-->8
--util

function getbutton()
 --0,1,2,3,4,5
 --⬅️,➡️,⬆️,⬇️,🅾️,❎
 for i=0,5 do
  if btnp(i) then
   return i
  end
 end
 return -1
end

function firecan(ang,val)
 local x=val*cos(ang/360)*5
 local y=val*sin(ang/360)*5
 print(x..":"..y)
 return x,y
end

--adds items to field,randomly
function additem()
 local d=flr(rnd(3)+1)
 local tn=64
 if d==2 then tn=68 end

 local mi=flr(rnd(20)+10)
 if(plrdst%mi==0) then
  local it={
   snum=tn,
   shit=tn+2,
   sw=2,
   sh=1,
   x=128,
  }
  add(items,it)
  return it
 end
end

function updateitems(fgx)
 for it in all(items) do
  it.x-=fgx
  if it.x<-32 then
   del(items,it)
  end
 end
end
__gfx__
00000000900000000000000000888800008888000099990000999900002222000022220000000000000000000000000000000000000000009000000900000000
00000000900000000000000008888880088888800999999009999990022222200222222000000000000000000000000000000000000000009999999900000000
007007009000000000000000888f8888888f8888999f9999999f9999222f2222222f222200000000000000000000000000000000000000009b9999b900000090
00077000000000000000000088f8888888f8888899f9999999f9999922f2222222f2222200000000000000000000000000000000000000009999999900000900
000770000000000000000000888f8888888f8888999f9999999f9999222f2222222f222200000000000000000000000000000000000000009999999900000900
00700700000000000000000088888888888888889999999999999999222222222222222200000000000000000000000000000000000000009900009900000900
00000000000000000000000008888880088888800999999009999990022222200222222000000000000000000000000000000000000000000999999099909000
00000000000000000000000000888800008888000099990000999900002222000022220000000000000000000000000000000000000000000000000999999000
bbbbb3bb3bbb3bbb0000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999000
493444b449b444340000000000008a80000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999000
4444494414444944000000000800b800000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999000
4494444444944444000000008a80b000000000000000000000000000000000000000000000000000000000000000000000000000000000000099090090090000
94144944944449440000000008b0b00000000e000000000000000000000000000000000000000000000000000000000000000000000000000990990990990000
4444444444444144a00000a000b0b000a0000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44494444444944440b00a00b000b00000b00b00b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5555555555555555040b000400030000030300040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000003000000000000000450000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000033300000000000000440000000000007700777770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000033300000000000000940000000000076770077766000000000007700000000000000000000000000000000000000000000000000000000000000000000
00000333330000000000000440000000000767767077777000000006777777000000000000000000000000000000000000000000000000000000000000000000
00000333330000000000000440000000066767777776777000007777667777700000000000000000000000000000000000000000000000000000000000000000
00003333333000000000000440000000777777777767777007776777777766700000000000000000000000000000000000000000000000000000000000000000
00003333333000000000002240000000077767777767770077777677776677770000000000000000000000000000000000000000000000000000000000000000
00033333333300000000012444000000007776777777700077776777777777700000000000000000000000000000000000000000000000000000000000000000
00033333333300000000000000000000007777777777770007667777766777770000000000000000000000000000000000000000000000000000000000000000
00333333333330000000000000000000000777777777677077777777677677770000000000000000000000000000000000000000000000000000000000000000
00333333333330000000000000000000000076777766777077777777677777700000000000000000000000000000000000000000000000000000000000000000
03333333333333000000000000000000007777677677777707777007777770000000000000000000000000000000000000000000000000000000000000000000
03333333333333000000000000000000077777677777777700770000770700000000000000000000000000000000000000000000000000000000000000000000
33333333333333300000000000000000777776777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333300000000000000000077767770077770000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333330000000000000000007777700007700000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000009e488488e984e88e9e4888889e4888880000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000088988488488ee88488908480889084800000000000000000000000000000000000000000000000000000000000000000
5544444114444455554000000000045577111711771117777718a0a84418a0a80000000000000000000000000000000000000000000000000000000000000000
51000000000000155104400000044015777177171771777777810a07799a0a070000000000000000000000000000000000000000000000000000000000000000
5000000000000005500004400440000577717717177177777778a0a84788a0a80000000000000000000000000000000000000000000000000000000000000000
500000000000000550000001100000059e888488488e988e9e8a88809e8a88800000000000000000000000000000000000000000000000000000000000000000
5000000000000005500000000000000588488489e88ee48488988489889884890000000000000000000000000000000000000000000000000000000000000000
50000000000000055000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000242500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000002425343500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000003435000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000262726270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000363736370000242500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000343500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1400120000130000001214000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011101110111011101110111011101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
