var _player = place_meeting(x, y, o_player)

if _player && !global.transicao
{
    if !instance_exists(minha_caixa_dialogo)
    {
        minha_caixa_dialogo = instance_create_layer(x, y - 15, "Dialogo", o_caixa_dialogo)
        minha_caixa_dialogo.texto = texto
    }
}
else 
{
    if instance_exists(minha_caixa_dialogo) 
    {
        minha_caixa_dialogo.me_destruir = 1
    }	
}