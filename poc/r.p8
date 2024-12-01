pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- r

function _init()
 init_bullets()
 setup_map()
 create_player()
end

function _update()
 move_player()
 update_bullets()
 fire_bullets()
end

function _draw()
 cls()
 draw_map()
 draw_bullets()
 draw_player()
end
-->8
--map 

function setup_map()
 --map tile settings
 wall=0
 key=1
 door=3
 enemy=4
end

function draw_map()
 map(0,0,0,0,128,64)
 mapx=flr(p.x/16)*16
 mapy=flr(p.y/16)*16
 camera(mapx*8,mapy*8)
end

function istile(x,y,type_check)
	local tileid=mget(x,y)
	return fget(tileid,type_check)
end

function can_move(x,y)
	return not istile(x,y,wall)
end
-->8
-- player

function create_player()
 p={}
 p.x=3
 p.y=3
 p.sprite=1
 p.sprite1=1
 p.sprite2=2
 p.ammo=3
 p.a=0 --angle
 p.fdelay=0 --fire delay
 p.ani_max=2 --animation speed
 p.ani=0
end

function draw_player()
 local spradj = 0 --adjusts for rotated
 local flipx = false
 local flipy = false
 if (p.a == 90 or p.a == 270) then
 	spradj=2
 end
 if (p.a == 180) then
 	flipy = true
 end
 if (p.a == 270) then
  flipx = true
 end
 if (p.ani < 1) then
	 if (p.sprite+spradj == p.sprite1+spradj) then
	  p.sprite=p.sprite2
	 else
	  p.sprite=p.sprite1
	 end
  p.ani=p.ani_max
 else
  p.ani-=1
 end
	spr(p.sprite+spradj,p.x*8,p.y*8,1,1,flipx,flipy)
end

function move_player()
 local v=0
 local newx=p.x
 local newy=p.y
 
 if (btnp(⬅️)) p.a-=90
 if (btnp(➡️)) p.a+=90
 p.a=p.a%360

 if (btnp(⬆️)) v=1
 if (btnp(⬇️)) v=-1
 -- move based on angle
 if (p.a==0)   newy-=v
 if (p.a==180) newy+=v 
 if (p.a==90)  newx+=v
 if (p.a==270) newx-=v
 
 if (can_move(newx,newy)) then
  p.x=mid(0,newx,63)
  p.y=mid(0,newy,31)
 else
  sfx(0)
 end
end

-->8
-- bullet
function init_bullets()
	bullets={}
	bullets.fdelay=3
	bullets.max=3
end

function new_bullet(_x,_y,_dx,_dy)
	add(bullets,{
		x=_x+3,
		y=_y+3,
		dx=_dx,
		dy=_dy,
		life=40,
		draw=function(self)
			circfill(self.x, self.y,0.5,9)
		end,
		update=function(self)
			self.x+=self.dx
			self.y+=self.dy
			self.life-=1
			if self.life<1 then
			 del(bullets, self)
			end
			if fget(mget(self.x/8,self.y/8),0) then
				del(bullets, self)			
			end
		end
	})
end

function fire_bullets()
	if btn(❎) then
		if (p.fdelay>0 or #bullets>=bullets.max) then
		 p.fdelay-=1
		 return
		end
	 p.fdelay=bullets.fdelay 
		local dx=0
		local dy=0
		if (p.a==0)   dy=-2
		if (p.a==180) dy=2
		if (p.a==90)  dx=2
		if (p.a==270) dx=-2
		new_bullet(p.x*8,p.y*8,dx,dy)
	end
end

function update_bullets()
 for b in all(bullets) do
  b:update()
 end
end

function draw_bullets()
	for b in all(bullets) do
	 b:draw()
	end
end
__gfx__
00000000500d0050500d005050101015510101050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000150105000501051005555550055555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700055155101551550001ddd50001ddd5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700015d1d50005d1d51001111111011111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700005d1d51015d1d50001ddd50001ddd5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070015d1d50005d1d51005555550055555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000051115101511150051010105501010150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000500000505000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbb00000000bb11ddbb4411dd440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb44bbb4b00000000b11111db411111d40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbb0000000011d1111d11d1111d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbb0000000015dd111115dd11110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb44bb4b00000000155d0111155d01110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbb000000001155dd1b1155dd140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb4b00000000b115d11b4115d1140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbb00000000bbb111bb444111440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666666666667600000000bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666667662666600000000bb444bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666666666676600000000b41114bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666666766666600000000b44544bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666662666667600000000b41554bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666666776266600000000b45154bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666666666676600000000b45154bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6666666666666666000000004111514b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444444cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444441444414cccccccc7ccc7ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444444cccccccccccc7ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444445444d4ccccccccc7cccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444441444cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444444cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444445444445ccccccccccccc7cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444441444cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101010101010101010101010101010101032323210101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010231010101010101010101010101010101010101032323210101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101032323210101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101032333210101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101023101010101010101010101010101010101010101010103232323310101010101010101010101010101010101010101010101010101030313000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010103332323210101010101010101010101010101010101010101010101010103031101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010103232323210101010101010101010101010101010101010101010101010303010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010323232321010101010101010101010101010101010101010101010103030311331101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101032323232101010101010101010101010101010101010101010101010313131101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101032323332101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101310101010101010101010101010103232323210101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3031303010101010101010101010101010101010101010101010103232323210101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303010101010101010101010101010101010101010323232321010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010103030143030301010101010101010101010101010101032323232321010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101030303031303030303030303031303030313030303032323232313110101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010303030313031303030303130303031303232323232313031101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101030301010101032323232323210103030313110101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010103232323232323210101031303131101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010323233333232321010101010303031101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010103232323232323232101010101010103030311010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010103232323232323232323210101010101010101030301010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101032323232323332323232101010101010101010101030301010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010323232323232323232101010101010101010101010101030301010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101032323232323332321010101010101010101010101010101030303110101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1032323232323232323232323233333232101010101010101010101010101010101030303110101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232323232323333323232323232321010101010101010101010101010101010101010303010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232323333333333323232321010101010101010101010101010101010101010101010303010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232333232321010101010101010101010101010101010101010101010101010101010303010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232323210101010101010101010101010101010101010101010101010101010101010303110101010101010101010101010101010101010101010101010113200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3210101010101010101010101010101010101010101010101010101010101010101010313010101010101010101010101010101010101010101010101032323200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010101010303010101010101010101010101010101010101010101010101132333200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010101010303110101010101010101010101010101010101010101010103232333200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400000000000000080600d0600d060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
