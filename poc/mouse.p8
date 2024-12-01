
pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- click
-- brettski

function _init()
 poke(0x5f2d, 0x1) -- enable mouse
	setglobals()
end

function _update()
 mousehdlr()
end

function _draw()
cls()
map()
spr(16,20,20)

spr(1,msx,msy) --pointer
end
-->8
--setup

function setglobals()
 msx=0 --mousex
 msy=0
 mbt=0
 tlx=0	--tile coord
 tly=0
 info=""
end

-->8
--updates

function mousehdlr()
 msx=stat(32)
 msy=stat(33)
 mbt=stat(34)
	tlx = flr(msx/8)
	tly = flr(msy/8) 
	if mtb==1 then
	 info=mget(tlx,tly)
	end
end

-->8
--draws
__gfx__
00000000950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700056500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000005650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23333302000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23666032000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23690632000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23699632000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23666632000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23333332000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000