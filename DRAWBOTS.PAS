Unit drawbots;

Interface
procedure paintblock(xh,yh,n,p,block_type,i:integer);
Implementation

uses graph,paint2;
var pics:mas1;
procedure paintblock;
begin
if i=1 then begin painthero2(pics); painthero3(pics); end;
if (n=1)and(p=1)and(block_type=1) then putimage(xh-20,yh-30,pics[1]^,copyput);
if (n=-1)and(p=1)and(block_type=1) then putimage(xh-20,yh-30,pics[2]^,copyput);
if (n=1)and(p=2)and(block_type=1) then putimage(xh-20,yh-30,pics[3]^,copyput);
if (n=-1)and(p=2)and(block_type=1) then putimage(xh-20,yh-30,pics[4]^,copyput);
if (n=1)and(p=1)and(block_type=2) then putimage(xh-20,yh-30,pics[5]^,copyput);
if (n=-1)and(p=1)and(block_type=2) then putimage(xh-20,yh-30,pics[6]^,copyput);
if (n=1)and(p=2)and(block_type=2) then putimage(xh-20,yh-30,pics[7]^,copyput);
if (n=-1)and(p=2)and(block_type=2) then putimage(xh-20,yh-30,pics[8]^,copyput);
if (n=1)and(p=3)and(block_type=1) then putimage(xh-20,yh-30,pics[9]^,copyput);
if (n=-1)and(p=2)and(block_type=2) then putimage(xh-20,yh-30,pics[10]^,copyput);
end;
end.
