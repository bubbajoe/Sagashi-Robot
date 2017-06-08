//
//  Initializes the collection of lines for display
//
{
  global.maxline = 18;
  for (i=global.maxline; i>=0; i-=1)
  {
    global.line[i] = '';
    global.color[i] = c_white;
  }
}
