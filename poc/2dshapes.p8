pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--2d-shapes
--brettski

t=0
r=4
r2=4
function _setup()
end

function _update()
	t+=1
 	 r=sin((t/175))*10
 	 r2=cos((t/125))*10
 	if r<0 then r*=-1 end
	 --if r<5 then t=0 end
	  --r=max(r,5)
	  --r2=max(r,5)
	 --r=sin((t/125))*10
 	--r=cos((t/125))*10

end

function _draw()
	cls()
	print(r)
	print(t)
	color(3)
	line(0,50,25,0)
	line(25,0,50,50)
	line(50,50,0,50)
	ngon(64,64,r,6,2)
	ngon(85,32,r2,6,2)
end

function ngon(x, y, r, n, color)
  line(color)            -- invalidate current endpoint, set color
  for i=0,n do
    local angle = i/n
    line(x + r*cos(angle), y + r*sin(angle))
  end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
