Unit botes;

Interface
  Uses shooting,consts;
   {универсальный отступ по х,у до глаз бота}
   {type block =
     record
       btype          :integer;
       x,y,dx         :integer;
       p, n           :integer;
       xp, damag      :integer;
       tview, tout    :real;
       ptview, ptout  :real;
       view           :boolean;
       minx, maxx     :integer;
     end;
   {type bullet =
    record
      x,y,lr : integer;
     end;}
   {bot_file = file of block;}
   {type
     arblocks = array[1..100] of block;}

   function hit_hero(var xr, yr, x, y :integer) :boolean;
   function view_block(var blocks :arblocks; var i, xr, yr :integer) :boolean;
   procedure paint_block(var blocks :arblocks; var i :integer);
   procedure erase_block(var blocks :arblocks; var i :integer);
   function is_empty (xLeft,yDown,xRight,yUp : integer) :boolean;
   procedure move_block(var blocks :arblocks; var i :integer);
   procedure ded_block(var blocks :arblocks; var i, kb :integer);
   {procedure follow_block(var blocks :arblocks; var i, xr, yr :integer); }
   procedure control_block(var blocks :arblocks; var i, xr, yr, kb :integer; var bul :mas1);
   procedure all_blocks(var blocks :arblocks; var xr, yr, kb :integer; var bul :mas1);
   procedure create_botfile(var f :bot_file; var input :text);
   procedure botfile(var f :bot_file; var blocks :arblocks; var i, kb:integer);
   function hero_end(var xle,yue,xre,yde, xh, yh :integer):boolean;
   function can_exit(var blocks :arblocks; kb :integer) :boolean;


Implementation
   uses graph, crt, dos, drawbots, paint2, paint1;
   var
   picsr:mas1;
   gd,gm:integer;

   function hit_hero;
     begin
       if ((xr-RH) <= x)and((xr+RH) >= x)and((yr+RH1) >= y)and((yr-RH1) <= y) then
         hit_hero:=true
       else
         hit_hero:=false;
     end;

   function view_block;
      var
       vx, vy, dx :integer;
       view, stop :boolean;
      begin
       view:=false; stop:=false;
       vx:=blocks[i].x + (blocks[i].n*(H+3));
       vy:=blocks[i].y - H;
       dx:=blocks[i].n;
       repeat
         if (getpixel(vx,vy) <> ec) then
           if hit_hero(xr, yr, vx, vy) then
            view:=true
           else
            stop:=true;

         vx:=vx+dx;
       until(view or stop);


       blocks[i].view:=view;
       view_block:=view;
      end;

   procedure paint_block;
      begin
       if blocks[i].p = 2 then
         blocks[i].p:=1
       else
         blocks[i].p:=2;
       paintblock(blocks[i].x,blocks[i].y,blocks[i].n,blocks[i].p,blocks[i].btype,0);
      end;

   procedure erase_block;
      begin
       setfillstyle(1,ec);
       bar(blocks[i].x-RH, blocks[i].y-RH1, blocks[i].x+RH, blocks[i].y+RH1);
      end;

   function is_empty (xLeft,yDown,xRight,yUp : integer) : boolean;
     var x,y : integer;
           i : boolean;
     begin
      i:=true;
      for x:=xLeft to xRight do
       for y:=yUp to yDown do
           if getpixel(x,y)<>ec then
             i:=false;
      is_empty:=i;
     end;

   procedure ded_block;
     var
      j :integer;
      h, m, s, ds :word;

     begin
       {erase_block(blocks, i);   }

       setfillstyle(1,ec);
       if blocks[i].x <> 0 then
       begin
       if blocks[i].n<>3 then
        begin
          bar(blocks[i].x-RH, blocks[i].y-RH1, blocks[i].x+RH, blocks[i].y+RH1);
          if blocks[i].btype=1 then
            putimage(blocks[i].x-RH,blocks[i].y-RH1,picsr[9]^,copyput)
          else
            putimage(blocks[i].x-RH,blocks[i].y-RH1,picsr[9]^,copyput);

              {}
            blocks[i].btype:=0;  blocks[i].dx:=0;
            blocks[i].p:=0; blocks[i].n:=0; blocks[i].xp:=0; blocks[i].damag:=0;
            blocks[i].tview:=0; blocks[i].tout:=0; blocks[i].ptview:=0;
            blocks[i].ptout:=0; blocks[i].view:=false; blocks[i].minx:=0; blocks[i].maxx:=0;
            gettime(h,m,s,ds);
            blocks[i].ptout:=h*60+m+s/60+ds/6000+0.002;
            blocks[i].n:=3;
       end;
       { paint_block(blocks, i); }
       gettime(h,m,s,ds);
       if (h*60+m+s/60+ds/6000)>=blocks[i].ptout then begin
       bar(blocks[i].x-RH, blocks[i].y-RH1, blocks[i].x+RH, blocks[i].y+RH1);
       blocks[i].n:=0; blocks[i].x:=0; blocks[i].y:=0;  blocks[i].ptout:=0;
       for j:=i to kb do
        blocks[j]:=blocks[j+1];
       kb:=kb-1;
       end;
       end;
     end;

   procedure move_block;
     begin

      erase_block(blocks, i);
         {block reversed}

      if (is_empty(blocks[i].x+blocks[i].dx-RH,blocks[i].y+RH1,
                     blocks[i].x+blocks[i].dx+RH,blocks[i].y-RH1)) and
                     (not is_empty(blocks[i].x+blocks[i].dx-RH,blocks[i].y+RH1+5,
                     blocks[i].x+blocks[i].dx+RH,blocks[i].y+RH1)) then
       begin

         blocks[i].x:=blocks[i].x+blocks[i].dx;
       end;

      paint_block(blocks, i);
     end;

{   procedure follow_block;
      var
       h, m, s, hs :word;
       timer: real;
      begin
        gettime(h,m,s,hs);

        timer:=h*60+m+s/60+hs/6000;
        if((blocks[i].tview+blocks[i].ptview) <= (timer)) and (blocks[i].view) then
          begin
            if xr-blocks[i].x > 0 then
              blocks[i].dx:=STEP
            else
              blocks[i].dx:=-STEP;
            move_block(blocks, i);


            if view_block(blocks, i, xr, yr) then
              begin
               blocks[i].ptview:=timer;
               blocks[i].tview:=0.004;
              end
            else
              begin
               blocks[i].ptview:=0;
               blocks[i].tview:=0.5;
              end;
          end;
      end;
}
   procedure control_block;
      var
       h, m, s, hs :word;
       timer: real;
       strr:string;
      begin
        gettime(h,m,s,hs);

        timer:=h*60+m+s/60+hs/6000;

        if blocks[i].xp<=0 then
          begin
           ded_block(blocks, i, kb)
          end
        else
          begin
           {setfillstyle(1,ec);
           bar(0,0,640,100);
           setcolor(white);
           str(blocks[i].tview+blocks[i].ptview,strr);
           outtextxy(100,50,strr);
             }

           if((blocks[i].tview+blocks[i].ptview) <= (timer)) and (blocks[i].view) then
            begin
             if xr-blocks[i].x > 0 then
                blocks[i].dx:=STEP
             else
                blocks[i].dx:=-STEP;

             move_block(blocks, i);
              if blocks[i].dx<0 then shot(blocks[i].x-RH-2,blocks[i].y-10,-1,3,bul) else
              if blocks[i].dx>0 then shot(blocks[i].x+RH+2,blocks[i].y-10,1,3,bul);
             {shot()}
             if view_block(blocks, i, xr, yr) then
               begin
                blocks[i].ptview:=timer;
                blocks[i].tview:=0.002;
               end
             else
               begin
                blocks[i].ptview:=0;
                blocks[i].tview:=(random(3)+1)/100;
                blocks[i].tout:=0.3;
               end;
            end  {follow hero}

           else
            begin
             if not blocks[i].view then
               if view_block(blocks, i, xr, yr) then
                begin
                  blocks[i].ptview:=timer;
                end
               else
                if (blocks[i].tout+blocks[i].ptout) <= (timer) then
                 begin
                  blocks[i].ptout:=(timer);
                  if (random(1000)>200) then
                   begin
                    blocks[i].tout:=(random(3)+1)/100;                 {ходим туда сюда(багается,щались слева на прово)}
                    if (blocks[i].minx<blocks[i].x) and (blocks[i].maxx>blocks[i].x) then
                     begin
                      if not((blocks[i].minx<blocks[i].x+blocks[i].dx) and (blocks[i].maxx>blocks[i].x+blocks[i].dx))then
                       begin
                        blocks[i].dx:=-blocks[i].dx;
                        blocks[i].n:=-blocks[i].n;
                       end;
                      move_block(blocks, i);
                     end
                    else
                     begin
                      if(blocks[i].minx>=blocks[i].x) then
                       begin
                        blocks[i].dx:=STEP;
                        blocks[i].n:=1;      {возвращаемся}
                       end
                      else
                       begin
                        blocks[i].dx:=-STEP;
                        blocks[i].n:=-1;
                       end;
                      move_block(blocks, i);
                     end;
                   end
                  else
                   begin
                    blocks[i].dx:= -blocks[i].dx;
                    if blocks[i].dx>0 then
                      blocks[i].n:=1
                    else
                      blocks[i].n:=-1;
                    move_block(blocks, i);   {рандомный разворот}
                   end;
                 end;
            end;
          end;
      end;

   procedure all_blocks;
     var
      i :integer;
     begin
      for i:=1 to kb do
       begin
        control_block(blocks, i, xr, yr, kb, bul);
       end;
     end;


{----------------------------------------------------------}
   procedure create_botfile;
           var
             active   :block;
             i,logic  :integer;
           begin
             rewrite(f);
             reset(input);
             while(not eof(input)) do
             begin
               active.btype:=0;
               active.x:=0; active.y:=0; active.dx:=0;
               active.p:=0; active.n:=0; active.xp:=0; active.damag:=0;
               active.tview:=0; active.tout:=0; active.ptview:=0; active.ptout:=0;
               active.view:=false; active.minx:=0; active.maxx:=0;
               {-----}
               readln(input, active.btype);
               readln(input, active.x, active.y, active.dx);
               readln(input, active.p, active.n, active.xp, active.damag);
               readln(input, active.tview, active.tout, active.ptview, active.ptout);
               readln(input, logic, active.minx, active.maxx);
               {-----}
               if logic<>0 then
                 active.view:=true;
               {-----}
               write(f, active);
             end;
             close(f);
             close(input);
           end;
{----------------------------------------------------------}
   procedure botfile;
           var
             active   :block;
             logic  :integer;
           begin
             reset(f);
             i:=0;
             while(not eof(f)) do
               begin
                 i:=i+1;
                 read(f, active);
                 blocks[i]:=active;
               end;
             kb:=i;
             close(f);
           end;
   function hero_end;
     begin
       if(xh+RH>xle)and(xh+RH<xre)and(yh>yue)and(yh<yde) then
         hero_end:=true
       else
         hero_end:=false;
     end;
   function can_exit;
     var
       i:integer;
     begin
       i:=1;
       while(i<kb)and(blocks[i].btype<>2) do
        i:=i+1;
       if blocks[i].btype=2 then
         can_exit:=false
       else
         can_exit:=true;

     end;
   {begin
   painthero2(pics);
   painthero3(pics);   }
   begin
   initgraph(gm,gd,'c:\tp7\bgi');
painthero2(picsr);
painthero3(picsr);
closegraph;
end.