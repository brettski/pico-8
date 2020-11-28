pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--mines 2
--by brettski

function _init()
	t=0
	loaddata()
 setinitvars()	
	
	gamestart()
end

function _update()
	t+=1
	_upd()
end

function _draw()
	camera(cam_x,cam_y)
 _drw()
 drawdebug()
 camerabox()
end
-->8
--startup and setup

function setinitvars()
	gfieldx=0 --x game field end
	gfieldy=0 --logic only no draw offset
	glevel=4  --game level
	bombcount=0
	flgcount=0
	xoff,yoff=0,1 --offset for border
 cxoff,cxoff=xoff*8,yoff*8
 cam_x,cam_y=0,0 --camera xy
 cbox_x=dcbox_x --camera box
 cbox_y=dcbox_y
 cbox_x1=dcbox_x1
 cbox_y1=dcbox_y1
 cbox_tx=cbox_x/8 --tile/map values
 cbox_tx1=cbox_x1/8
 cbox_ty=cbox_y/8
 cbox_ty1=cbox_y1/8
 arrmove=0 --arrow move
end

function gamestart()
	bombs={}
	field={}
	ckstack={} --tiles to check
	debug={}
	local lvl=glevels[glevel]
	gfieldx=lvl.x --logic max
	gfieldy=lvl.y
	gfdrawx=gfieldx+xoff --tile max
	gfdrawy=gfieldy+yoff
 maxcamx=max(gfdrawx*8-56-(dcbox_x1-dcbox_x),0)
 maxcamy=max(gfdrawy*8-56-(dcbox_y1-dcbox_y),0)
	bombcount=lvl.b
 flgcount=bombcount
 --plr move position
	plr_mx,plr_my=getrandpoint(
	 cbox_tx1,cbox_ty1,
	 cbox_tx,cbox_ty
 )
 --plr select position
	plr_sx,plr_sy=plr_mx,plr_my
	
	generatefield()
	genborder()
	_upd=updategame
 _drw=drawgame
end

function generatefield()
	--set bomb locations
	for i=1,bombcount do
		local isuniq=false
		local bx,by=0,0
		while not isuniq do
			bx,by=getrandpoint(gfieldx,gfieldy)
			if not bombs[getfkey(bx,by)] then --not a dup
				isuniq=true
			end
		end
		bombs[getfkey(bx,by)]=-1
	end
	--setup field init val and bombs
	for fx=1,gfieldx do
		for fy=1,gfieldy do
		local fkey=getfkey(fx,fy)
			field[fkey]={
				x=fx, --logicical loc
				y=fy,
				tx=fx+xoff, --tile loc
				ty=fy+yoff,
				val=bombs[fkey] or 0,
				state="cvd", --cvd,ncvd,flg
			}
	 end
 end
 --set bomb counts
 for fx=1,gfieldx do
 	for fy=1,gfieldy do
 	 setbombcnt(fx,fy)
 	end
 end
 --set field tiles to map
 for fx=1,gfieldx do
 	for fy=1,gfieldy do
 		local ft=field[getfkey(fx,fy)]
 		mset(ft.tx,ft.ty,
 			fieldtils[ft.val+2])
 	end
 end
 
end --gen field

function genborder()
 --virticals
 for y=1+yoff, gfdrawy do
  mset(0,y,borderv)
  mset(gfdrawx+1,y,borderv)
 end
 --bottom
 for x=1+xoff,gfdrawx do
 	mset(x,gfdrawy+1,borderh)
 end
 --bottom corners
 mset(0,gfdrawy+1,borderc)
 mset(gfdrawx+1,gfdrawy+1,
  borderc)
end
-->8
--updates

function updategame()
	dobutton(getbutton())
	arrmove=t%12/2
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
  --⬅️➡️⬆️⬇️
  moveplr(movx[butt+1],movy[butt+1])
 elseif butt==4 then
  --🅾️ set flag
  doflag()
 elseif butt==5 then
  --❎ remove barrier
  doselect()
 
 end
end

