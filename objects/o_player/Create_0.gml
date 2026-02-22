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
attack = 0

keyboard_set_map(ord("D"), vk_right)
keyboard_set_map(ord("A"), vk_left)
keyboard_set_map(ord("W"), vk_space)

estado = noone

knockback_h = 1
knockback_v = 1

min_vida = 1
max_vida = 3
vida_partes = 0
vida_partes_max = 2
vida = max_vida
morto = 0
hit = 0
dano = 0
invencivel = 0
invencivel_duracao = 60
atordoado = 0
atordoado_duracao = 30

pega_input = function()
{
    right = keyboard_check(vk_right)
    left = keyboard_check(vk_left)
    jump = keyboard_check_pressed(vk_space) 
    attack = keyboard_check_pressed(ord("K")) || mouse_check_button_pressed(mb_left)
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

troca_sprite = function(_sprite = s_chao)
{
    if sprite_index != _sprite
    {
        sprite_index = _sprite
        image_index = 0
    }
}

acabou_animacao = function()
{
    var _spd = sprite_get_speed(sprite_index) / FPS
    if (image_index + _spd >= image_number) 
    {
        return true
    }
}

knockback = function(_alvo = noone)
{
    if(x <= _alvo.x) 
    {
        velh = - knockback_h
        velv = - knockback_v 
        
        if _alvo && dir == -1 dir = 1    
        
    }  
    else 
    {
        velh = knockback_h
        velv = - knockback_v
        
        if _alvo && dir == 1 dir = -1
    }  
}

toma_dano = function()
{
    var _alvo = instance_place(x, y, o_inimigo)

    if _alvo && invencivel <= 0 && !morto
    { 
        vida--
        hit = 1
        knockback(_alvo)
        atordoado = atordoado_duracao
        invencivel = invencivel_duracao
    }
}

Aplica_Trigger = function()
{
    
    var _ind = 4
    
    if !chao
    {
        _ind = 0
    }
    
    
    if image_index == _ind
    {
        trigger_on = 1
        var _atk = instance_create_layer(x + (13 * dir), y+9, layer, o_trigger_damage)
    }
}

reseta_atordoado = function()
{
    if(atordoado > 0)
    {
        atordoado--
        can_flip = 0
    }
    else 
    {
        hit = 0
        dano = 0
    }
}

reseta_invencivel = function()
{
    if invencivel > 0 
    {
        invencivel--
        
        if !morto image_alpha = 0.5
    }
    else 
    {
        image_alpha = 1
    }
}

#region maquina de estados

Parado = function()
{
    troca_sprite(s_player_idle)
    
    if right xor left estado = Andando
        
    if jump estado = Pulando
        
    if !chao estado = Pulando
        
    if hit estado = Dano
        
    if attack estado = Ataque
}

Andando = function()
{
    troca_sprite(s_player_run)
    
    if !right && !left estado = Parado
    
    if jump estado = Pulando
        
    if !chao estado = Pulando
        
    if hit estado = Dano
        
    if attack estado = Ataque_Andando
}

Pulando = function()
{
    if velv < 0 troca_sprite(s_player_jump)
    
    if velv > 0 troca_sprite(s_player_fall)
        
    if chao estado = Parado
        
    if hit estado = Dano
        
    if attack estado = Ataque_Aereo
}

Dano = function()
{
    troca_sprite(s_player_hit)
    
    if atordoado <= 0 estado = Parado
}

Ataque = function()
{
    troca_sprite(s_player_attack)
    
    Aplica_Trigger()
    
    if acabou_animacao() estado = Parado
}

Ataque_Andando = function()
{
    troca_sprite(s_player_attack_run)
    
    Aplica_Trigger()
    
    if acabou_animacao() estado = Parado
}

Ataque_Aereo = function()
{
    troca_sprite(s_player_attack_jump)
    
    Aplica_Trigger()
    
    if acabou_animacao() estado = Pulando
}

estado = Parado

#endregion