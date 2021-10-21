pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--hiittime 
--brettski

function _init()
	clk={
	 hour=0,
	 min=0,
	 sec=0,
	}
	t={
		s_sec=5, --start sec
		sec=65,  --main counter
  dt=0,  --delta
		ispaused=true,
	}
end

function _update()
 dobutt(getbutt())
 upd_clock()
 upd_timer()
end

function _draw()
	cls()
	rect(0,0,127,127,8)
	draw_clock()
	draw_timer()
	draw_cmds()
	print(t.ispaused,3,121)
end

-->8
--clock

function upd_clock()
	clk.hour=stat(93)
	clk.min=stat(94)
	clk.sec=stat(95)
end

function pad_0(num)
	if num <10 then
	 return "0"..num
	end
	return num
end

function draw_clock()
 local m=pad_0(clk.min)
 local s=pad_0(clk.sec)
	print(clk.hour..":"
		..m..":"
		..s,95,2,9)

end
-->8
--timer

function start_timer()
 t.ispaused=false
 t.dt=tick()
end

function stop_timer()
 t.ispaused=true
end

function toggle_timer()
 if t.ispaused then
  start_timer()
 else
  stop_timer()
 end
end

function reset_timer()
 t.sec=t.s_sec
end

function draw_timer()
 local m=pad_0(flr(t.sec/60))
 local s=pad_0(t.sec%60)
 print("\^w\^t00:"
  ..m..":"..s, 
 4,31,11)
end

function tick()
 return flr(time())
end

function upd_timer()
 if not t.ispaused then
  if t.sec <= 0 then
   do_alarm()
  else
	 	t.sec-=(tick()-t.dt)
	 	t.dt=tick()
 	end
 end
end

function do_alarm()
 --sfx(00)
end
-->8
--ui

function getbutt()
 for i=0,5 do
  if btnp(i) then
   return i
  end
 end
 return -1
end

function dobutt(butt)
 if butt==4 then --🅾️
  reset_timer()
 elseif butt==5 then --❎
  toggle_timer()
 end
end

function draw_cmds()
 stst = t.ispaused and
  "start" or "stop"
 print("controls:",4,88,7)
 print("❎: "..stst)
 print("🅾️: reset")
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600001c5501c5501c5501c5502655023550225501d5501d5501155014550165501d5501d5501e5502655024550225501e5501e5501155014550175501e5501e5501e5501e5501e5502555024550225501f550
