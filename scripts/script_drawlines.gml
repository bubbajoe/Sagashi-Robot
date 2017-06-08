//
//  Draws the collection of lines at the indicated place
//
{
  var xxx,yyy;
  xxx = argument0;
  yyy = argument1;
  draw_set_font(fnt_normal);
  for (i=global.maxline; i>=0; i-=1)
  {
    draw_set_color(global.color[i]); 
    draw_text(xxx,yyy,global.line[i]);
    yyy += 14.3;
  }
}
