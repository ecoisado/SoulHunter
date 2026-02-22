velh = 0
velv = 0

velh_max = 1
velv_max = 4

grav = .12

chao = 0

dir = 1

right = 0
left = 0
jump = 0

pega_input = function()
{
    right = keyboard_check(vk_right)
    left = keyboard_check(vk_left)
    jump = keyboard_check_pressed(vk_space) 
}

checa_chao = function()
{
    chao = place_meeting(x, y+1, o_chao)
}

aplica_gravidade = function()
{
    if chao
    {
        velv = 0
        y = round(y)
    }
    else 
    {
        velv += grav
        velv = clamp(velv, -velv_max, velv_max)	
    }
}

aplica_velocidade = function()
{
    velh = (right - left) * velh_max
    
    if jump && chao velv = -velv_max
}

aplica_movimento = function()
{
    move_and_collide(velh, 0, o_chao, 12)
    move_and_collide(0, velv, o_chao, 12)
}

flip = function()
{
    if velh!=0 dir = sign(velh)
}