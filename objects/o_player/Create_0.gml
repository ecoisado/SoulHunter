x = global.pos_inicial_x
y = global.pos_inicial_y

inicia_efeito_squash()

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

tremer = 0

var _layer_id1 = layer_get_id("T_Chao")
var _layer_id2 = layer_get_id("T_Chao_1")
colisao = [layer_tilemap_get_id(_layer_id1), layer_tilemap_get_id(_layer_id2)]

dir = 1

right = 0
left = 0
jump = 0
attack = 0
soul = 0

pode_sugar = 0

deadzone = 0

keyboard_set_map(ord("D"), vk_right)
keyboard_set_map(ord("A"), vk_left)
keyboard_set_map(ord("W"), vk_space)

estado = noone

knockback_h = 1
knockback_v = 1

hit = 0
dano = 0
morto = 0
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
    change = keyboard_check_pressed(ord("E"))
    soul = keyboard_check(ord("Q")) || mouse_check_button(mb_right)
}

checa_chao = function()
{
    chao = place_meeting(x, y+1, colisao)
}

checa_teto = function()
{
    teto = place_meeting(x, y-1, colisao)
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
    move_and_collide(velh, 0, colisao, 12)
    move_and_collide(0, velv, colisao, 12)
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
            _alvo.andando = 0
            global.vida--
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
    
    if global.vida_partes == global.vida_partes_max
    {
        global.vida_partes = 0 
        global.max_vida++
        global.vida = global.max_vida
    }
    
    for (var i = 0; i < global.max_vida; i++) 
    {
        //draw_sprite_ext(s_vida_hud, 1, 20 + (_espaco*i), 20, _escala, _escala, 0, c_white, 1)	
    }
    
    for (var i = 0; i < global.vida; i++) 
    {
        //draw_sprite_ext(s_vida_hud, 0, 20 + (_espaco*i), 20, _escala, _escala, 0, c_white, 1)	
    }
    
    if global.transicao //munda das almas
    {
        if global.vida < 0 morto = 1
    }
    else 
    {
        if global.vida < 1
        {
            if !global.entrou_transicao 
            {
                global.transicao = 1
                global.vida = 0
                global.entrou_transicao = 1
            }
        }
        	
    }
}

suga_alma = function()
{
    var _nearest= instance_nearest(x, y, o_alma);
    if (_nearest != noone)
    {
        if (point_distance(x, y, _nearest.x, _nearest.y) < 60) && !morto
        { 
            image_blend = c_aqua
            pode_sugar = 1
            var _vel = 0.05; // Velocidade da suavização (0 a 1)
            
            if soul
            {
                _nearest.x = lerp(_nearest.x, o_player.x, _vel);
                _nearest.y = lerp(_nearest.y, o_player.y-5, _vel);   
            }
        }
        else 
        {
            pode_sugar = 0
            image_blend = c_white	
        }
    }
    else 
    {
        pode_sugar = 0
        image_blend = c_white	
    }
}

troca_mundos = function()
{
    if change && chao
    {
        if global.transicao
        {
            //estou no mundo das almas e quero sair
            if place_meeting(x, y, o_transicao) && global.vida == global.max_vida
            {
                if instance_exists(o_game) 
                {
                    global.transicao = 0
                    o_game.desativa_transicao() 
                    global.entrou_transicao = 0
                }
            }
        }
        else 
        {
            //estou fora do mundo das almas e quero entrar	
            if !global.entrou_transicao 
            {
                global.transicao = 1
                global.vida = 0
                global.entrou_transicao = 1
            }
            
        }
    }
}

entra_porta = function()
{
    var _porta = instance_place(x+sign(velh), y, o_porta)

    if _porta != -4 
    {
        if room_get_name(room) == "Room1"
        {
            if _porta.porta == "E"
            {
                global.pos_inicial_x = 372
                global.pos_inicial_y = 204
            } 
            
            if _porta.porta == "D"
            {
                global.pos_inicial_x = 12
                global.pos_inicial_y = 132
            }
        }
        
        if room_get_name(room) == "Room1_a"
        {
            if _porta.porta == "E"
            {
                global.pos_inicial_x = 372 //posicao na room1
                global.pos_inicial_y = 132
            } 
            
            if _porta.porta == "D"
            {
                global.pos_inicial_x = 12
                global.pos_inicial_y = 132
            }
            
        }
        
        if room_get_name(room) == "Room1_b"
        {
            if _porta.porta == "E"
            {
                global.pos_inicial_x = 372
                global.pos_inicial_y = 132
            } 
            
            if _porta.porta == "D"
            {
                global.pos_inicial_x = 12
                global.pos_inicial_y = 204
            }
            
        }
        
        if room_get_name(room) == "Room2"
        {
            global.pos_inicial_x = 12
            global.pos_inicial_y = 132
        }
        
        if room_get_name(room) == "Room3"
        {
            global.pos_inicial_x = 372
            global.pos_inicial_y = 132
        }
        
        
        room_goto(_porta.destino)
    }
}

