draw_self()

if mostrar_botao
{
    draw_set_font(fnt_dialogo)
    draw_set_halign(0)
    var _x = x + sprite_width/2
    draw_text_transformed(_x, y - 35, "E", .2, .2, image_angle)
    draw_set_halign(-1)
    draw_set_font(-1)
}
