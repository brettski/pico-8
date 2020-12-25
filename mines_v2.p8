pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--mines 2
--by brettski

function _init()
	t=0
	loaddata()
 setinitvars()	
	
	--gamestart()
	showlvl()
end

function _update()
	t+=1
	_upd()
end

function _draw()
	camera(cam_x,cam_y)
 _drw()
 drawindow() --dont like this here
 drawdebug()
 --camerabox()
end
-->8
--startup and setup

function setinitvars()
	gfieldx=0 --x game field end
	gfieldy=0  --logic only no draw offset
	glevel=1  --game level
	bombcount=0
	flgcount=0
	xoff,yoff=0,2 --offset for border
 txoff,tyoff=xoff*8,yoff*8
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
 modal={} --modal reference
end

function showlvl()
 printh("showlvl called")
 cls()
	initlvl()
	drawmodal()
	_upd=updmodal
	_drw=function() end
end

function initlvl()
	bombs={}
	field={}
	ckstack={} --tiles to check
	windows={} --dialogs&menu 2 display
	debug={}
end

function gamestart()
 printh("gamestart called")
	local lvl=glevels[glevel]
	gfieldx=lvl.x --logic max
	gfieldy=lvl.y
	gfdrawx=gfieldx+xoff --tile max
 gfdrawy=gfieldy+yoff
 --camera will only need to move
 --if field is larger than view
 maxcamx=max(gfdrawx*8-56-(dcbox_x1-dcbox_x),0)
 maxcamy=max(gfdrawy*8-56-(dcbox_y1-dcbox_y),0)
	bombcount=lvl.b
 flgcount=bombcount
 --plr initial position
 --within field or camera view
	plr_mx,plr_my=getrandpoint(
	 min(cbox_tx1,gfdrawx),
	 min(cbox_ty1,gfdrawy),
	 max(cbox_tx,xoff+1),
	 max(cbox_ty,yoff+1)
 )
 --plr select position
	plr_sx,plr_sy=plr_mx,plr_my
 
 printh("start gen")
	generatefield()
	printh("done gen")
	
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
 --horizontals
 for x=1+xoff,gfdrawx do
  mset(x,yoff,borderh)
 	mset(x,gfdrawy+1,borderh)
 end
 --corners
 mset(0,yoff,borderc)
 mset(gfdrawx+1,yoff,borderc)
 mset(0,gfdrawy+1,borderc)
 mset(gfdrawx+1,gfdrawy+1,
  borderc)
end
-->8
--updates

function updategame()
	dobutton(getbutton())
	arrmove=t%16/3
end

function updmodal()
	local b=getbutton()
	if b==5 then
	 modal.dur=7
	 gamestart()
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
 printh("check4win called")
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
   levelwin()
   return
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

function levelwin()
	glevel+=1 --todo no more levels
	if glevel>#glevels then
	 gamewin()
	 return
	end
	showlvl()
	printh("win newlvl "..glevel)
 _upd=updmodal
 _upd()
 local x = addwindow(20,
		38,
		88,
		50,
		{
		 "great job","",
		 "level "..(glevel-1).." complete!"
		}
	)
	x.dur=45
end

