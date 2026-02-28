texto = "cachorro_quente!"

desenha_texto = 0

me_destruir = 0

image_alpha = 0
image_xscale = .1

iniciando = function()
{
    image_xscale = lerp(image_xscale, 2, .2)
    image_alpha = lerp(image_alpha, 0.8, .2)

    y = lerp(y, ystart - 25, .2)
    
    if y <= ystart - 24.95
    {
        desenha_texto = 1
    }
}

finalizando = function()
{
    image_xscale = lerp(image_xscale, 0, 0.2)
    
    image_alpha = lerp(image_alpha, 0, .2)
    
    image_yscale = lerp(image_yscale, 0, .2)
    
    y = lerp(y, ystart+5, .2)
    
    desenha_texto = 0
    
    if image_alpha <= 0.01 instance_destroy()
}