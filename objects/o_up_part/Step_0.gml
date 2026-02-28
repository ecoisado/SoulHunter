if !alvo exit
    
image_xscale = lerp(image_xscale, speed * 3, 0.2)
image_angle = direction
  
if !voltar
{
    speed -= vel
    
    if speed <= 0 
    {
        voltar = 1
        
        var _x = alvo.x + random_range(-4, 4)
        var _y = alvo.y - 12 + random_range(-4, 4)
        var _dir = point_direction(x, y, _x, _y)
        direction = _dir 
    }
}
else 
{
    speed += vel
    
    var _player = instance_place(x, y, o_player)
    
    if _player 
    {
        with (_player) 
        {
            var _xscale = random_range(-0.2, 0.2)
            var _yscale = random_range(-0.2, 0.2)
            efeito_squash(1 + _xscale, 1 + _yscale)	
        }
        instance_destroy()
    } 
}

//