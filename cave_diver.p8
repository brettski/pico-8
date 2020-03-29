pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- globals
have_hs=false
high_score=0

function _init()
 game_over=false
 have_hs=false
 make_cave()
 make_player()
end

function _update()
 if (not game_over) then
  update_cave()
  move_player()
  check_hit()
 else
  if (btnp(5)) _init() --restart
 end
end

function _draw()
 cls()
 draw_cave()
 draw_player()
 if (game_over) then
  if (high_score<player.score) then
   high_score=player.score
   have_hs=true
  end
  print("game over!", 44, 44, 8)
  print("your score: "..player.score, 34, 54, 7)
  if (have_hs) then
   print("you have new hi score!!",18, 62, 11)
  end
  print("press ❎ to play again!", 18, 72, 6)
 else
  print("score: "..player.score, 2, 2, 7)
  print("high score: "..high_score, 63, 2, 7)
 end

end




-->8
function make_player()
 player={}
 player.x=24
 player.y=60
 player.dy=0
 player.rise=1
 player.fall=2
 player.dead=3
 player.speed=2
 player.score=0
end

function move_player()
 gravity=0.1
 player.dy+=gravity
 -- jump
 if (btnp(2)) then
  player.dy-=4
  sfx(0)
 end
 
 player.y+=player.dy
 
 player.score+=player.speed
end

function draw_player()
 if (game_over) then
  spr(player.dead,player.x,player.y)
	elseif (player.dy<0) then
	 spr(player.rise,player.x,player.y)
	else
	 spr(player.fall,player.x,player.y) 
 end
end

function check_hit()
 for i=player.x, player.x+7 do
  if (cave[i+1].top > player.y
   or cave[i+1].btm < player.y+7) then
   game_over=true
   sfx(1)
  end
 end
end
-->8
function make_cave()
 cave={{["top"]=5,["btm"]=119}}
 top=45
 btm=85
end

function update_cave()
 -- remove the back of the cave
 if (#cave > player.speed) then
  for i=1, player.speed do
   del(cave,cave[1])
  end
 end
 -- add more cave
 while (#cave < 128) do
  local col={}
  local up=flr(rnd(7) - 3)
  local dwn=flr(rnd(7) - 3)
  col.top=mid(3,cave[#cave].top+up,top)
  col.btm=mid(btm,cave[#cave].btm+dwn,124)
  add(cave, col)
 end
end
 
function draw_cave()
 top_color=5
 btm_color=2
 for i=1, #cave do
  line(i-1, 0, i-1, cave[i].top, top_color)
  line(i-1, 127, i-1, cave[i].btm, btm_color) 
 end
end 


__gfx__
0000000000aaaa0000aaaa0000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaa00aaaaaa008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aa0aa0aaaaaaaaaa88988988000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaaaa0aa0aa88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aa0000aaaaaaaaaa88899888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaa00aaaaaa00aaa88988988000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaa00aa00aa008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa0000aaaa0000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000000002c0502c0502c0502a050240501f0501e0501e0502005022050250502805000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003605031050290501f05019050140500e05008050030500005000000000000000000050000500005000000000000000000000000000000000000000000000000000000000000000000000000000000000