pega_upgrade = function()
{
    estado = Up_Inicio
}



#region maquina de estados

Parado = function()
{ 
    troca_sprite(s_player_idle)
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    if right xor left estado = Andando
        
    if jump && chao
    {
        instance_create_depth(x, y, depth-1, o_pulo_part)
        efeito_squash(.5, 1.5)
        estado = Pulando
    }
        
    if !chao estado = Pulando
        
    if hit estado = Dano
        
    //if attack estado = Ataque
        
    if attack && chao && ataque_intervalo <= 0 && global.global_upgrade_sword
    {
        ataque_intervalo = ataque_intervalo_duracao
        atacando = 1
        estado = Ataque
    }
    
    if soul estado = Pega_Alma
    
    if place_meeting(x,y,o_deadzone)
    {
        estado = Dano    
    }
}

Andando = function()
{
    troca_sprite(s_player_run)
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    if !right && !left estado = Parado
    
    if jump && chao
    {
        instance_create_depth(x, y, depth-1, o_pulo_part)
        efeito_squash(.5, 1.5)
        estado = Pulando
    }
        
    if !chao estado = Pulando
        
    if hit estado = Dano
        
    if attack && chao && global.global_upgrade_sword
    {
        atacando = 1
        estado = Ataque_Andando
    }
    
    if soul estado = Pega_Alma
        
    if deadzone
    {
        estado = Dano    
    }
    
}

Pulando = function()
{
    image_blend = c_white
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    if velv < 0 
    {
        troca_sprite(s_player_jump)
        
        if array_contains(colisao, o_plataforma_e)
        {
            var _ind = array_get_index(colisao, o_plataforma_e)
            
            array_delete(colisao, _ind, 1)
        }
    }
    
    if velv > 0 
    {   
        troca_sprite(s_player_fall)
        
        if !place_meeting(x, y, o_plataforma_e)
        {
            if !array_contains(colisao, o_plataforma_e) 
            {
                array_push(colisao, o_plataforma_e)
            }
        }
        else 
        {
            colisao[2] = o_chao	
        }
    }
     
    if velv > 0 && jump 
    {
        if jumpHeld && global.global_upgrade_helice
        {
            planando = 1
            estado = Planando
        } 
    }
       
    if chao 
    {
        instance_create_depth(x, y, depth-1, o_queda_part)
        efeito_squash(1.5, .7)
        estado = Parado
    }
        
    if hit estado = Dano
        
    //if attack estado = Ataque_Aereo
        
    if attack && ataque_intervalo <= 0 && global.global_upgrade_sword
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
    
    if deadzone
    {
        estado = Dano    
    }
}

Planando = function()
{
    troca_sprite(s_player_fly)
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    if acabou_animacao() estado = Planando_loop
        
    if deadzone
    {
        estado = Dano    
    }
}

Planando_loop = function()
{ 
    troca_sprite(s_player_fly_loop)
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    if !place_meeting(x, y, o_plataforma_e)
    {
        if !array_contains(colisao, o_plataforma_e) 
        {
            array_push(colisao, o_plataforma_e)
        }
    }
    else 
    {
        colisao[2] = o_chao	
    }
    
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
    
    if deadzone
    {
        estado = Dano    
    }
}

Dano = function()
{
    troca_sprite(s_player_hit)
    
    screenshake(2)
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
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
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    Aplica_Trigger()
    
    if acabou_animacao() 
    {
        atacando = 0
        estado = Parado
    }
    
    if hit estado = Dano
}

Ataque_Andando = function()
{
    troca_sprite(s_player_attack_run)
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    Aplica_Trigger()
    
    if acabou_animacao() 
    {
        atacando = 0
        estado = Parado
    }
    
    if hit estado = Dano
}

Ataque_Aereo = function()
{
    troca_sprite(s_player_attack_jump)
    
    if !hit && !morto && !soul aplica_velocidade()
        
    aplica_movimento()
    
    Aplica_Trigger()
    
    if acabou_animacao() 
    {
        atacando = 0
        estado = Parado
    }
    
    if hit estado = Dano
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

Up_Inicio = function()
{
    troca_sprite(s_player_up_inicio)
    
    velh = 0
    
    aplica_movimento()
    
    if acabou_animacao() estado = Up_Loop
}

Up_Loop = function()
{
    troca_sprite(s_player_up_loop)
    
    velh = 0
    
    aplica_movimento()
    
    if !instance_exists(o_up_part) estado = Up_Final
}

Up_Final = function()
{
    troca_sprite(s_player_up_fim)
    
    aplica_movimento()
    
    if acabou_animacao() estado = Parado
}

estado = Parado


#endregion


