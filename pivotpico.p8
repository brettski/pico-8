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
 score=0
 borderc=11 --border color
end

function start_game()
 init_player()
 
 _upd=function()
  if(btnp(❎)) p.switchdir()
  p:upd()
 end
 
 _drw=function()
  p:draw()
  rect(0,0,127,127,borderc) --border
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
		tlen=32, --tail length 
	}
	
	function p:addtl()
	 self.tl=tblsftlft(
	  self.tl,
	  self.tlen,
	  {x=self.x,y=self.y}
  )
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
	 circfill(p.x,p.y,p.r,12)
	 print(p.a,2,2)
	end
end
-->8
--point dot
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
