ps = part_system_create(ps_rastro_alma)

dist_sin = 0

vel = .1

flutuando = function()
{
    var _tempo = (get_timer() / 1000000) / tempo

    var _sinwave = sin(_tempo * TAU)
    
    var _abssin = (_sinwave + 1) / 2
    
    var _dist_sin = distancia * _abssin 
    
    y = ystart + _dist_sin
}

alarm[0] = 40