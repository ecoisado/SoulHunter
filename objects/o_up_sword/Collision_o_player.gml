if alvo == noone && !global.transicao
{
    other.pega_upgrade()
    global.global_upgrade_sword = 1
    alvo = other.id
    movendo()
    
    explosao()
}
