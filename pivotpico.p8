pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--pivot pico
--by brettski
--demake of pivot
-- developed by adamview studios

function _init()
 set_globals()
 start_game()
end

function _update60()
 t+=1
 _upd()
end

function _draw()
_drw()

print(stat(1),2,121,1)
print(stat(2),28,121,2)
print(#enemy,54,121,3)
color()
end
-->8
--init

function set_globals()
 t=0
 p={} --player
 pdot={} --point dot
 enemy={}
 score=0
 boardercd=11 --color default
 borderc=11 --border color
 shake=0
end

function start_game()
 score=0
 shake=0
 init_player()
 init_pdot()
 init_enemy()
 
 _upd=function()
  if(btnp(❎)) p.switchdir()
  p:upd()
  pdot:upd()
  for en in all(enemy) do
   en:upd()
  end
  spawn_enemy()
 end
 
 _drw=function()
  cls()
  p:draw()
  print(p.rs,4,2,7)
  print(score,110,2,7)
  rect(0,0,127,127,borderc) --border
  borderc=boardercd
  pdot:draw()
  for en in all(enemy) do
  	en:draw()
  end
 end
end

-->8
--2

function gameover_u()
 if btnp(🅾️) then
  start_game()
 end
end

function gameover_d()
 rect(6,32,121,99,7)
 rectfill(7,33,120,98,13)
 print("\^w\^t\^bgame over",27,35,0)
 ?"you completed \^i"..score.."\^-i captures!",15,49,0
 print("well done! you earned:",18,58,0)
 local i = score\10 + 1
 i = min(15,i)
 local wi=winicon[i]
 spr(wi.i,59,68)
 local x = (113\2+5) - (#wi.t*4\2)
 print(wi.t,x,80)
 print("press 🅾️ to play again",9,93)
 doshake();
end

function game_over()
 shake=0.5
 _upd=gameover_u
 _drw=gameover_d
end

winicon={
 {i=0,t="nil!"},
 {i=56,t="carrots"},
 {i=48,t="green grapes"},
 {i=49,t="red grapes"},
 {i=61,t="1 blueberry"},
 {i=50,t="yummy apple"},
 {i=51,t="freaky kiwi"},
 {i=52,t="strawberry ?"},
 {i=53,t="watermelon slice"},
 {i=54,t="whole watermelon!"},
 {i=55,t="pretty sunflower"},
 {i=57,t="rambo!"},
 {i=58,t="police person"},
 {i=59,t="a bandit 🐱"},
 {i=60,t="the birdy"},
}
-->8
--player

function init_player()
	p={
		ox=60, --origin x
		oy=60, --origin y
		x=0, --position x
		y=0, --position y
		a=0, --angle to origin
		rs=2, --radial speed
		r=4, --size/radius
		mr=12, --movement radius
		cw=true, --movement direction
		tl={}, --tail values
		tlen=32, --tail length 
		c=12, --color
	}
	
	function p:addtl()
	 tblsftlft(
	  self.tl,
	  self.tlen,
	  {x=self.x,y=self.y}
  )
	end
	
	function p:chkwall()
	 local pr=self.r
	 local t=self.y-pr
	 local r=self.x+pr
	 local b=self.y+pr
	 local l=self.x-pr
	 return t<=0 or r>=127 or b>=127 or l<=0
	end
	
	function p:chkenemy()
	 local pr=self.r
	 local testx=self.x
	 local testy=self.y
		for en in all(enemy) do
		 --find closest edge
		 if self.x<en.x then --test left
		  testx=en.x
		 elseif self.x>en.x+en.w then --test right
		  testx=en.x+en.w
		 end
		 if self.y<en.y then --test top
		  testy=en.y
		 elseif self.y>en.y+en.h then --test bottom
		  testy=en.y+en.h
		 end
		 local distx = self.x-testx
		 local disty = self.y-testy
		 if sqrt((distx*distx)+(disty*disty))<=p.r then
		  game_over()
		 end
		end
	end
	
	function p:upd()
	 local a=p.a/360
	 p.x=p.ox+p.mr*cos(a)
	 p.y=p.oy+p.mr*sin(a)
	 if p.cw then
	  p.a-=p.rs
	 else
	  p.a+=p.rs
	 end
	 p:addtl()
	 if p:chkwall() then 
	  --game over
	  p.c=8
	  game_over()
	 end
	 p:chkenemy()
	end
	
	function p:switchdir()
	 p.a=p.a-180
	 local a=p.a/360
	 p.cw= not p.cw
	 p.ox=p.x-p.mr*cos(a)
	 p.oy=p.y-p.mr*sin(a)
	end
	
	function p:draw()
	 pset(p.ox,p.oy,1)
	 --tail
	 local tr = p.r
	 for j=#p.tl,1,-1 do
	  local tl=p.tl[j]
	  if(j%6==0)tr-=1
	  tr=max(1,tr)
	  circfill(tl.x,tl.y,tr,6)
	 end
	 --player
	 circfill(p.x,p.y,p.r,p.c)
	end
end
-->8
--point dot

function init_pdot()
 pdot={
  x=63,
  y=-20,
  r=4, --size/radius
  dly=0, --createdelay
 }

	function pdot:new()
	 self.x=1+self.r+rnd(119-self.r)
	 self.y=1+self.r+rnd(119-self.r)
	end
	pdot:new()
	
	function pdot:plrhit()
	 local a=p.x-self.x
	 local b=p.y-self.y
	 local d=(a*a)+(b*b)
	 --for less precision on hit
	 --sqrt(d)-(p.r+self.r) <=0.1
	 return sqrt(d) <= p.r+self.r
	end
	
	function pdot:upd()	 
	 if pdot:plrhit() then 
	  score+=1
	  pdot:new()
	  if(score%10==0)p.rs+=0.5
	 end
	end
	
	function pdot:draw()
	 circfill(self.x,self.y,self.r,7)
	end
end


-->8
--enemies

function add_enemy(_y,_lr,_t)
	--_x path
	--_lr direction
	--_t type
	local e={
	 y=_y,
	 x=trny(_lr=="l",128,-8),
	 mov=trny(_lr=="l",-0.3,0.3),
	 w=10,
	 h=10,
	 c=9
	}
	
	function e:upd()
	 self.x+=self.mov
	 if self.x < -50 or self.x > 177 then
	  del(enemy, self)
	 end
	end
	
	function e:draw()
	 rect(self.x,
	 	self.y,
	 	self.x+self.w,
	 	self.y+self.h,
	 	self.c)
	end
	
	add(enemy,e)
end

function init_enemy()
 enemy={}
 add_enemy(25,"l",2)
 --add_enemy(88,"l",2)
end

function spawn_enemy()
 if t%400==0 then
  add_enemy(
  	12+rnd(101),
  	rnd({"l","r"}),
  	2)
 end
end
-->8
--utils

function tblsftlft(tbl,lmt,val)
 add(tbl,val)
 if(#tbl>lmt) deli(tbl,1)
 --tables are by reference
end

function trny(c,t,f)
 if c then
  return t
 else
  return f
 end 
end

function doshake()
 local shakex=16-rnd(32)
 local shakey=16-rnd(32)

 -- apply the shake strength
 shakex*=shake
 shakey*=shake
 
 camera(shakex,shakey)
 
 -- finally, fade out the shake
 -- reset to 0 when very low
 shake = shake*0.95
 if (shake<0.05) shake=0
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000400000004000000040000333333008b8b800000000000aaaaaa009a9a9003bb0b030081111000119110000aaa00600cc00000d1d10000000000000000000
03b343b002124210000400003bb1b1b328b8888000000000a888882a9d1d1d900b0003000188880000ccc0000afffa060cccc000d100d0000000000000000000
033143300225422008e4ee003b1777132b888b803e8188e3a2eeee8aa1d1d1a09ba043a00f3f3f000f0f0f000f1f1f069c1cc00d1d1d1d000000000000000000
13b13b1b5215215128eee6e03bb1b1b3222222b03a881ea3a888288a9d1d1d90999049a000fff00000fff000088888060cccddddd1d1d1000000000000000000
111133132155225228ee67e04333333928b8b8803aeeeea3baaaaaa309a9a900999049900f4f5f00011d11003388833f0cccdddd1d1d1d000000000000000000
113b11111521555528eeeee044499aa9b8b8b8b003aaaa30b3bb33b3333b3bb0449049900f545f0001171100f3b8b30400ccccc001d1d0000000000000000000
313313b1252252152288888004499999b888888000333300b3bb33b3bb3b3bb044904990005540000f111f000333330000ccc000000000000000000000000000
0311133002555220022222000444444008b8b8000000000003bb33b0000b00000400090000505000001010000040040000909000000000000000000000000000
