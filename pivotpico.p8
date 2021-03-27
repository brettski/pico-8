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
 _upd()
end

function _draw()
cls()
_drw()
end
-->8
--init

function set_globals()
 p={} --player
 pdot={} --point dot
 score=0
 boardercd=11 --color default
 borderc=11 --border color
end

function start_game()
 score=0
 init_player()
 init_pdot()
 
 _upd=function()
  if(btnp(❎)) p.switchdir()
  p:upd()
  pdot:upd()
 end
 
 _drw=function()
  p:draw()
  print(score,110,2,7)
  rect(0,0,127,127,borderc) --border
  borderc=boardercd
  
  pdot:draw()
 end
end
-->8
--2
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
		tlen=28, --tail length 
		c=12, --color
	}
	
	function p:addtl()
	 self.tl=tblsftlft(
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
	 if p:chkwall() then --game over
	  p.c=11
	 end
	end
	
	function p:switchdir()
	 p.a=p.a-180
	 local a=p.a/360
	 p.cw= not p.cw
	 p.ox=p.x-p.mr*cos(a)
	 p.oy=p.y-p.mr*sin(a)
	end
	
	function p.draw()
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
	 self.x=1+self.r+rnd(126-self.r)
	 self.y=1+self.r+rnd(126-self.r)
	end
	pdot:new()
	
	function pdot:plrhit()
	 local a=p.x-self.x
	 local b=p.y-self.y
	 local d=(a*a)+(b*b)
	 return sqrt(d) <= p.r+self.r
	end
	
	function pdot:upd()	 
	 if pdot:plrhit() then 
	  boarder=7
	  score+=1
	  pdot:new()
	 end
	end
	
	function pdot:draw()
	 circfill(self.x,self.y,self.r,7)
	end
end


-->8
--enemies
-->8
--utils

function tblsftlft(tbl,lmt,val)
	--tbl: table to work on
	--lmt: table size limit
	--val: value adding
	add(tbl,val)
	if(#tbl<=lmt) return tbl
	local ntbl={}
	for i=2,lmt do
	 add(ntbl,tbl[i])
	end
	return ntbl
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