function updfcover()
 --add(debug,"stk:"..#ckstack)
 if #ckstack > 0 then
  for i=1,#ckstack do
   local fkey=ckstack[1]
   local fp=field[fkey]
   --add(debug,"fkey:"..fkey..
   --    ","..fp.val..","..fp.state)
   if fp.val<0 then
    _upd=gamelose
   elseif fp.state=="flg" then
    --do nothing
   elseif fp.val>0 then
    fp.state="ucvd"
   elseif fp.val==0 and
    fp.state=="cvd" then
    fp.state="ucvd"
    addckstack(fp.x,fp.y)
   end
   del(ckstack,fkey)
  end 
 else
  _upd=updchk4win
 end
end

--check if all bombs flagged
--and nothing is covered
function updchk4win()
 add(debug,"check4win")
 local done=true
 if flgcount==0 then
  add(debug,"flg 0")
  for fx=1,gfieldx do
   for fy=1,gfieldy do
    if field[getfkey(fx,fy)].state=="cvd" then
     add(debug,"cvd found")
     done=false
     break
    end
    if not done then break end
   end
  end
  if done then
   add(debug,"win")
   gamewin()
  end
 end --if flgcount
 _upd=updategame
end

function gamelose()
 for fx=1,gfieldx do
  for fy=1,gfieldy do
   local f=field[getfkey(fx,fy)]
   if f.state!="flg" then 
    f.state="ucvd"
   end
  end
 end
 _drw=drawgameover
 _upd=updategame
end

-->8
--draws

function drawgame()
 cls()
 map()
 drawfcover()
 camera(0,0)
 drawplr()
 drawheader()
 drawarrows()
end

function drawfcover(trsflg)
 trsflg=trsflg or false
 for k,v in pairs(field) do
  if v.state=="flg" then
   palt(6,trsflg)
   spr(48,v.tx*8,v.ty*8)
   palt()
  elseif v.state=="cvd" then
   spr(32,v.tx*8,v.ty*8)
  end
 end
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

function drawplr()
 drawspr(plr_ani,
  plr_mx*8,plr_my*8,8,true)
end

function drawheader()
 rectfill(0,0,127,15,12)
 rect(0,0,127,15,13)
 --print(cbox_x..","..cbox_y..","..cbox_x1..","..cbox_y1,
 print(plr_mx..","..plr_my..","..plr_sx..","..plr_sy,
  2,2,3)
 print(cam_x..","..cam_y,
  2,8,3)
end

function drawgameover()
 cls()
 map()
 drawfcover(true)
 print ("game over", 18,18,2)
 drawplr()
end

function drawarrows()
 if cam_x<maxcamx then
 	spr(arrowr,113+arrmove,64)
 end
 if cam_y<maxcamy then
 	spr(arrowd,64,113+arrmove)
 end
end

--debug stuff--
function drawdebug()
 cursor(1,16)
 color(9)
 for txt in all(debug) do
  print(txt)
 end
 if t%20==0 then
  del(debug,debug[1])
 end
end

function camerabox()
	rect(cbox_x,cbox_y,
	     cbox_x1,cbox_y1,2)
end


-->8
--gameplay

function moveplr(_x,_y)
 local newx=plr_mx+_x
 local newy=plr_my+_y
 if newx >= cbox_tx and
    newx <= cbox_tx1 then
 	plr_mx+=_x
 	plr_sx+=_x
 else 
 	cam_x+=_x*8
 	plr_sx+=_x
 end
 if newy >= cbox_ty and 
    newy <= cbox_ty1 then
  plr_my+=_y
  plr_sy+=_y
 else
  cam_y+=_y*8
  plr_sy+=_y
 end
 plr_sx=min(plr_sx,gfdrawx)
 plr_sy=min(plr_sy,gfdrawy)
 plr_sx=max(plr_sx,xoff+1)
 plr_sy=max(plr_sy,yoff+1)
 --x camera & move control
 --fieled - 2 tiles - box width
 if cam_x <= 0 then
  cam_x=0
  cbox_tx=xoff+1
  cbox_x=cbox_tx*8 --val debug only
 else
  cbox_x=dcbox_x
  cbox_tx=cbox_x/8
 end
 if cam_x >= maxcamx then
 	cam_x=maxcamx
 	cbox_x1=gfdrawx*8-maxcamx
  cbox_tx1=cbox_x1/8
 else
  cbox_x1=dcbox_x1
  cbox_tx1=cbox_x1/8
 end
 
 --y camera & move control
 if cam_y <= 0 then
  cam_y=0
  cbox_ty=yoff+1
  cbox_y=cbox_ty*8 --val debug only
 else
  cbox_y=dcbox_y
  cbox_ty=cbox_y/8
 end
 if cam_y >= maxcamy then
 	cam_y=maxcamy
 	cbox_y1=gfdrawy*8-maxcamy
  cbox_ty1=cbox_y1/8
 else
  cbox_y1=dcbox_y1
  cbox_ty1=cbox_y1/8
 end
 
end

function doflag()
 local fp=field[getfkey(
                 plr_sx-xoff,
                 plr_sy-yoff)]

 if fp.state=="cvd" and flgcount>0 then
  fp.state="flg"
  flgcount-=1
 elseif fp.state=="flg" then
  fp.state="cvd"
  flgcount+=1
 end
end

function doselect()
 add(ckstack,
  getfkey(plr_sx-xoff,
          plr_sy-yoff))
 
 _upd=updfcover
end
-->8
--datas

function loaddata()
 --game levels
	glevels={
		{x=10,y=10,b=10},
		{x=15,y=10,b=15},
		{x=15,y=15,b=22},
		{x=20,y=20,b=40},
	}
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
 --button moves
 movx={-1,1,0,0}
 movy={0,0,-1,1}
 --sprite references
 fieldtils={16,17,18,19,20,
           21,22,23,24,25}
 plr_ani={1,2,3,4}
 fcover={32}
 flag={48}
 borderv=57
 borderh=56
 borderc=58
 arrowr=61
 arrowd=60
 --camara box defaults
 dcbox_x=24
 dcbox_y=24
 dcbox_x1=80 
 dcbox_y1=80

end

-->8
--utils

function getfkey(x,y)
 return x..","..y
end

--calc and ret random point
function getrandpoint(
	maxx,maxy,minx,miny)
	minx=minx or 0
	miny=miny or 0
 return flr(rnd(maxx-minx))+1+minx,
        flr(rnd(maxy-miny))+1+miny
end

--set bomb count around point
function setbombcnt(_x,_y)
 local fieldpt=field[getfkey(_x,_y)]
 --if on bomb, skip
 if fieldpt.val==-1 then return end
 local count=0
 for pt in all(aroundpt) do
  local ax,ay=_x+pt.x,_y+pt.y
  
  if ax<1 or ay<1 or
     ax>gfieldx or ay>gfieldy then
  	--do nothing out of bound
  else
   local ptval=field[getfkey(ax,ay)]
   if ptval.val==-1 then
    count+=1
   end
  end
 end 
 fieldpt.val=count
end

--adds checks for all around a point
function addckstack(_x,_y)
 --add(debug,"addsk:".._x..",".._y)
 for pt in all(aroundpt) do
  local ax,ay=_x+pt.x,_y+pt.y
  
  if ax<1 or ay<1 or
     ax>gfieldx or ay>gfieldy then
  	--do nothing
  else
   local fstate=field[getfkey(ax,ay)].state
   if fstate == "cvd" then
    add(ckstack,getfkey(ax,ay))
   end
  end
 end
end

__gfx__
00000000880000880880000000088000000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000800000080000000800000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000800000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000080000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000080000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000008000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000800000088000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000880000880000088000088000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000
6188881d6666666d66aa666d6699966d6688866d6686866d6688866d66eee66d66eee66d6600066d000000000000000000000000000000000000000000000000
6889988d6666666d666a666d6666966d6666866d6686866d6686666d66e6666d6666e66d6606066d000cc0000000000000000000000000000000000000000000
689aa98d6666666d666a666d6699966d6668866d6688866d6688866d66eee66d6666e66d6600066d00cccc000000000000000000000000000000000000000000
689aa98d6666666d666a666d6696666d6666866d6666866d6666866d66e6e66d6666e66d6606066d00cccc000000000000000000000000000000000000000000
6889988d6666666d66aaa66d6699966d6688866d6666866d6688866d66eee66d6666e66d6600066d000cc0000000000000000000000000000000000000000000
6188881d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d000000000000000000000000000000000000000000000000
6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd000000000000000000000000000000000000000000000000
66666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6ffffffd6444440d6440444d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6ffffffd6444044d6404444d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6ffffffd6404404d6044444d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6ffffffd6440444d6404444d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6ffffffd6404444d6044444d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6ffffffd6444444d6044444d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6ddddddd6ddddddd6ddddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6666666600000000000000000000000000000000000000000000000000000000ddddddddd666666ddddddddd0000000000000000000000000000000000000000
6696666d0000000000000000000000000000000000000000000000000000000066666666d666666dd666666d06666660000e0000000000000000000000000000
664ee86d0000000000000000000000000000000000000000000000000000000066666666d666666dd666666d06666660000e000000000e000000000000000000
6648886d0000000000000000000000000000000000000000000000000000000066666666d666666dd66dd66d06666660000e0000000000e00000000000000000
6648866d0000000000000000000000000000000000000000000000000000000066666666d666666dd66dd66d06666660000e00000eeeeeee0000000000000000
6646666d0000000000000000000000000000000000000000000000000000000066666666d666666dd666666d066666600e0e0e00000000e00000000000000000
6111666d0000000000000000000000000000000000000000000000000000000066666666d666666dd666666d0666666000eee00000000e000000000000000000
6ddddddd00000000000000000000000000000000000000000000000000000000ddddddddd666666ddddddddd00000000000e0000000000000000000000000000
