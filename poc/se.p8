pico-8 cartridge // http://www.pico-8.com
version 24
__lua__
--init

function _init()

spid={
 sp=1,
 x=59,
 y=59,
 h=8,
 w=8,
 dx=0,
 dy=0, 
 maxdx=2,
 maxdy=3,
 acc=0.4,
 boost=4,
 anim=0,
 running=false,
 jumping=false,
 falling=false,
 crouching=false,
 flp=false,
 }


 grav=1.2
 friction=0.85



end






-->8
--update

function _update()

 spid.x+=spid.dx
 spid.y+=spid.dy



 spid_update()
 spid_animation()


end
-->8
--draw

function _draw()

cls()
spr(spid.sp,spid.x,spid.y,1,1,spid.flp)
map(0,0)
end
-->8
--collisions

function obj_collision(obj,aim,flag)
 --obj = table and needs x,y,w,h

 local x=obj.x local y=obj.y
 local w=obj.w local h=obj.h

 local x1=0 local y1=0
 local x2=0 local y2=0

 if aim=="left" then
  x1=x-1   y1=y
  x2=x     y2=y+h-1

 elseif aim=="right" then
  x1=x+w   y1=y
  x2=x+w+1 y2=y+h-1

 elseif aim=="up" then
  x1=x+1   y1=y-1
  x2=x+w-1 y2=y

 elseif aim=="down" then
  x1=x     y1=y+h
  x2=x+w   y2=y+h
 end

 -- convert pixels to tiles

 x/=8 y1/=8
 x/=8 y2/=8

 if fget(mget(x1,y1),flag)
 or fget(mget(x1,y2),flag)
 or fget(mget(x2,y1),flag)
 or fget(mget(x2,y2),flag) then
    return true
   else
    return false
  end

end
-->8
--player

function spid_update()

 spid.dy+=grav
 spid.dx*=friction
 end

 if btn(2) then
  spid.dx-=spid.acc
  spid.running=true
  spid.flp=true
  end
 if btn(1) then
  spid.dx+=spid.acc
  spid.running=true
  spid.flp=false
  end

 if btnp(❎)
 and spid.landed then
  spid.dy-=spid.boost
  spid.landed=false
 end

 if spid.dy>0 then
  spid.falling=true
  spid.landed=false
  spid.jumping=false
  end
  if obj_collision(spid,"down",0) then
    spid.landed=true
    spid.falling=false
    spid.dy=0
    spid.y-=(spid.y+spid.h)%8

elseif spid.dy<0 then
  spid.jumping=true
  if obj_collision(spid,up,1) then
   spid.dy=0
 end
end



if spid.dx<0 then
 if obj_collision(spid,"left",1) then
  spid.dx=0
 end


elseif spid.dx>0 then
 if obj_collion(spid,"right",1) then    
  spid.dx=0
  end

end
