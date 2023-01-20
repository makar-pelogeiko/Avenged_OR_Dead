 Unit megashot;
Interface
 Uses consts,graph,crt;
  type maskord = array [1..3,1..N1] of integer;
  procedure aim(var hero :blockh);
  procedure fly(var block :arblocks; var bul :mas1; var hero :blockh);
  procedure delblock(var block :arblocks; i :integer);
  procedure cursor(hero :blockh);
  procedure del_bul(i :integer; var bul :mas1);
  procedure paint_disk(x,y :integer);
  procedure erase_disk(x,y :integer);
  procedure laser_shot(var hero :blockh; var block :arblocks);
  procedure cursor1(hero :blockh; a :maskord);
  procedure trajectory(var a :maskord; hero :blockh; var block :arblocks; s :integer);
  function in_hero(x,y :integer; hero :blockh) :boolean;
  function in_block(x,y : integer; block : arblocks) :integer;
  function in_bul(x,y :integer; bul :mas1) :integer;
  function what_in_there(xl,yd,xr,yu :integer; block :arblocks; var bul :mas1) :integer;

Implementation
   Uses paint1,drawhero,engine,dos;
  procedure delblock;
    var j :integer;
   begin
    setfillstyle(1,0);
    bar(block[i].x-RH,block[i].y-RH1,block[i].x+RH,block[i].y+RH1);
      for j:=i to N do
        if j<N then block[j]:=block[j+1] else
        if j=N then begin
         block[j].x:=0; block[j].y:=0; block[j].dx:=0; block[j].p:=0; block[j].n:=0;
         block[j].xp:=0; block[j].damag:=0; block[j].tview:=0; block[j].tout:=0; block[j].ptview:=0;
         block[j].ptout:=0; block[j].view:=False; block[j].minx:=0; block[j].maxx:=0;
        end;
   end;

  function in_hero;
   begin
    if (hero.x-RH <=x) and (hero.y-RH1<=y)
      and (hero.x+RH >=x) and (hero.y+RH1>=y) then in_hero:=True
    else in_hero:=False;
   end;

  procedure aim;
    var     c :char;
         sign :boolean;
        xh,yh :integer;
   begin
     cursor(hero);
     sign:=False;
     xh:=hero.x;
     yh:=hero.y;
    repeat
     if hero.angledis>2*Pi then hero.angledis:=hero.angledis-2*Pi;
     if hero.angledis<-2*Pi then hero.angledis:=hero.angledis+2*Pi;
     if keypressed then begin
      c:=readkey;
       case c of
        'a','A': begin
                  cursor(hero);
                  hero.angledis:=hero.angledis+0.03;
                  cursor(hero);
                 end;
        'd','D': begin
                  cursor(hero);
                  hero.angledis:=hero.angledis-0.03;
                  cursor(hero);
                 end;
        'w','W': begin
                  if (abs(hero.angledis)>=Pi/10*2)and(abs(hero.angledis)<=Pi/10*8)or(abs(hero.angledis)>=Pi/10*12)
                  and(abs(hero.angledis)<=Pi/10*18)
                  then sign:=False else sign:=True;
                  if (hero.disk=1)and(sign=True) then begin
                  hero.disk:=0;
                  hero.xdis:=xh+round(20*cos(hero.angledis));
                  hero.ydis:=yh-round(20*sin(hero.angledis));
                  end;
                 end;
       end;
     end;
      if (abs(hero.angledis)>Pi/2)and(abs(hero.angledis)<Pi/2*3)and(hero.pov>0) then begin
        hero.pov:=-1;
        erase_hero(0,rh,rh1,hero.x,hero.y);
        painthero(hero.x,hero.y,hero.pov,1,0);
      end else
      if not((abs(hero.angledis)>Pi/2)and(abs(hero.angledis)<Pi/2*3))and(hero.pov<0) then begin
        hero.pov:=1;
        erase_hero(0,rh,rh1,hero.x,hero.y);
        painthero(hero.x,hero.y,hero.pov,1,0);
      end;
    until (c='s')or(c='S')or(sign=True);
     cursor(hero);
   end;

  procedure cursor;
    var     d :real;
         sign :boolean;
        xh,yh :integer;
   begin
      d:=0.12;
      xh:=hero.x;
      yh:=hero.y;
      if (abs(hero.angledis)>=Pi/10*2)and(abs(hero.angledis)<=Pi/10*8)
      or(abs(hero.angledis)>=Pi/10*12)and(abs(hero.angledis)<=Pi/10*18)
      then sign:=False else sign:=True;
     setwritemode(XorPut);
       if not sign then setcolor(red) else
        setcolor(blue);
      Line(xh+round(46*cos(hero.angledis)),yh-round(46*sin(hero.angledis)),
      xh+round(37*cos(hero.angledis-d)),yh-round(37*sin(hero.angledis-d)));
      Line(xh+round(46*cos(hero.angledis)),yh-round(46*sin(hero.angledis)),
      xh+round(37*cos(hero.angledis+d)),yh-round(37*sin(hero.angledis+d)));
       if not sign then setcolor(red) else
        setcolor(lightblue);
      Line(xh+round(56*cos(hero.angledis)),yh-round(56*sin(hero.angledis)),
      xh+round(47*cos(hero.angledis-d)),yh-round(47*sin(hero.angledis-d)));
      Line(xh+round(56*cos(hero.angledis)),yh-round(56*sin(hero.angledis)),
      xh+round(47*cos(hero.angledis+d)),yh-round(47*sin(hero.angledis+d)));
       if not sign then setcolor(red) else
        setcolor(white);
      Line(xh+round(66*cos(hero.angledis)),yh-round(66*sin(hero.angledis)),
      xh+round(57*cos(hero.angledis-d)),yh-round(57*sin(hero.angledis-d)));
      Line(xh+round(66*cos(hero.angledis)),yh-round(66*sin(hero.angledis)),
      xh+round(57*cos(hero.angledis+d)),yh-round(57*sin(hero.angledis+d)));
   end;

  procedure fly;
    var   a :array [0..2*R_D,0..2*R_D] of integer;
         ie,i,j,xl,yl :integer;
   begin
     if (hero.xdis-hero.x)/cos(hero.angledis)>23 then erase_disk(hero.xdis,hero.ydis);
     hero.xdis:=hero.xdis+round(DS_DISK*cos(hero.angledis));
     hero.ydis:=hero.ydis-round(DS_DISK*sin(hero.angledis));
     ie:=what_in_there(hero.xdis-R_D,hero.ydis+R_D,hero.xdis+R_D,hero.ydis-R_D,block,bul);
     for i:=0 to 2*R_D do
      for j:=0 to 2*R_D do a[i,j]:=0;
     if ie>0 then begin
       block[ie].xp:=block[ie].xp-hero.damage*3;
       hero.disk:=1;
     end;
     if (ie=0)and(hero.xdis<640)and(hero.xdis>0)and(hero.ydis<480)and(hero.ydis>0) then paint_disk(hero.xdis,hero.ydis)
      else hero.disk:=1;
     if ie<0 then begin
      hero.disk:=1;
      for i:=0 to 2*R_D do
       for j:=0 to 2*R_D do a[i,j]:=getpixel(hero.xdis+i-R_D,hero.ydis+j-R_D);
        paint_disk(hero.xdis,hero.ydis);
      for i:=0 to 2*R_D do
       for j:=0 to 2*R_D do begin
        if a[i,j]>0 then putpixel(hero.xdis-R_D+i,hero.ydis-R_D+j,a[i,j]);
       end;
     end;
   end;

  procedure erase_disk;
   begin
    setcolor(0);
    circle(x,y,R_D);
    setfillstyle(1,0);
    floodfill(x,y,0);
   end;

  procedure paint_disk;
   begin
    setcolor(yellow);
    circle(x,y,R_D);
    setfillstyle(1,yellow);
    floodfill(x,y,yellow);
    delay(100);
   end;

  function what_in_there(xl,yd,xr,yu :integer; block :arblocks; var bul :mas1) :integer;
    var i,j,k :integer;
        ns :integer;
   begin
      k:=0; ns:=0;
     for i:=xl to xr do
      for j:=yu to yd do
      begin
       if in_bul(i,j,bul)>0 then del_bul(in_bul(i,j,bul),bul)
       else
       if in_block(i,j,block)>0 then ns:=in_block(i,j,block)
       else
       if getpixel(i,j)<>0 then if ns=0 then ns:=-1;
      end;
      what_in_there:=ns;
   end;

 procedure del_bul(i :integer; var bul :mas1);
   var j :integer;
  begin
    setfillstyle(1,0);
    bar(bul[i].x-RBUL,bul[i].y-RBUL,bul[i].x+RBUL,bul[i].y+RBUL);
    for j:=i to N1 do
     if j<N1 then bul[j]:=bul[j+1] else
     if j=N1 then begin
       bul[j].lr:=0;
       bul[j].x:=0;
       bul[j].y:=0;
       bul[j].damage:=0;
     end;
  end;

 function in_bul(x,y :integer; bul :mas1) :integer;
    var k :integer;
   begin
    k:=0; in_bul:=0;
    repeat
     k:=k+1;
     if (bul[k].x-RBUL <=x) and (bul[k].y-RBUL<=y)
      and (bul[k].x+RBUL >=x) and (bul[k].y+RBUL>=y) then in_bul:=k;
    until k=N1;
   end;

 function in_block(x,y : integer; block : arblocks) :integer;
    var k :integer;
   begin
    k:=0; in_block:=0;
    repeat
     k:=k+1;
     if (block[k].x-RH <=x) and (block[k].y-RH1<=y)
      and (block[k].x+RH >=x) and (block[k].y+RH1>=y) and (block[k].xp<>0) then in_block:=k;
    until k=N;
   end;

 procedure cursor1;
   var d :real;
       xh,yh,i,j :integer;
       angle :real;
  begin
      d:=0.08;
      if hero.pov=-1 then begin
       xh:=hero.x+15;
       yh:=hero.y-27;
      end else begin
       xh:=hero.x-15;
       yh:=hero.y-27;
      end;
      angle:=hero.anglelas;
     setwritemode(XorPut);
        setcolor(red);
      Line(xh+round(26*cos(angle)),yh-round(26*sin(angle)),xh+round(17*cos(angle-d)),yh-round(17*sin(angle-d)));
      Line(xh+round(26*cos(angle)),yh-round(26*sin(angle)),xh+round(17*cos(angle+d)),yh-round(17*sin(angle+d)));
        setcolor(yellow);
      Line(xh+round(36*cos(angle)),yh-round(36*sin(angle)),xh+round(27*cos(angle-d)),yh-round(27*sin(angle-d)));
      Line(xh+round(36*cos(angle)),yh-round(36*sin(angle)),xh+round(27*cos(angle+d)),yh-round(27*sin(angle+d)));
        setcolor(white);
      Line(xh+round(46*cos(angle)),yh-round(46*sin(angle)),xh+round(37*cos(angle-d)),yh-round(37*sin(angle-d)));
      Line(xh+round(46*cos(angle)),yh-round(46*sin(angle)),xh+round(37*cos(angle+d)),yh-round(37*sin(angle+d)));
       setlinestyle(1,0,1);
       setcolor(2);
       i:=0;
       repeat
        i:=i+1;
        if (a[3,i]=1)and(a[3,i+1]=1) then
          line(a[1,i],a[2,i],a[1,i+1],a[2,i+1]);
       until (a[3,i]=0)or(i=N1);
       setlinestyle(0,0,1);
  end;

 procedure laser_shot;
   var sign :boolean;
       xh,yh,i,j :integer;
       c :char;
       a :maskord;
       t1,t2,t3,t4,tl :word;
       x1,y1,x2,y2 :integer;
  begin
     sign:=False; tl:=0;
     xh:=hero.x;
     yh:=hero.y;
     if hero.pov=1 then hero.anglelas:=Pi/4;
     if hero.pov=-1 then hero.anglelas:=3*Pi/4;
     for i:=1 to 3 do
       for j:=1 to N1 do a[i,j]:=0;
     trajectory(a,hero,block,0);
     cursor1(hero,a);
    repeat
     if keypressed then begin
       c:=readkey;
         {gettime(t1,t2,t3,t4);
        if (abs(t4-tl)<15)and((c='a')or(c='d')) then c:='+'
        else tl:=t4;}
       case c of
        'a','A': begin
                  if (hero.pov=1)and(hero.anglelas<Pi/2) then begin
                   cursor1(hero,a);
                   hero.anglelas:=hero.anglelas+0.04;
                   trajectory(a,hero,block,0);
                   cursor1(hero,a);
                  end;
                  if (hero.pov=-1)and(hero.anglelas<3*Pi/2) then begin
                   cursor1(hero,a);
                   hero.anglelas:=hero.anglelas+0.04;
                   trajectory(a,hero,block,0);
                   cursor1(hero,a);
                  end;
                 end;
        'd','D': begin
                  if (hero.pov=1)and(hero.anglelas>-Pi/2) then begin
                   cursor1(hero,a);
                   hero.anglelas:=hero.anglelas-0.04;
                   trajectory(a,hero,block,0);
                   cursor1(hero,a);
                  end;
                  if (hero.pov=-1)and(hero.anglelas>Pi/2) then begin
                   cursor1(hero,a);
                   hero.anglelas:=hero.anglelas-0.04;
                   trajectory(a,hero,block,0);
                   cursor1(hero,a);
                  end;
                 end;
        'w','W': begin
                  if hero.laser=1 then hero.laser:=0;
                     sign:=True;
                 end;
       end;
     end;
    until (c='s')or(c='S')or(sign=True);
     cursor1(hero,a);
     setwritemode(XorPut);
     setcolor(2);
    if sign=True then begin
      trajectory(a,hero,block,1);
     for j:=1 to 2 do begin
        i:=0;
       repeat
        i:=i+1;
        if (a[3,i]=1)and(a[3,i+1]=1) then begin
          if i=1 then begin
            if hero.pov=-1 then begin
               x1:=hero.x+15;
               y1:=hero.y-26;
              end else begin
               x1:=hero.x-15;
               y1:=hero.y-26;
              end
            end
            else begin
             x1:=a[1,i]; y1:=a[2,i]
            end;
            line(x1,y1,a[1,i+1],a[2,i+1]);
            delay(90);
            delay(90);
       end;
       until (a[3,i]=0)or(i=N1);
        delay(90);
        delay(90);
      end;
     end;
  end;

 procedure trajectory;
   var i,j :integer;
       x,y,xh,yh,x1,y1 :integer;
       nu,nd,nl,nr,numbl :integer;
       angle,ds :real;
       pr,pl,pd,pu :integer;
  begin
       ds:=50; j:=1; numbl:=0;
       nl:=1; nr:=1; nd:=1; nu:=1;
       angle:=hero.anglelas;
      if hero.pov=-1 then begin
       xh:=hero.x+15;
       yh:=hero.y-27;
      end else begin
       xh:=hero.x-15;
       yh:=hero.y-27;
      end;
       x:=xh+round(cos(angle)*ds);
       y:=yh-round(sin(angle)*ds);
       a[1,1]:=x;
       a[2,1]:=y;
       a[3,1]:=1;
       pd:=0; pl:=0; pu:=0; pr:=0;
    repeat
     x:=xh+round(cos(angle)*ds);
     y:=yh-round(sin(angle)*ds);
     ds:=ds+1;
      pu:=getpixel(x,y-1);
      pd:=getpixel(x,y+1);
      pl:=getpixel(x-1,y);
      pr:=getpixel(x+1,y);
      if (nu=1)and(pu>0)and(in_block(x,y-1,block)=0)and not(in_hero(x,y-1,hero)) then begin
       j:=j+1;
       angle:=-angle;
       a[1,j]:=x;
       a[2,j]:=y;
       a[3,j]:=1;
       ds:=0;
       xh:=x;
       yh:=y;
       nu:=0;
       nd:=1;
       numbl:=0;
      end else
      if (nd=1)and(pd>0)and(in_block(x,y+1,block)=0)and not(in_hero(x,y+1,hero)) then begin
       j:=j+1;
       angle:=-angle;
       a[1,j]:=x;
       a[2,j]:=y;
       a[3,j]:=1;
       ds:=0;
       xh:=x;
       yh:=y;
       nd:=0;
       nu:=1;
       numbl:=0;
      end else
      if (nl=1)and(pl>0)and(in_block(x-1,y,block)=0)and not(in_hero(x-1,y,hero)) then begin
       j:=j+1;
       angle:=Pi-angle;
       a[1,j]:=x;
       a[2,j]:=y;
       a[3,j]:=1;
       ds:=0;
       xh:=x;
       yh:=y;
       nl:=0;
       nr:=1;
       numbl:=0;
      end else
      if (nr=1)and(pr>0)and(in_block(x+1,y,block)=0)and not(in_hero(x+1,y,hero)) then begin
       j:=j+1;
       angle:=Pi-angle;
       a[1,j]:=x;
       a[2,j]:=y;
       a[3,j]:=1;
       ds:=0;
       xh:=x;
       yh:=y;
       nr:=0;
       nl:=1;
       numbl:=0;
      end else
      if (x>=640)or(x<=0)or(y<=0)or(y>=480) then begin
         j:=j+1;
         a[1,j]:=x;
         a[2,j]:=y;
         a[3,j]:=1;
      end;
      pu:=0; pd:=0; pr:=0; pl:=0;
       if (s=1)and(in_block(x,y,block)>0)and(in_block(x,y,block)<>numbl) then begin
        block[in_block(x,y,block)].xp:=block[in_block(x,y,block)].xp-hero.damage*2;
        numbl:=in_block(x,y,block);
       end;
    until (j=8)or(x>=640)or(x<=0)or(y<=0)or(y>=480);
  end;
end.