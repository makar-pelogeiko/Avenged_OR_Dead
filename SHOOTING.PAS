 Unit shooting;
 Interface
 Uses consts;
  function what_is_at_point (x,y : integer; block : arblocks; hero : blockh) : integer;
  function what_is_there (xLeft,yDown,xRight,yUp : integer; block : arblocks; hero : blockh) : integer;
  function in_block_type1(x,y,k : integer; block : arblocks) : boolean;
  procedure shot(x,y,lr,damage : integer; var bul : mas1);
  procedure zerobul(var bul :mas1);
  procedure move_bullets(var bul : mas1; var block : arblocks; var hero : blockh);
  procedure clear_block(var block :arblocks);
 Implementation
  Uses graph,crt;
 procedure shot(x,y,lr,damage : integer; var bul : mas1);
  var i,k : integer;
begin
 i:=1; k:=0;
      repeat
       if bul[i].lr=0 then begin
        bul[i].lr:=lr;
        bul[i].x:=x;
        bul[i].y:=y;
        bul[i].damage:=damage;
        k:=1;
       end;
       i:=i+1;
      until (k=1)or(i=N1);
end;

 procedure zerobul(var bul :mas1);
  var i :integer;
begin
   for i:=1 to N1 do begin
    setfillstyle(1,0);
    bar(bul[i].x-RBUL,bul[i].y-RBUL,bul[i].x+RBUL,bul[i].y+RBUL);
    bul[i].lr:=0;
    bul[i].x:=0;
    bul[i].y:=0;
    bul[i].damage:=0;
   end;
end;

 procedure move_bullets(var bul : mas1; var block : arblocks; var hero : blockh);
  var ie,xr,yr,dx,j,i : integer;
begin
    dx:=DX_BUL;
  for i:=1 to N1 do begin
     dx:=abs(dx);
    if bul[i].lr<>0 then begin
       dx:=dx*bul[i].lr;
       ie:=what_is_there(bul[i].x+dx-RBUL-1,bul[i].y+RBUL+1,bul[i].x+dx+RBUL+1,bul[i].y-RBUL-1,block,hero);
      if ie=0 then begin
       setfillstyle(1,0);
       bar(bul[i].x-RBUL,bul[i].y-RBUL,bul[i].x+RBUL,bul[i].y+RBUL);

       if (bul[i].damage>=1)and(bul[i].damage<5) then setfillstyle(1,green);
       if (bul[i].damage>=5)and(bul[i].damage<10) then setfillstyle(1,yellow);
       if (bul[i].damage>=10) then setfillstyle(1,red);

       bar(bul[i].x+dx-RBUL,bul[i].y-RBUL,bul[i].x+dx+RBUL,bul[i].y+RBUL);
       bul[i].x:=bul[i].x+dx;
      end;
      if ie=-1 then begin
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
      if ie=-2 then begin
       setfillstyle(1,0);
       bar(bul[i].x-RBUL,bul[i].y-RBUL,bul[i].x+RBUL,bul[i].y+RBUL);
       if hero.xp>0 then hero.xp:=hero.xp-bul[i].damage;
        for j:=i to N1 do
          if j<N1 then bul[j]:=bul[j+1] else
          if j=N1 then begin
           bul[j].lr:=0;
           bul[j].x:=0;
           bul[j].y:=0;
           bul[j].damage:=0;
          end;
      end;
      if ie>0 then begin
        if block[ie].xp<=0{bul[i].damage} then begin
        { setfillstyle(1,0);
         bar(block[ie].x-RH,block[ie].y-RH1,block[ie].x+RH,block[ie].y+RH1);
         for j:=ie to N do
           if j<N then block[j]:=block[j+1] else
           if j=N then begin
            block[j].x:=0; block[j].y:=0; block[j].dx:=0; block[j].p:=0; block[j].n:=0;
            block[j].xp:=0; block[j].damag:=0; block[j].tview:=0; block[j].tout:=0; block[j].ptview:=0;
            block[j].ptout:=0; block[j].view:=False; block[j].minx:=0; block[j].maxx:=0;
           end;}
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
        if block[ie].xp>0{bul[i].damage} then begin
           block[ie].xp:=block[ie].xp-bul[i].damage;
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
      end;
    end;
  end;
end;

function what_is_at_point(x,y : integer; block : arblocks; hero : blockh) : integer;
  var i,nobj : integer;
begin
   i:=1;  nobj:=0;
   repeat
      if in_block_type1(x,y,i,block) then nobj:=i;
      i:=i+1;
   until (i > N) or (nobj<>0);
   if (hero.x-RH <=x) and (hero.y-RH1<=y)
      and (hero.x+RH >=x) and (hero.y+RH1>=y) then nobj:=-2;
   what_is_at_point:=nobj;
end;

 function what_is_there (xLeft,yDown,xRight,yUp : integer; block : arblocks; hero : blockh) : integer;
  var x,y, nobj, i, s: integer;
begin
   nobj:=0;  x:=xLeft; y:=yUp; s:=0;
   repeat
     if getpixel(x,y)<>0 then begin nobj:=what_is_at_point(x,y,block,hero);
        s:=1;
     end;
     x:=x+1;
     if x>xRight then begin x:=xLeft; y:=y+1; end;
   until (y > yDown) or (nobj <> 0);
    if (nobj=0) and (s=1) then nobj:=-1;
    what_is_there:=nobj;
end;

 procedure clear_block;
   var i,j :integer;
  begin
   for i:=1 to N do begin
     if block[i].xp<0 then begin
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
   end;
  end;

 function in_block_type1(x,y,k : integer; block : arblocks) : boolean;
begin
   in_block_type1:=(block[k].x-RH <=x) and (block[k].y-RH1<=y)
      and (block[k].x+RH >=x) and (block[k].y+RH1>=y);
end;
end.