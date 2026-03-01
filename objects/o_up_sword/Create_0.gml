if global.global_upgrade_sword instance_destroy()
    
visivel = 0

alvo = noone

movendo = function()
{
    if alvo 
    {
        x = alvo.x
        y = alvo.y - 26
    }
}

explosao = function()
{
    repeat (20) 
    {
    	var _part = instance_create_layer(x, y, layer, o_up_part)
        _part.speed = random_range(2, 3)
        _part.direction = random_range(0, 359)
        _part.alvo = alvo
    }
}