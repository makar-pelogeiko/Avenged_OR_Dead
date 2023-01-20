uses paint2,graph;
var  xh,yh,gd,gm:integer;
     n,p,i:integer;
     pics:mas1;
begin
initgraph(gm,gd,'c:\tp7\bgi');
painthero2(pics);
painthero3(pics);
putimage(10,10,pics[1]^,copyput);
putimage(10,100,pics[2]^,copyput);
putimage(100,10,pics[3]^,copyput);
putimage(100,100,pics[4]^,copyput);
putimage(150,10,pics[5]^,copyput);
putimage(150,100,pics[6]^,copyput);
putimage(200,10,pics[7]^,copyput);
putimage(200,100,pics[8]^,copyput);
putimage(250,10,pics[9]^,copyput);
putimage(250,100,pics[10]^,copyput);

putimage(350,10,pics[9]^,copyput);
readln;
closegraph;
end.