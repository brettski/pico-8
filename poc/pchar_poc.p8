pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

function _init()
 poke(0x5f2d, 1) --mouse
 mbit=""
 mhex="" 
end

function _update()
 msx=stat(32)
 msy=stat(33)
 mbt=stat(34)
 tlx=flr(msx/8)
 tly=flr(msy/8)
 if mbt==1 and msx<64 and msy<64 then
  mset(tlx,tly,1)
 elseif mbt==2 and msx<64 and msy<64 then
  mset(tlx,tly,0)
 end
 if btnp(❎) then
  clearmap()
 elseif btnp(🅾️) then
  toclip(mbit)
 elseif btnp(⬇️) then
  importhex("447cb67c3e7f0106")
 end
 mhex,mbit=getmapvals()
end

function _draw()
	cls()
	map()
	rect(0,0,63,63,15)
	print("char edit",80,2,12)
 drawins()

 print(mhex,65,15,12)
 --line(76,32,76,40,9)
 rect(77,31,86,40,15)
 print("\^."..mbit,78,32,7)
 print("\^."..mbit,90,32,7) 
 spr(2,msx,msy) --mouse
end



--cls()
--print("")
--print("\^:247cb67c3e7f0106")
--print("")

-->8
--utils

function toclip(val)
 printh(val, "@clip")
end

function tohex(num)
 assert(num<=255,"value must be 255 or less")
	local h=tostr(num,1)
	return sub(h,5,6)
end

function getmapvals()
	local bmap=""
	local hmap=""
 local row=0
 for y=0,7 do
  for x=0,7 do
   -- 1+2+4+8+16+32+64+128
  	row+=mget(x,y)*(2^x)
  end
  hmap=hmap..tohex(row)
  bmap=bmap..chr(row)
  row=0
 end
 return hmap,bmap
end

function clearmap()
 for x=0,15 do
  for y=0,15 do
   mset(x,y,0)
  end
 end
end
-->8
--draws

function drawins()
 print("r-mouse adds",1,68,6)
 print("l-mouse removes")
 print("❎ to reset")
 print("🅾️/c send to clipboard")
 
end
-->8
--import

function importhex(hex)
 printh("importhex()")
 -- 1+2+4+8+16+32+64+128
 rpos={0x01,0x02,0x04,0x08,
       0x10,0x20,0x40,0x80}
 assert(#hex==16,"import hex must be a 16 char string")
 hexparts={}
 for i=1,15,2 do
  add(hexparts,sub(hex,i,i+1))
 end
 for p in all(hexparts) do
  printh(p)
 end
  
 local row
 for y=0,7 do
   row=tonum("0x"..hexparts[y+1])
  for x=0,7 do
   if row & rpos[x+1] > 0 then
    mset(x,y,1)
   end
  end
 end
 
end

__gfx__
00000000060606067777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000606060607760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700060606067676000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000606060607067600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000060606060006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700606060600000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
