Unit drawhero;

Interface
procedure painthero(xh,yh,n,p,i:integer);
Implementation

uses graph,paint1;
var picsed:mas2;
    picmet:mas3;
procedure painthero;
begin
if i=1 then painthero1(picsed,picmet);
if (n=1)and(p=1)then putimage(xh-20,yh-30,picsed[1]^,copyput);
if (n=-1)and(p=1)then putimage(xh-20,yh-30,picsed[2]^,copyput);
if (n=1)and(p=2)then putimage(xh-20,yh-30,picsed[3]^,copyput);
if (n=-1)and(p=2)then putimage(xh-20,yh-30,picsed[4]^,copyput);
if (n=1)and(p=3)then putimage(xh-20,yh-30,picmet[1]^,copyput);
if (n=-1)and(p=3)then putimage(xh-20,yh-30,picmet[2]^,copyput);
end;
end.


