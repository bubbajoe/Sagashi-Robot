//
//  Adds a line to the display
// argument0 = the test, argument1 = the color
//
{
  for (i=global.maxline-1; i>0; i-=1)
  {
    global.line[i] = global.line[i-1];
    global.color[i] = global.color[i-1];
  }
    global.line[0] = argument0;
    if (argument1)
    global.color[0] = argument1;
}
