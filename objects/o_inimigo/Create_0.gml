velh = 0
velv = 0

velh_max = .5
velv_max = 4

grav = .12

chao = 0

var _layer_id = layer_get_id("T_Chao")
var _layer_id2 = layer_get_id("T_Chao_1")
colisao = [layer_tilemap_get_id(_layer_id), layer_tilemap_get_id(_layer_id2), o_chao]

dir = 1

estado = noone

knockback_h = 1
knockback_v = 0

min_vida = 1
max_vida = 1
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

andando = false
tempo_para_andar = 60

checa_chao = function()
{
    chao = place_meeting(x, y+1, colisao)
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
    var _alvo = instance_place(x, y, o_trigger_damage)

    if _alvo && invencivel <= 0 && !morto
    { 
        if instance_exists(o_player)
        {
            if !o_player.hit
            {
                if !hit vida--
                hit = 1
                knockback(_alvo)
                atordoado = atordoado_duracao
                //invencivel = invencivel_duracao
            }
            
        }
        
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

patrulha = function()
{
    if(chao)
    {
        //diminuindo o tempo para andar...
        tempo_para_andar--
        //...se o tempo zerou eu escolho se ando ou não...
        if(tempo_para_andar <= 0) 
        {
            andando = choose(true, false) 
            
            if(andando)
            {
                //escolhendo se vai pra esquerda ou direita
                velh = choose(-velh_max, velh_max) 
            }
            else 
            {
                //se não andar zera a velh para parar o movimento
                velh = 0	
            }
            
            //resetando o tempo para andar
            tempo_para_andar = room_speed * random_range(1, 2) 
        } 
    }
}

Parado = function()
{
    troca_sprite(s_inimigo_idle)
    
    if velh != 0 estado = Andando
        
    if hit estado = Dano
}

Andando = function()
{
    troca_sprite(s_inimigo_walk)
    
    if velh == 0 estado = Parado
        
    if hit estado = Dano
}

Dano = function()
{
    troca_sprite(s_inimigo_hit)
    
    andando = 0
    
    if atordoado <= 0 
    {
        if vida < 1
        {
            estado = Morto
        }
        else 
        {
        	estado = Parado
        }
        
    }
}

Morto = function()
{
    instance_destroy()
}

estado = Parado



