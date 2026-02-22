velh = 0
velv = 0

velh_max = 1
velv_max = 4

grav = .12

chao = 0

dir = 1

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
    var _alvo = instance_place(x, y, o_player)

    if _alvo && invencivel <= 0 && !morto
    {
        //if !_alvo.morto && !_alvo.hit
        //{
            
        //}
        
        vida--
        hit = 1
        knockback(_alvo)
        atordoado = atordoado_duracao
        invencivel = invencivel_duracao
    }
}

Parado = function()
{
    troca_sprite(s_inimigo)
    
    if velh != 0 estado = Andando
        
    //if jump estado = Pulando
        
    if !chao estado = Pulando
        
    if hit estado = Dano
}

Andando = function()
{
    troca_sprite(s_inimigo)
    
    //if jump estado = Pulando
        
    if !chao estado = Pulando
        
    if hit estado = Dano
}

Pulando = function()
{
    if velv < 0 troca_sprite(s_inimigo)
    
    if velv > 0 troca_sprite(s_inimigo)
        
    if chao estado = Parado
        
    if hit estado = Dano
}

Dano = function()
{
    troca_sprite(s_inimigo)
}

estado = Parado