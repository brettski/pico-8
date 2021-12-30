pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--paint a char
--by brettski

function _init()
 poke(0x5f2d, 1) --mouse
 setglobals()
end

function _update()
 mousehdlr()
 btnhdlr()
 hchar,bchar,pchar=getcharvals()
end

function _draw()
 cls(5)
 map()
 rect(0,0,127,127,8)--debug
 drw_editor()
 drw_output()
 spr(2,msx,msy) --pointer
end
-->8
--setup

function setglobals()
 msx=0
 msy=0
 mbt=0
 tlx=0
 tly=0
 outtype="hex"
 ic=6 --instr color
 icx="6" --instr color hex
 ihc=3 --instr hlight color
 oc=12
 ocx="c"
 hchar="" --hex char
 bchar="" --byte char
 pchar=""
end
-->8
--updates

function mousehdlr()
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
end


function btnhdlr()
	if btnp(⬅️) then
	 outtype="hex"
	elseif btnp(➡️) then
	 outtype="byte"
	elseif btnp(⬆️) then
	
	elseif btnp(⬇️) then
	
	elseif btnp(🅾️) then
	 toclipboard()
	elseif btnp(❎) then
	 clearchar()	
	end
end

-->8
--draws

function drw_editor()
	rect(0,0,63,63,15)
	print("paint a char",70,2,12)
	drw_instr()
 
end

function drw_output()
 local bmout=""
 bmout="\^."..bchar
 local tstr="quick brown"..bmout
 print(bmout,78,28,7)
 print(bmout,90,28,7) 
	print(tstr,65,41,oc)
	print(#pchar,8,122,10)
	print("ox",65+#tstr*4,41,10)
	print(sub(hchar,1,8),65,52,12)
	print(sub(hchar,9,16))
end

function drw_instr()
 local inst="l-mouse add pixel\n"
 inst=inst.."r-mouse remove pixel\n"
 inst=inst.."❎ to clear editor\n"
 
 inst=inst.."🅾️/c send "
 inst=inst.."\f"..ihc..""..outtype.."\f"..icx.." to clipboard\n"
 inst=inst.."⬅️➡️ change output hex/byte"
 
 print(inst,1,68,ic)
 --print("l-mouse add pixel",1,68,6)
 --print("r-mouse remove pixel")
 --print("❎ to clear editor")
 --print("🅾️/c send \f3"..outtype.."\^c to clipboard")
 --print("⬅️➡️ change output hex/byte")
end
-->8
--utils

function clearchar()
 for x=0,7 do
  for y=0,7 do
   mset(x,y,0)
  end
 end
end

function getcharvals()
 local bm=""
 local hm=""
 local row=0
 for y=0,7 do
  for x=0,7 do
   row+=mget(x,y)*(2^x)
  end
  bm..=trny(row==0,0,chr(row))
  hm..=tohex(row)
  row=0
 end
 return hm,bm,escp_bin_str(bm)
end

function tohex(num)
 local h=tostr(num,1)
	return sub(h,5,6)
end

function escp_bin_str(s)
 local out=""
 for i=1,#s do
  local c  = sub(s,i,i)
  local nc = ord(s,i+1)
  local pr = (nc and nc>=48 and nc<=57) and "00" or ""
  local v=c
  if(c=="\"") v="\\\""
  if(c=="\\") v="\\\\"
  if(ord(c)==0) v="\\"..pr.."0"
  if(ord(c)==10) v="\\n"
  if(ord(c)==13) v="\\r"
  out..= v
 end
 return out
end

function toclipboard()
 if (outtype=="hex") then
  printh(hchar,"@clip")
 else
  printh(escp_bin_str(bchar),"@clip")
 end
end

function trny(c,t,f)
 if (c) return t
 return f
end
__gfx__
00000000676767677777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000767676767760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700676767677676000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000767676767067600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000676767670006700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700767676760000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000676767670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000767676760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
