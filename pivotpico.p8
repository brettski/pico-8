pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--pivot pico
--by brettski
--demake of pivot xl
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
cls()
_drw()

	if isdbg then
		print(stat(1),2,121,1)
		print(stat(2),28,121,2)
		print(#enemy,54,121,3)
	 print(p.rs,4,2,7)
	 if #enemy > 0 then
		 print(enemy[1].mov,60,121,7)
		end
		print("t:"..t,74,121,7)
	 color()
	end
end
-->8
--init

function set_globals()
 isdbg=false
 t=0
 p={} --player
 pdot={} --point dot
 enemy={}
 enemyspd=0.5
 score=0
 scypos=58
 scxpos={60,57,53}
 boarderc=11 --border color
 shake=0
 hscore=0
 hsidx=15 --dget index
 cartdata("brettski_pivotpico_1")
end

function start_game()
 t=0
 score=0
 shake=0
 init_player()
 init_pdot()
 init_enemy()
 boarderc=p.c
 
 _upd=function()
  if(btnp(❎)) p.switchdir()
  p:upd()
  pdot:upd()
  for en in all(enemy) do
   en:upd()
   en:colchk()
  end
  spawn_enemy()
 end
 
 _drw=function()
  local spidx=flr(log10(score))+1
  if (score > 0) then
   print("\^w\^t"..score,scxpos[spidx],scypos,6)
  end
  p:draw()
  rect(0,0,127,127,boarderc) --border
  pdot:draw()
  for en in all(enemy) do
  	en:draw()
  end
 end
end

-->8
--game over

function gameover_u()
 gameover_u1()
end

function gameover_d()
 gameover_d1()
end

function gameover_u1()
 if btnp(🅾️) then
  start_game()
 end
end

function gameover_d1()
 doshake()
 drw_go_dialog()
end

function drw_go_dialog()
	hscore=max(score,hscore)
	local athscore=max(score,dget(hsidx))
	dset(hsidx,athscore)
 rectfill(5,31,122,100,13)
 rect(6,32,121,99,5)
 print("\^w\^t\^bgame over",27,35,0)
 ?"you completed \^i"..score.."\^-i captures!",15,49,0
 print("well done! you earned:",15,58,0)
 print("best:",15,70)
 print("atb:", 89,70)
 print(hscore,35,70,11)
 print(athscore,105,70)
 local i = score\10 + 1
 i = min(15,i)
 circfill(63,72,7,1)
 local wi=winicon[i]
 spr(wi.i,60,68)
 local x = (113\2+9) - (#wi.t*4\2)
 print(wi.t,x,82,0)
 print("press 🅾️ to play again",21,93)
end

function game_over()
 shake=0.5
 _upd=gameover_u
 _drw=gameover_d
end

winicon={
 {i=0,t="nil!"},
 {i=61,t="1 blueberry"},
 {i=48,t="green grapes"},
 {i=52,t="strawberry ?"},
 {i=49,t="red grapes"},
 {i=56,t="carrots"},
 {i=50,t="yummy apple"},
 {i=51,t="freaky kiwi"},
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
		ox=63, --origin x
		oy=63, --origin y
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
	  p.c=8
	  game_over()
	 end
	end
	
	function p:switchdir()
	 p.a=p.a-180
	 local a=p.a/360
	 p.cw= not p.cw
	 p.ox=p.x-p.mr*cos(a)
	 p.oy=p.y-p.mr*sin(a)
	end
	
	function p:draw()
	 if (isdbg) pset(p.ox,p.oy,1)
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
  y=63,
  r=4, --size/radius
  dly=0, --createdelay
 }

	function pdot:new()
	 self.x=15+self.r+rnd(99-self.r)
	 self.y=15+self.r+rnd(99-self.r)
	end
	--pdot:new()
	
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
	  if score%10==0 and score<60 then
	   p.rs+=0.5
	  end
	 end
	end
	
	function pdot:draw()
	 circfill(self.x,self.y,self.r,7)
	end
end

-->8
--enemies

function add_enemy(_y,_lr,_t)
	--_y path
	--_lr direction
	--_t type
	local et = enemy_types[_t]
	local e={
		c=et.c,
		w=et.w,
		h=et.h,
  colchk=et.colchk,
		draw=et.draw,
		y=_y,
		lr=_lr,
		t=_t,
	}
	
	e.x=trny(_lr=="l",147,-20-e.w)
	e.mov=trny(_lr=="l"
	  ,-1*enemyspd,enemyspd)

	function e:upd()
	 self.x+=self.mov
	 if self.x < -50 or self.x > 177 then
	  del(enemy, self)
	 end
	end
	
	add(enemy,e)
end

function init_enemy()
 enemy={}
 --add_enemy(25,"l",1)
 --t=300
end

function spawn_enemy()
 if t%200==0 then
  local _t=1
  if (score>10) _t=2
  if (score>20) _t=rnd({1,2})
  add_enemy(
  	12+rnd(101),
  	rnd({"l","r"}),
  	_t)
 end
end

function ecome(_e) 
 if _e.lr=="l"
   and _e.x > 100 then
  boarderc=_e.c
 elseif _e.lr=="r"
   and _e.x < 28 then
  boarderc=_e.c
 end
end

function linedirleft(_e)
 --line direction left
 --top line
 local _y=_e.y
 local _yh=_e.y+_e.h
 line(127,_y,100,_y,_e.c)
 --botton line
 line(127,_yh,100,_yh,_e.c)
end

function linedirright(_e)
end

function ecomeline(_e)
	if _e.lr=="l"
	  and _e.x > 120 then
	 if _e.t < 3 then
	  --draw approaching lines
	  --for rects
	  linedirleft(_e)
	 else --draw for circles
	 
	 end
	elseif _e.lr=="r"
	  and _e.x < 28 then
	 if _e.t < 3 then
	 else
	 end
	end
end

function colchk_square(_en)
	local testx=p.x
	local testy=p.y
	--find closest x edge
	if p.x<_en.x then --test left
	 testx=_en.x
	elseif p.x>_en.x+_en.w then -- test right
	 testx=_en.x+_en.w
	end
	--find closest y edge
	if p.y<_en.y then --test top
	 testy=_en.y
	elseif p.y>_en.y+_en.h then --test bottom
  testy=_en.y+_en.h
	end
	local distx=p.x-testx
	local disty=p.y-testy
	if sqrt((distx*distx)+(disty*disty))<=p.r then
	 game_over()
	end
end

function colchk_circle(_en)
-- wip > from pdot
	 local a=p.x-self.x
	 local b=p.y-self.y
	 local d=(a*a)+(b*b)
	 --for less precision on hit
	 --sqrt(d)-(p.r+self.r) <=0.1
	 return sqrt(d) <= p.r+self.r
end

enemy_types = {
 {
 	n="square",
 	c=9,
 	w=6,
 	h=6,
  colchk=colchk_square,
 	draw=function(self)
 	 ecome(self)
 	 ecomeline(self)
		 rectfill(self.x,
		 	self.y,
		 	self.x+self.w,
		 	self.y+self.h,
		 	self.c)		
 	end,
 },
 {
 	n="rect",
 	c=3,
 	w=12,
 	h=6,
  colchk=colchk_square,
 	draw=function(self)
 	 ecome(self)
		 rectfill(self.x,
		 	self.y,
		 	self.x+self.w,
		 	self.y+self.h,
		 	self.c)		
 	end,
 }
}
-->8
--utils

--table shift left
function tblsftlft(tbl,lmt,val)
 add(tbl,val)
 if(#tbl>lmt) deli(tbl,1)
 --tables are by reference
end

--ternary
function trny(c,t,f)
 --if (c) return t
 --return f
 return c and t or f
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
 if (shake<0.05) then
  shake=0
  return true
 end
end

-- log10
log10_table = {
 0, 0.3, 0.475,
 0.6, 0.7, 0.775,
 0.8375, 0.9, 0.95, 1
}

function log10(n)
 if (n < 1) return nil
 local e = 0
 while n > 10 do
  n /= 10
  e += 1
 end
 return log10_table[flr(n)] + e
end
-- end log1o
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
0000400000004000000040000333333008b8b800000000000aaaaaa009a9a9003bb0b030081111000119110000aaa00600cc0000000000000000000000000000
03b343b002124210000400003bb1b1b328b8888000000000a888882a9d1d1d900b0003000188880000ccc0000afffa060cccc00000d1d1000000000000000000
033143300225422008e4ee003b1777132b888b803e8188e3a2eeee8aa1d1d1a09ba043a00f3f3f000f0f0f000f1f1f069c1cc00d0d100d000000000000000000
13b13b1b5215215128eee6e03bb1b1b3222222b03a881ea3a888288a9d1d1d90999049a000fff00000fff000088888060cccdddd01d1d1d00000000000000000
111133132155225228ee67e04333333928b8b8803aeeeea3baaaaaa309a9a900999049900f4f5f00011d11003388833f0cccdddd0d1d1d100000000000000000
113b11111521555528eeeee044499aa9b8b8b8b003aaaa30b3bb33b3333b3bb0449049900f545f0001171100f3b8b30400ccccc001d1d1d00000000000000000
313313b1252252152288888004499999b888888000333300b3bb33b3bb3b3bb044904990005540000f111f000333330000ccc000001d1d000000000000000000
0311133002555220022222000444444008b8b8000000000003bb33b0000b00000400090000505000001010000040040000909000000000000000000000000000
