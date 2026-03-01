if !hit && !morto pega_input()
checa_chao()
checa_teto()
aplica_gravidade()

toma_dano()

if !hit flip()
    
reseta_atordoado()
reseta_invencivel()
reseta_ataque()
suga_alma()
troca_mundos()
entra_porta()

estado()

if place_meeting(x,y,o_deadzone) 
{
    deadzone = 1
    global.vida--
}
else 
{
    deadzone = 0	
}

retorna_squash()

global.vida_visual = lerp(global.vida_visual, global.vida, 0.05)

if (abs(global.vida_visual - global.vida) < 0.01) 
{
    global.vida_visual = global.vida;
}
