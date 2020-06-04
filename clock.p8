pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
--clock
--brettski

function _init()
 debug={}
 t={
  hour=0,
  minute=0,
  second=0,
  t=0,
 }
 init_analog()
end

function _update()
 --set time
 t.hour=stat(93)
 t.minute=stat(94)
 t.second=stat(95)
 t.t+=1
 update_analog()
end

function _draw()
 cls()
 draw_digital()
 draw_analog()
 --drawdebug()
end

function drawdebug()
 cursor(1,0)
 color(9)
 for txt in all(debug) do
  print(txt)
 end
 if t.t%5==0 then
  del(debug,debug[1])
 end
end
-->8
--analog

function draw_analog()
 line(clk_cntrx, clk_cntry,
  sechand.x,sechand.y,sechand.col)
-- line(clk_cntrx, clk_cntry,
--  minhand.x,minhand.y,minhand.col)
-- line(clk_cntrx, clk_cntry,
--  hrhand.x,hrhand.y,hrhand.col)
end

function update_analog()
 --(360/60)*v = angle
 sechand.a=sechand.af(60,t.second)
 --minhand.a=minhand.af(60,t.minute)
 --hrhand.a=hrhand.af(24,t.hour)
 set_hand(sechand)
 --set_hand(minhand)
 --set_hand(hrhand)
 
end

function set_hand(hand)
 local a=hand.a
 hand.x=clk_cntrx+cos(a)*hand.len
 hand.y=clk_cntry+sin(a)*hand.len
end

function get_hand_a(d,v)
 return ((360/d)*v)/360
end

function init_analog()
 -- clock center
 clk_cntrx=63
 clk_cntry=45

 sechand={
  len=40,
  col=7,
  x=0,
  y=0,
  af=get_hand_a,
  a=0
 }
 minhand={
  len=40,
  col=11,
  x=0,
  y=0,
  af=get_hand_a,
  a=0,
 }
 hrhand={
  len=25,
  col=9,
  x=0,
  y=0,
  af=get_hand_a,
  a=0,
 }
end
-->8
-- digital

function draw_digital()
 local m=pad_0(t.minute)
 local s=pad_0(t.second)
	print(t.hour..":"
		..m..":"
		..s,48,121,7)

end

function pad_0(num)
	if num <10 then
	 return "0"..num
	end
	return num
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
