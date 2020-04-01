pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--text jones
--brettski

function _init()
	poke(0x5f2d,1)
	props={}
	load_properties()
end

function _update60()
	mx=stat(32)
	my=stat(33)
	mp=stat(34)
end

function _draw()
	cls(12)
	map()
	spr(1,mx,my)
	if mp==1 then
	 print("click "..mp.." "..mx.." "..my,0,0,10)
	 local pclick=check_props_click()
	 print(pclick,0,6)
  if pclick!=nil then
   print("clicked ",32,32,9)
   print(pclick.name,32,38)
  end
 end
end

-->8
--properties

function add_prop(
	name,
	x1,y1,x2,y2
)
	local pp={
	 name=name,
		x1=x1,	--property up-left
		y1=y1,
		x2=x2, --property low-right
		y2=y2,
		items={}, --things sold
		jobs={},
	}
	add(props,pp)
end

function make_job(
 title,
 basepay
)
	return {
		title=title,
		basepay=basepay
	}
end

function prop_clicked(
	prop,_mx,_my)
 return prop.x1 <= _mx and
        prop.y1 <= _my and
    				_mx <= prop.x2 and
        _my <= prop.y2
end

function check_props_click()
 for pp in all(props) do
  if pp.x1 <= mx and
     pp.y1 <= my and
    	mx <= pp.x2 and
     my <= pp.y2 then
   return pp
  end
 end
end

function load_properties()
	add_prop("luxury appt",
		0,0,31,23)
	add_prop("rental office",
	 32,0,63,23)
	add_prop("slums",
	 64,0,95,23)
	add_prop("mart",
	 96,0,127,23)
	add_prop("factory",
	 0,104,31,127)
	add_prop("jobs r us",
	 32,104,63,127)
	add_prop("hi-u-squared",
	 64,104,95,127)
	add_prop("e-bits",
	 96,104,127,127)
	add_prop("black's",
	 0,40,31,63)
	add_prop("bank",
	 0,80,31,103)
	add_prop("burger time",
	 96,40,127,63)
	add_prop("q's cloths",
	 96,80,127,103)
