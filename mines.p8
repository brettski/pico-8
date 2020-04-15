pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--mines
--brettski

function _init()
 t=0
 
 xfield=10   --field x max
 yfield=10   --field y max
 bombcount=10
 bombs={} --bomb locations
 field={}    --playing field

 loaddata()
 gamestart()
end

function _update()
 t+=1
 
 _upd=nil
end

function _draw()

	_drw=nil
end


-->8
--start and setup

function gamestart()
 cls()
 generatefield()
 
 --testing
 
 cursor(4,1)
 color(8)
 for k,v in pairs(bombs) do
  --print(k)
 end
 
end

function generatefield()
 --set bomb locations
 for i=1,bombcount do
  local bx,by=getrandpoint(xfield,yfield)
  bombs[getfkey(bx,by)]=-1
 end
 --setup field
 --add bombs and intial values
 for fx=1,xfield do
  for fy=1,yfield do
   field[getfkey(fx,fy)] = {
    x=fx,
    y=fy,
    val=bombs[getfkey(fx,fy)] or 0,
    iscovered=true,
    isflagged=false,
   }
  
  end
 end
 --setup tile count vals
 for fx=1,xfield do
  for fy=1,yfield do
   setbombcnt(fx,fy)
  end
 end
 --
 
end

-->8
--updates
-->8
--drawing

function drawgame()
 cls()
 map()
 --draw field sprites
 --draw player
end

function drawspr(_sprts,
         _x,_y,spd,trnsp)
 trnsp=trnsp or false
 palt(0,trnsp)
 spr(getframe(_sprts,spd),_x,_y)
end

function getframe(ani,spd)
 return ani[flr(t/spd)%#ani+1]
end

-->8
--utils

function getfkey(x,y)
 return x..","..y
end

--calc and ret random point
function getrandpoint(maxx,maxy)
 return flr(rnd(maxx))+1,
        flr(rnd(maxy))+1
end

--set bomb count around point
function setbombcnt(_x,_y)
 local fieldpt=field[getfkey(_x,_y)]
 --if on bomb, skip
 if fieldpt.val==-1 then return end
 local count=0
 for pt in all(aroundpt) do
  local ax,ay=max(min(_x+pt.x,xfield),1),
              max(min(_y+pt.y,yfield),1)
  local ptval=field[getfkey(ax,ay)]
  if ptval.val==-1 then
   count+=1
  end
  fieldpt.val=count
 end 
end
-->8
--data

function loaddata()
 --for finding items around a point
 aroundpt={
  {x=-1,y=-1},
  {x= 0,y=-1},
  {x= 1,y=-1},
  {x=-1,y= 0},
  {x= 1,y= 0},
  {x=-1,y= 1},
  {x= 0,y= 1},
  {x= 1,y= 1}, 
 }
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
