if keyboard_check_pressed(vk_escape) room_restart()
    
if global.transicao
{
    ativa_transicao()
}

if espiritual
{
    cria_plataforma()
}
else 
{
    destroi_plataforma()	
}

cria_portal()
criar_up_helice()


reseta_room()

