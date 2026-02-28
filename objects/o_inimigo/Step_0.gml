checa_chao()
aplica_gravidade()
toma_dano()
patrulha()
aplica_movimento()
if !hit flip()

reseta_atordoado()

if(place_meeting(x + sign(velh), y, colisao) || (!pode_cair && !place_meeting(x + (velh * 10), y + 1, colisao))) 
{
    if !hit velh *= -1
}
    
estado()
