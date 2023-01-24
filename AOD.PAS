uses dos, graph, crt {||},megashot , paint2,drawbots,paint1,drawhero {||}, engine, shooting {||}, botes,
     GRCOMAND, menu_u {||}, consts;
var
  gd, gm, lvl, sel, xle,yue,xre,yde   :integer;
  sbot, smap, slvl :string;

var i,j,h : integer;
    c :char;
    blocks :arblocks;
    kb:integer;
    f :map_file;
    g :bot_file;
    hero :blockh;
    time : integer;
    bul :mas1;
    t1,t2,tsn,tsl,t100sl,t100sn :word;
    glbtsl, glbtsn :real;


begin
   randomize;
   hero.pov:=1;
   hero.disk:=1;
   hero.xp:=MAXhp;
   hero.angledis:=0;
   hero.damage:=5;
   hero.magazine:=MAXpistol;
   hero.dcount:=MAXd;
   hero.lcount:=MAXl;
   hero.x:=45;
   hero.y:=35;
   kb:=1; i:=1;
   lvl:=1;
   glbtsl:=0;

   sbot:='bot'; smap:='map';
   gd:=VGA;
   gm:=VGAHi;
   initgraph(gd,gm, GrP);
   gd:=graphresult;
   if gd <> grOK then
   begin
      writeln('Error graphics');
      writeln(grapherrormsg(gd));
      halt;
   end;

   painthero(100,100,1,1,1);
   paintblock(100,100,1,1,1,1);
   repeat
    sel:=menu(lvl);
    case sel of
      2 :info;
      3 :select_level(lvl);
      4 :exitA;
    end;
    if sel=1 then
      begin
        clearviewport;
        str(lvl,slvl);
        assign(f,smap+slvl+'.'+smap);
        assign(g,sbot+slvl+'.'+sbot);
        botfile(g, blocks, i, kb);
        paint_background(f, xle,yue,xre,yde); setlinestyle(0,1,1);
        painthero(hero.x,hero.y,1,2,0);
        paint_block(blocks, i);
        c:='r'; time:=0;
{game}  repeat

          if keypressed then
            begin
              c:=readkey;
              if c='q' then interface1(hero.xp,hero.magazine,hero.dcount,hero.lcount);
             { if c='g' then liser_start(hero.pov,hero.x,hero.y, blocks);}
{--------------------------------- new part ---------------------------------------------}
              gettime(t1,t2,tsn,t100sn);
              glbtsn:=t1*60+t2+tsn/60+t100sn/6000;
              if (c='w')or(c='W') then
              begin   {time of shot}
                  if abs(glbtsn-glbtsl)>=0.003{time 1/100 sec} then glbtsl:=glbtsn
                  else c:='+';
              end
              else
                 if (c=#75)or(c=#77) then
                 begin   {time of step}
                   if abs(glbtsn-glbtsl)>=0.002{time 1/100 sec} then glbtsl:=glbtsn
                     else c:='+';
                 end;
              if c<>'+' then control_hero(c,hero,bul,blocks);
              setwritemode(CopyPut);
{--------------------------------- new part ---------------------------------------------}
            end;
          moving(hero);
          move_bullets(bul,blocks,hero);
          all_blocks(blocks,hero.x,hero.y, kb, bul);
          if hero.disk=0 then fly(blocks,bul,hero);
          {delay(50);}
{game}   until (c=#27)or(can_exit(blocks, kb) and hero_end(xle,yue,xre,yde,hero.x,hero.y)) or(hero.xp<=0);

           hero.x:=45;
           hero.y:=35;
           hero.pov:=1;
           hero.disk:=1;
           zerobul(bul);
        clearviewport;
        if (c<>#27) and (hero.xp>0) then
          begin
            setcolor(2);
            settextstyle(10,0,5);
            outtextxy(200, 160,'Avenged');
            if lvl<MAXlvl then lvl:=lvl+1;
            delay(5000);
          end;
        if hero.xp<=0 then
          begin
            setcolor(4);
            settextstyle(4,0,5);
            outtextxy(200, 160,'DEAD');
            lvl:=1;
            hero.xp:=MAXhp;
            hero.magazine:=MAXpistol;
            hero.dcount:=MAXd;
            hero.lcount:=MAXl;
            delay(5000);
          end;
      end;
   until(sel=4);
   readkey;
   closegraph;
   writeln(h);
end.