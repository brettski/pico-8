pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--pivot
--brettski
--&&&
function _init()
 p={
  ox=60,
  oy=60,
  a=0,
  r=12, --movement radius
  x=0,
  y=0,
  cw=true,
  tl={}, --tail values
  addtl=function(self)
			self.tl=sright(
			 self.tl,
			 20,
			 {x=self.x,y=self.y}
			)
  end
 }
end

function _update60()
 a=p.a/360
 p.x=p.ox+p.r*cos(a)
 p.y=p.oy+p.r*sin(a)
 if p.cw then
  p.a-=2
 else
  p.a+=2
 end
 if btnp(❎) then
  p.a=p.a-180
  a=p.a/360
  p.cw=not p.cw
  p.ox=p.x-p.r*cos(a)
  p.oy=p.y-p.r*sin(a)
 end
 p:addtl()
end

function _draw()
 cls()
 --circ(p.ox,p.oy,p.r,1)
 pset(p.ox,p.oy,1)
 --tail
 local tr=4
 for j=#p.tl,1,-1 do
  tl=p.tl[j]
  if(j%6==0)tr-=1
  tr = max(1, tr)
  circ(tl.x,tl.y,tr,6)
 end
 --player
 circfill(p.x,p.y,4,12)
 print(p.a,2,2)
 rect(0,0,127,127,11)
end
-->8
--util

--add new value to table
--and shift values if > lmt
function sright(tbl,lmt,value)
 --tbl: table to work on
 --lmt: table size limit
 --value: value adding
 add(tbl,value)
 if (#tbl<=lmt) return tbl
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
