if global.transicao
{
    visivel = 0
}
else 
{
    visivel = 1	
}

if alvo 
{
    image_alpha -= 0.02   
    
    if image_alpha <= 0 instance_destroy()
}