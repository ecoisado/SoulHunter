espiritual = 0

plat1 = noone
plat2 = noone
plat3 = noone

delay_restart = 120

cria_plat = 0

portal_ativo = 0

cria_plataforma = function()
{
    if !cria_plat 
    {
        if instance_exists(o_slot)
        {
            plat1 = instance_create_layer(o_slot.x, o_slot.y, "Espiritual", o_plataforma_e)
        }
        
        if instance_exists(o_slot2)
        {
            plat2 = instance_create_layer(o_slot2.x, o_slot2.y, "Espiritual", o_plataforma_e)
        }
        
        if instance_exists(o_slot3)
        {
            plat3 = instance_create_layer(o_slot3.x, o_slot3.y, "Espiritual", o_plataforma_e)
        }
        
        cria_plat = 1
    }
   
}

destroi_plataforma = function()
{
    instance_destroy(plat1)
    instance_destroy(plat2)
    instance_destroy(plat3)
    cria_plat = 0
}

muda_bg = function(_sprite)
{
    var lay_id = layer_get_id("Background");
    var back_id = layer_background_get_id(lay_id);
    layer_background_sprite(back_id, _sprite);
}

tile_normal = function(_booleano)
{
    var tile_id = layer_get_id("T_Chao");
    layer_set_visible(tile_id, _booleano);
}

ativa_transicao = function()
{
    if !espiritual
    {
        muda_bg(mundo_espiritual)
        tile_normal(0) 
        espiritual = 1
    }
}

desativa_transicao = function()
{ 
    muda_bg(mundo_original)	
    tile_normal(1)
    espiritual = 0
}

reseta_room = function()
{
    if instance_exists(o_player)
    {
        if o_player.morto
        {
            delay_restart--
            global.vida = global.max_vida
            global.transicao = 0
            global.entrou_transicao = 0
            
            if delay_restart <= 0 
            {
                room_restart()
            }
        }
        
    }
    
}

cria_portal = function()
{
    var tile_id = layer_get_id("Transicao");
    
    if global.transicao 
    {
        layer_set_visible(tile_id, 1);
    }
    else 
    {
        layer_set_visible(tile_id, 0);	
    }
}

criar_up_helice = function()
{
    
    var tile_id = layer_get_id("Upgrades");
    
    if !global.transicao 
    {
        if !global.global_upgrade_helice
        {
            
            layer_set_visible(tile_id, 1);
        }
    }
    else 
    {
        layer_set_visible(tile_id, 0)	
    }
}