desenha_vida()

var pc = (global.vida_visual / global.max_vida) * 100

draw_healthbar(20, 20, 200, 40, pc, c_black, c_red, c_aqua, 0, 1, 0)