function gamewin()
 cls()
	addwindow(20,
		38,
		88,
		50,
		{
		 "you have found",
		 "all them mines!!"
  }
 )
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
 --[[
 print(cbox_x..","..cbox_y..","..cbox_x1..","..cbox_y1,
 print(plr_mx..","..plr_my..","..plr_sx..","..plr_sy,
  2,2,3)
 print(cam_x..","..cam_y,
  2,8,3)
 ]]--
 spr(64,0,0,6,2)--name
 spr(52,49,5)--flag
 print(flgcount,57,7,9)
 print("level:",99,2,5)
 print(glevel,123,2,9)
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
 if cam_x>0 then
  spr(arrowl,8*xoff+2+arrmove,64)
 end
 if cam_y>0 then
  spr(arrowu,64,8*yoff+2+arrmove)
 end
end

function drawindow()
 for w in all(windows) do
  local wx,wy,ww,wh=w.x,w.y,w.w,w.h
  rectfill(wx,wy,wx+ww-1,wy+wh-1,9)
  rect(wx+1,wy+1,wx+ww-2,wy+wh-2,12)
  
  wx+=3
  wy+=4
  clip(wx,wy,ww-6,wh-4)
  for txt in all(w.txt) do
   print(txt,wx,wy,5)
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

function drawmodal()
 local xx=glevels[glevel]
	modal=addwindow(20,
		38,
		88,
		50,
		{
			"mines2","",
			"level: "..glevel,
			"flags: "..xx.b,
			"tiles: "..xx.x.."x"..xx.y,
		 "","press ❎"
		}
	)
end

--debug stuff--
function drawdebug()
 cursor(1,16)
 color(4)
 for txt in all(debug) do
  print(txt)
 end
 if t%30==0 then
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
	 {x=6,y=6,b=3},
		{x=10,y=10,b=5},
		{x=10,y=10,b=10},
		{x=15,y=10,b=15},
		{x=15,y=15,b=22},
		{x=20,y=20,b=40},
		{x=25,y=25,b=45},
		{x=25,y=25,b=60},		
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
 arrowl=62
 arrowu=63
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
 add(windows,w)
 return w
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
6666666600000000000000000000000000000000000000000000000000000000ddddddddd666666ddddddddd0000000000000000000000000000000000030000
6696666d0000000000000000000000000009000000000000000000000000000066666666d666666dd666666d0666666000030000000000000000000000333000
664ee86d0000000000000000000000000004ee8000000000000000000000000066666666d666666dd666666d0666666000030000000003000030000003030300
6648886d0000000000000000000000000004888000000000000000000000000066666666d666666dd66dd66d0666666000030000000000300300000000030000
6648866d0000000000000000000000000004880000000000000000000000000066666666d666666dd66dd66d0666666000030000033333333333333000030000
6646666d0000000000000000000000000004000000000000000000000000000066666666d666666dd666666d0666666003030300000000300300000000030000
6111666d0000000000000000000000000011100000000000000000000000000066666666d666666dd666666d0666666000333000000003000030000000030000
6ddddddd00000000000000000000000000000000000000000000000000000000ddddddddd666666ddddddddd0000000000030000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bb200bb2bbb2bb200bb2bbbbb2bbbbbb2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbb2bbb2bbb2bbbb2bb2bb2222bb22222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbbbbb2bbb2bbbbbbb2bbbb2b2bbbb20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bb2b2bb2bbb2bb2bbbb2bb222bb222bb2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bb222bb2bbb2bb222bb2bbbbb2bbbbb22000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222022222222222002222222222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222000222022022022200022022222200022222000200000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020202020000200002020020002000200200020002000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020202020000200002020020002000000200000022200000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020020020000200002020020002000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000020000200002020020002000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200000002002020020002002020220002022200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000020000200002002020002000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000020000200002002020002000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000020000200002000220002000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000020000200002000220002000200200020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200000002022022022000022022222202222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccc555c5c5c555c5ccccccc999cd
dcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccc5ccc5c5c5ccc5cccc5cccc9cd
dcbb2ccbb2bbb2bb2ccbb2bbbbb2bbbbbb2cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccc55cc5c5c55cc5cccccccc99cd
dcbbb2bbb2bbb2bbbb2bb2bb2222bb22222cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccc5ccc555c5ccc5cccc5cccc9cd
dcbbbbbbb2bbb2bbbbbbb2bbbb2b2bbbb2cccccccccccccccccc9cccccccccccccccccccccccccccccccccccccccccccccc555c555cc5cc555c555ccccc999cd
dcbb2b2bb2bbb2bb2bbbb2bb222bb222bb2ccccccccccccccccc4ee8c999cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dcbb222bb2bbb2bb222bb2bbbbb2bbbbb22ccccccccccccccccc4888ccc9cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dc222c22222222222cc222222222222222cccccccccccccccccc488cccc9cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dccccccccccccccccccccccccccccccccccccccccccccccccccc4cccccc9cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dcccccccccccccccccccccccccccccccccccccccccccccccccc111ccccc9cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d66dd66d66666666666666666666666666666666666666666666666666666666666666666666666666666666d66dd66d00000000000000000000000000000000
d66dd66d66666666666666666666666666666666666666666666666666666666666666666666666666666666d66dd66d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd66aa666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd66aaa66d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd6ffffffd6666666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d66aa666d66aa666d66aa666d6ffffffd6ffffffd6ffffffd66aa666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d666a666d666a666d666a666d6ffffffd6ffffffd6ffffffd666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d666a666d666a666d666a666d6ffffffd6ffffffd6ffffffd666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d666a666d666a666d666a666d6ffffffd6ffffffd6ffffffd666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d66aaa66d66aaa66d66aaa66d6ffffffd6ffffffd6ffffffd66aaa66d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6ffffffd6ffffffd6ffffffd6666666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666688666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d6666666d6666666d66aa666d6696666d6ffffff866aa666d66aa666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d666a666d664ee86d6ffffff8666a666d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d666a666d6648886d6ffffffd666a666d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d666a666d6648866d6ffffffd666a666d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d66aaa66d6646666d8ffffffd66aaa66d66aaa66d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6111666d8ffffffd6666666d6666666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6dddd88d6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d6666666d6666666d66aa666d66aa666d6699966d6696666d66aa666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d666a666d666a666d6666966d664ee86d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d666a666d666a666d6699966d6648886d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d666a666d666a666d6696666d6648866d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d66aaa66d66aaa66d6699966d6646666d66aaa66d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6111666d6666666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d66aa666d66aa666d66aa666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d666a666d666a666d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d666a666d666a666d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d666a666d666a666d666a666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d66aaa66d66aaa66d66aaa66d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d66aa666d66aa666d66aa666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d666a666d666a666d666a666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d666a666d666a666d666a666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d666a666d666a666d666a666dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d66aaa66d66aaa66d66aaa66dd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666dd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d66aa666d66aa666d6666666d6666666d66aa666d66aa666d66aa666d66aa666d6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d666a666d666a666d6666666d6666666d666a666d666a666d666a666d666a666d6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d666a666d666a666d6666666d6666666d666a666d666a666d666a666d666a666d6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d666a666d666a666d6666666d6666666d666a666d666a666d666a666d666a666d6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d66aaa66d66aaa66d6666666d6666666d66aaa66d66aaa66d66aaa66d66aaa66d6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6666666d6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d6ffffffd66aa666d6666666d6666666d66aa666d6696666d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ffffffd666a666d6666666d6666666d666a666d664ee86d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ffffffd666a666d6666666d6666666d666a666d6648886d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ffffffd666a666d6666666d6666666d666a666d6648866d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ffffffd66aaa66d6666666d6666666d66aaa66d6646666d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ffffffd6666666d6666666d6666666d6666666d6111666d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d66aa666d66aa666d6666666d6666666d66aa666d6688866d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d666a666d666a666d6666666d6666666d666a666d6666866d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d666a666d666a666d6666666d6666666d666a666d6668866d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d666a666d666a666d6666666d6666666d666a666d6666866d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d66aaa66d66aaa66d6666666d6666666d66aaa66d6688866d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6699966d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666966d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6699966d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6696666d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6699966d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6666666d6666666d6666666d6666666d6666666d6666666d6ffffffd6ffffffd6ffffffd6ffffffdd666666d00000000000000000000000000000000
d666666d6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6ddddddd6dddddddd666666d00000000000000000000000000000000
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d66dd66d66666666666666666666666666666666666666666666666666666666666666666666666666666666d66dd66d00000000000000000000000000000000
d66dd66d66666666666666666666666666666666666666666666666666666666666666666666666666666666d66dd66d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
d666666d66666666666666666666666666666666666666666666666666666666666666666666666666666666d666666d00000000000000000000000000000000
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000000000000000000000000000
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

