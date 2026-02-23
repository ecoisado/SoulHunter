velh = 0
velv = 0

velh_max = 1.2
velv_max = 4
velv_max_planando = .5

grav = .2
grav_planando = 0.05

planando = 0

chao = 0
teto = 0

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
atacando = 0
ataque_intervalo = 0
ataque_intervalo_duracao = 30

pega_input = function()
{
    right = keyboard_check(vk_right)
    left = keyboard_check(vk_left)
    jump = keyboard_check_pressed(vk_space) 
    jumpHeld = keyboard_check(vk_space)
    attack = keyboard_check_pressed(ord("K")) || mouse_check_button_pressed(mb_left)
    soul = mouse_check_button(mb_right)
}

checa_chao = function()
{
    chao = place_meeting(x, y+1, o_chao)
}

checa_teto = function()
{
    teto = place_meeting(x, y-1, o_chao)
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
        if !planando
        {
            velv += grav
            velv = clamp(velv, -velv_max, velv_max)	
        }
        else 
        {
            velv += grav_planando
            velv = clamp(velv, -velv_max_planando, velv_max_planando)		
        }
        
    }
    
    if teto 
    {
        velv = 0
        velv += grav
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
        if !_alvo.hit
        {
            vida--
            hit = 1
            knockback(_alvo)
            atordoado = atordoado_duracao
            invencivel = invencivel_duracao
        }
        
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

reseta_ataque = function()
{
    if ataque_intervalo > 0
    {
        ataque_intervalo--
    }
}

desenha_vida = function()
{
    var _espaco = 60
    var _escala = 2
    
    if vida_partes == vida_partes_max
    {
        vida_partes = 0 
        max_vida++
        vida = max_vida
    }
    
    for (var i = 0; i < max_vida; i++) 
    {
        draw_sprite_ext(s_vida_hud, 1, 20 + (_espaco*i), 20, _escala, _escala, 0, c_white, 1)	
    }
    
    for (var i = 0; i < vida; i++) 
    {
        draw_sprite_ext(s_vida_hud, 0, 20 + (_espaco*i), 20, _escala, _escala, 0, c_white, 1)	
    }
    
    if vida < 0 morto = 1
}

suga_alma = function()
{
    var _nearest= instance_nearest(x, y, o_alma);
    if (_nearest != noone)
    {
        if (point_distance(x, y, _nearest.x, _nearest.y) < 100)
        { 
            image_blend = c_aqua
            
            if soul
            {
                var _vel = 0.05; // Velocidade da suavização (0 a 1)
                _nearest.x = lerp(_nearest.x, o_player.x, _vel);
                _nearest.y = lerp(_nearest.y, o_player.y-5, _vel);   
            }
        }
        else 
        {
            image_blend = c_white	
        }
    }
    else 
    {
        image_blend = c_white	
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
        
    //if attack estado = Ataque
        
    if attack && chao && ataque_intervalo <= 0
    {
        ataque_intervalo = ataque_intervalo_duracao
        atacando = 1
        estado = Ataque
    }
    
    if soul estado = Pega_Alma
}

Andando = function()
{
    troca_sprite(s_player_run)
    
    if !right && !left estado = Parado
    
    if jump estado = Pulando
        
    if !chao estado = Pulando
        
    if hit estado = Dano
        
    if attack && chao
    {
        atacando = 1
        estado = Ataque_Andando
    }
    
    if soul estado = Pega_Alma
    
}

Pulando = function()
{
    image_blend = c_white
    
    if velv < 0 troca_sprite(s_player_jump)
    
    if velv > 0 troca_sprite(s_player_fall)
     
    if velv > 0 && jump 
    {
        if jumpHeld
        {
            planando = 1
            estado = Planando
        } 
    }
       
    if chao estado = Parado
        
    if hit estado = Dano
        
    //if attack estado = Ataque_Aereo
        
    if attack && ataque_intervalo <= 0
    {
        ataque_intervalo = ataque_intervalo_duracao
        atacando = 1
        estado = Ataque_Aereo
    }
    
    if chao && !attack
    {
        //_inicio_pulo = 1
        //qtd_pulos_atual = qtd_pulos
        //estado = Parado
    }
}

Planando = function()
{
    troca_sprite(s_player_fly)
    
    if acabou_animacao() estado = Planando_loop
}

Planando_loop = function()
{ 
    troca_sprite(s_player_fly_loop)
    
    if !chao && !jumpHeld 
    {
        planando = 0
        estado = Pulando
    }
    
    if chao 
    {
        planando = 0
        estado = Parado
    }
    
    if hit 
    {
        planando = 0
        estado = Dano
    }
}

Dano = function()
{
    troca_sprite(s_player_hit)
    
    if atordoado <= 0 
    {
        if !morto
        {
            estado = Parado
        }
        else 
        {
            estado = Morrendo
            velh = 0	
        }
    }
}

Pega_Alma = function()
{ 
    troca_sprite(s_player_soul)
    
    velh = 0
    
    if !soul 
    {
        estado = Parado
    }
}

Ataque = function()
{
    troca_sprite(s_player_attack)
    
    Aplica_Trigger()
    
    if acabou_animacao() 
    {
        atacando = 0
        estado = Parado
    }
}

Ataque_Andando = function()
{
    troca_sprite(s_player_attack_run)
    
    Aplica_Trigger()
    
    if acabou_animacao() 
    {
        atacando = 0
        estado = Parado
    }
}

Ataque_Aereo = function()
{
    troca_sprite(s_player_attack_jump)
    
    Aplica_Trigger()
    
    if acabou_animacao() 
    {
        atacando = 0
        estado = Parado
    }
}

Morrendo = function()
{
    troca_sprite(s_player_dead)
    
    image_alpha = 1
    
    if acabou_animacao() estado = Morto
}

Morto = function()
{
    troca_sprite(s_player_dead)
    
    image_index = image_number-1
    image_speed = 0
}

estado = Parado

#endregion