end
__gfx__
00000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700177100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000177710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000177771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700177110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c000000aaa00000aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccc000afffa000afffa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c1c1c00aacfcaa00f1f1f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc9cc00aafffaa000fff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccc00aa2f2aa0338f833000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccc0000f222f00f38883f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccc000002220000333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00909000009090000040040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777777
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000007
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000007
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070016007
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070061007
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000007
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000007
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777777
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
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacccccccccccccccc9999999999999999
333333333333333333333333333333331177777777777777777777777777777733aaaaaaaaaaaaaaaaaaaaaaaaaaaaaacccccccccccccccc9999999999999999
33333333333333333333333333333333171771777777777717171177777777773a3aaaaaaaaaaaaaaaaaaaaaaaaaaaaacccccccccccccccc9999999999999999
eee3333eee33e333e3e333e33333333311177177117711171177177777777777333aa3a3a3a3a333aa33a3a3aaaaaaaacc888ccccccccccc9999999999999999
e33e333e3e33e333e3e333e333333333177171717717177711171177777777773aa3a3a3a33aa3a3a333a33aaaaaaaaac8ccc8cccccccc888899999999999999
e33e33e333e3ee33e3e33e3333333333177171717717177717177177777777773aa3a3a3a3aaaa33a3aaa3aaaaaaaaaa8ccccc8ccccccc8c9899999999999999
eee333e333e3eee3e3e3e3333333333311177177111711171717117777777777333aaa3aa3aaaaa3a333a3aaaaaaaaaa8ccccc8ccccccc8c9998999999899899
ee3e33eeeee3e3eee3ee33333333333377777777771777777777777777777777aaaaaaaaaaaaaa3aaaaaaaaaaaaaaaaa8999998999888989ccc8cc8cc888c8cc
e333e3e333e3e33ee3e3e3333333333377777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8999998998999989ccc8c8c8cc8cc88c
e333e3e333e3e333e3e33e333333333377777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8999998998999989c8c8c8c8cc8cc8c8
e333e3e333e3e333e3e33e33333333337777777777777777777777777777777733333a33333a3aaa3a33333aaaaaaaaa899999899988998888c8cc8cccc8c8c8
eeee33e333e3e333e3e333e33333333311177777777771777777777777777777aa3aaaaa3aaa33a33a3aaaaaaaaaaaaa8999998999998999cccccccccccccccc
3333333333333333333333333333333317777777777771771177777777777777aa3aaaaa3aaa3a3a3a333aaaaaaaaaaa9899989999998999cccccccccccccccc
3333333333333333333333333333333311711171117771717777777777777777aa3aaaaa3aaa3aaa3a3aaaaaaaaaaaaa9988898898889999cccccccccccccccc
3333333333333333333333333333333317717171717111771177777777777777aa3aaaaa3aaa3aaa3a3aaaaaaaaaaaaa9999999899999999cccccccccccccccc
3333333333333333333333333333333317717171717171777177777777777777aa3aaa33333a3aaa3a33333aaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333317711171117111711777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaaa999aaaaaaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaa99999aaaaaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaa8bb48aaaaaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaa474bbaaaaaaaaaaaacccccccccccccccc9999999999999999
3333333333333333333333333333333377777777777777777777777777777777aaaaaaaaaaaaaaa99999aaaaaaaaaaaacccccccccccccccc9999999999999999
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444449966666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444966666666666666666666666666666666
55522222222222222222222222222222999999999999999999999999999999994444444444444494494444444944949966666666666666666666666666666666
52222222222222222222222222222222999999999999999999999999999999994444444444444494494944444944949466666666666666666666666666666666
55255525552555255525552525222222922229999929999922999999999999994444444444444494494444444944949966ddd6666dd66666666666ddd6666666
52252525222252252525222525222222999299999929999299999999999999994444444444444499994949994944944466d666666d6d66d666666d6666666666
52255525222252252525222252222222999299229929999299999999999999994444444444444494494944444944944466d666666d6d66666d666d6666666666
52252525552252255525225522222222999292992922299929999999999999994444444444444494494944444999944466dd66dd6dd666d6dddd66dd66666666
22222222222222222222222222222222999292992929929992999999999999994444444444444494494944444444444466d666666d6d66d66d666666d6666666
22222222222222222222222222222222299292992929929992999999999999994444444444444444444444444444444466d666666d66d6d66d666666d6666666
22222222222222222222222222222222922999229992299229999999999999994444444444444444444444444444444466ddd6666dddd6d666d66ddd66666666
2222222222222222222222222222222299999999999999999999999999999999444444444444444444444444444444446666666666666666666d666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
22222222222222222222222222222222999999999999999999999999999999994444444444444444444444444444444466666666666666666666666666666666
55555555555555555555555555555555444444444444444444444444444444449999999999999999999999999999999933333333333333333333333333333333
55555555555555555555555555555555444444444444444444444444444444449999999999999999999999999999999933333333333333333333333333333333
55555555555555555555555555555555444444444444444444444444444444449999999999999999999999999999999938333333333333333333333333333333
55555555555555555555555555555555444444444444444444444444444444449999999999999999999999999999999938333333833333883333333333833333
55bb5555bb5555b5555bbbb5bbbbbbb5444444444444444444444444444444449999999999999999999999999999999938333333388338833333383333833383
55bb5555bb555b5b555b55bb5bbbbb55422222424444244242242242222444449999999999999999999999999999999938333833838838333333388883833883
55b5b55b5b55b555b55b555b555b5555424442424444244242242242442444449999999999999999999999999999999938333833833838333333383383888833
55b55bb55b5b55555b5bbbbb555b5555424444424444244242424242444444449999999999999999999999999999999938333833833888338338383333333833
55b555555b5b55555b5b5b55555b5555422222424444244242424242222444449999999999999999999999999999999938333888833883338338383333338833
55b555555b5bbbbbbb5b55b5555b5555444442424444244242444244442444449999999999999999999999999999999938333333338883338338383333338333
55b555555b5b55555b5b55b5555b5555424442424444244242444242442444449911199111911991911111999999999938888883388338838888333888888333
55b555555b5b55555b5b555b555b5555422222422224222242444242222444449919919199911991999199999999999933333333333333333333333338833333
55b555555b5b55555b5b555b555b5555444444444444444444444444444444449919919199919191999199999999999933333333333333333333333333333333
55555555555555555555555555555555444444444444444444444444444444449911199119919911999199999999999933333333333333333333333333333333
55555555555555555555555555555555444444444444444444444444444444449919919199919911999199999999999933333333333333333333333333333333
55555555555555555555555555555555444444444444444444444488888444449919919111919991999199999999999933333338333333333333333333333333
55555555555555555555555555555555444444444444444444444484444444449999999999999999999999999999999933333388833333333333333333333333
55555555555555555555555555555555444444448888884444888888444444449999999999999999999999999999999933333883833888838888338333333333
55555555555555555555555555555555444488888888448888844444444444449999999999999999999999999999999933333833833833838338388883333333
55555555555555555555555555555555444444444444444444444444444444449999999999999999999999999999999933338888833888838888338333333333
55555555555555555555555555555555444488444444444444444444444444449999999999999999999999999999999933338333883833338333338333333333
55555555555555555555555555555555484884444444444444444444444444449999999999999999999999999999999933388333383833338333338883333333
55555555555555555555555555555555444444444444444444444444444444449999999999999999999999999999999933383333333333333333333333333333
55555555555555555555555555555555444444444444444444444444444444449999999999999999999999999999999933333333333333333333333333333333
__map__
dcdddedfd8d9dadbd4d5d6d7d0d1d2d300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ecedeeefe8e9eaebe4e5e6e7e0e1e2e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fcfdfefff8f9fafbf4f5f6f7f0f1f2f300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f00000000000000000000000000004f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f00000000000000000000000000004f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
74757677000000000000000078797a7b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
84858687000000000000000088898a8b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94959697000000000000000098999a9b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f00000000000000000000000000004f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f00000000000000000000000000004f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071727300000000000000007c7d7e7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8081828300000000000000008c8d8e8f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9091929300000000000000009c9d9e9f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0a1a2a3a4a5a6a7a8a9aaabacadaeaf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0b1b2b3b4b5b6b7b8b9babbbcbdbebf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c2c3c4c5c6c7c8c9cacbcccdcecf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
