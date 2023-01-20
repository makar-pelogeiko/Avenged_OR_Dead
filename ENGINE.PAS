Unit engine;

 Interface
  Uses shooting,consts,megashot;

   var turn :integer;
   procedure move_hero(var hero :blockh);
   procedure control_hero(c : char; var hero :blockh; var bul : mas1; var block :arblocks);
   function what_there(xLeft,yDown,xRight,yUp : integer) : boolean;
   procedure erase_hero(q,rh,rh1,xh,yh : integer);
   procedure moving(var hero :blockh);

Implementation
   Uses graph,paint1,drawhero;

 function what_there(xLeft,yDown,xRight,yUp : integer) : boolean;
  var x,y,i : integer;
      b : boolean;
begin
   b:=false;  x:=xLeft; y:=yUp;
   repeat
     if getpixel(x,y)<>ec then b:=true;
     x:=x+1;
     if x>xRight then begin x:=xLeft; y:=y+1; end;
   until (y > yDown) or (b=true);
   what_there:=b;
end;


 procedure move_hero(var hero :blockh);
var
    ie : boolean;
begin
      if turn = 2 then
       turn:=1
      else
       turn:=2;
      if not what_there(hero.x-rh,hero.y+rh1+1,hero.x+rh,hero.y+rh1+1) then turn:=1;
       erase_hero(0,rh,rh1,hero.x,hero.y);
      ie:=what_there(hero.x+hero.dx-rh,hero.y+hero.dy+rh1,hero.x+hero.dx+rh,hero.y+hero.dy-rh1);
      if ie then begin
         hero.dx:=0; hero.dy:=0
      end;
         hero.x:=hero.x+hero.dx; hero.y:=hero.y+hero.dy;
         painthero(hero.x,hero.y,hero.pov,turn,0);
end;

procedure moving(var hero :blockh);
var
    k : integer;
    n : real;
begin
     k:=0; n:=0.9;
  if hero.dy<>0 then k:=1;

  if hero.dx<>0 then begin
    hero.dx:=round(hero.dx*n);
    k:=1;
  end;

  if not what_there(hero.x-rh,hero.y+rh1+1,hero.x+rh,hero.y+rh1+1) then begin
      k:=1;
      hero.dy:=hero.dy+3;
      if (hero.dy>0)and(what_there(hero.x-rh,hero.y+rh1+hero.dy,hero.x+rh,hero.y+rh1+1)) then
        repeat
         hero.dy:=hero.dy-1;
        until not what_there(hero.x-rh,hero.y+rh1+hero.dy,hero.x+rh,hero.y+rh1+1);
  end;

  if k=1 then move_hero(hero);
  if what_there(hero.x-rh,hero.y+rh1+1,hero.x+rh,hero.y+rh1+1) then begin
   hero.dx:=0; hero.dy:=0;
  end;
end;

 procedure control_hero(c : char; var hero :blockh; var bul : mas1; var block :arblocks);
begin
            case c of
            'w','W': begin
                       if hero.magazine>0 then begin
                           if hero.pov<0 then shot(hero.x-rh+2,hero.y-10,-1,hero.damage,bul);
                           if hero.pov>0 then shot(hero.x+rh-2,hero.y-10,1,hero.damage,bul);
                           hero.magazine:=hero.magazine-1;
                       end;
                     end;
               #75 : begin
                      hero.dx:=-10; hero.pov:=-1;
                     end;
               #77 : begin
                      hero.dx:=10; hero.pov:=1;
                     end;
            'e','E': if (hero.dcount>0)  and (hero.disk=1) then
                       begin
                        hero.dcount:=hero.dcount-1; aim(hero);
                       end;
            'r','R': if (hero.lcount>0) then
                       begin
                        hero.lcount:=hero.lcount-1; laser_shot(hero, block);
                       end;
            end;
           if what_there(hero.x-rh,hero.y+rh1+1,hero.x+rh,hero.y+rh1+1) then
            case c of
             #32 : hero.dy:=-18;
             'A','a' : begin
                        hero.dx:=-13; hero.dy:=-18; hero.pov:=-1;
                       end;
             'D','d' : begin
                        hero.dx:=13; hero.dy:=-18; hero.pov:=1;
                       end;
            end;
end;

 procedure erase_hero(q,rh,rh1,xh,yh : integer);
var r : integer;     {q = 0 - hero will erased quickly}
begin
  if q<>0 then begin
   setcolor(ec);
   setLineStyle(1,1,3);
   for r:=1 to rh do circle(xh,yh,r);
   setLineStyle(1,1,1);
  end else begin
   setfillstyle(1,ec);
   bar(xh-rh,yh-rh1,xh+rh,yh+rh1);
  end;
end;
end.