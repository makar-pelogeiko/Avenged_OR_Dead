uses paint1,graph,drawhero;
var  xh,yh,gd,gm:integer;
     n,p,i:integer;
     picsed:mas2;
     picmet:mas3;
begin
initgraph(gm,gd,'c:\tp7\bgi');
painthero1(picsed,picmet);
painthero(100,100,1,1,1);
painthero(100,200,-1,1,0);
painthero(150,100,1,2,0);
painthero(150,200,-1,2,0);
painthero(200,100,1,3,0);
painthero(200,200,-1,3,0);
readln;
closegraph;
end.






