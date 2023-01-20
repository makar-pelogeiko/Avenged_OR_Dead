Unit menu_u;

Interface
    function menu(var lvl :integer):integer;
    procedure exitA;
    procedure info;
    procedure select_level(var lvl :integer);
    procedure menu_out(var sel :integer);
    procedure het;
    procedure mask(x,y:integer);
    procedure interface1(hp, ammo, disk, liser :integer);

Implementation
    uses graph, crt, consts;

    function menu;
        var
           c :char;
           sel :integer;
        begin
           sel:=1;
           clearviewport;
           setbkcolor(0);
           repeat
             menu_out(sel);
             c:=readkey;
             case c of
                #80: begin
                      if sel=IT then
                        sel:=1
                      else
                        sel:=sel+1;
                     end;
                #72: begin
                      if sel=1 then
                        sel:=IT
                      else
                        sel:=sel-1;
                     end;
                end;
           until(c=#13);
           menu:=sel;
        end;


    procedure menu_out;
        var
           i, y :integer;
           s :array [1..4] of string;
           x :array [1..4] of integer;
        begin
           s[1]:='Play';    s[2]:='Info';
           s[3]:='Select level';    s[4]:='Exit';

           x[1]:=200; x[2]:=200; x[3]:=117; x[4]:=200;

           y:=260;
           setfillstyle(1,0);
           bar(117,160,420,480);
           het;
           setcolor(4);
           settextstyle(7,0,5);
           for i:=1 to IT do
           begin
            if i=sel then
              begin
                setfillstyle(1,4);
                bar(117,y,400,y+45);
                setcolor(0);
                outtextxy(x[i],y,s[i]);
              end
            else
              begin
               setcolor(4);
               outtextxy(x[i],y,s[i]);
              end;
            y:=y+50;
           end;

        end;
    procedure exitA;
       begin
         clearviewport;
         setcolor(4);
         settextstyle(4,0,5);
         outtextxy(220,160,'see you later');
       end;
    procedure info;
       begin
         clearviewport;
         settextstyle(2,0,8);
         setcolor(4);
         outtextxy(20,160,'Help Edvard kill his main enemy - BLUDvard!!');
         outtextxy(80,240,'To control your hero use arrows');
         outtextxy(80,280,'and buttons: "W,A,S,D,SPACE"');
         outtextxy(80,320,'super addition: "R,E,Q,"');
         outtextxy(80,360,'control s.a: "A,D,W,"');
         readkey;
       end;

    procedure select_level;
       var
         i :integer;
         strr:string;
         c: char;
       begin
         clearviewport;
         setcolor(4);
         settextstyle(4,0,5);
         outtextxy(220,160,'your level: ');
         str(lvl,strr);
         outtextxy(430,160,strr);
         repeat
            c:=readkey;
             case c of
               #77 :begin
                      if lvl< MAXlvl then
                        begin
                         lvl:=lvl+1;
                         str(lvl,strr);
                         setfillstyle(1,0);
                         bar(425,150,490,200);
                         outtextxy(430,160,strr);
                        end;
                    end;
               #75 :begin
                      if lvl> 1 then
                        begin
                         lvl:=lvl-1;
                         str(lvl,strr);
                         setfillstyle(1,0);
                         bar(425,150,490,200);
                         outtextxy(430,160,strr);
                        end;
                    end;
             end;
         until(c=#13);
       end;
    procedure het;
      begin
        setcolor(2);
        settextstyle(10,0,6);
        outtextxy(50,10,'Avenged');
        setcolor(4);
        settextstyle(4,0,7);
        outtextxy(370,140,'DEAD');
        setcolor(2);
        settextstyle(5,0,5);
        outtextxy(350,90,'OR');
        mask(500, 70);
      end;

    procedure mask;
    begin
     setcolor(8);
     Setfillstyle(1,7);
     FillEllipse(x,y,20,30);
     setcolor(green);
     circle(x-8,y-7,5);
     setfillstyle(1,green);
     floodfill(x-8,y-7,green);
     setcolor(red);
     circle(x-8,y-7,5);
     setcolor(black);
     setlinestyle(0,1,2);
     line(x+3,y-7,x+12,y-13);
     line(x+3,y-7,x+12,y-1);
     line(x,y+8,x,y+19);
     line(x+5,y+8,x+5,y+19);
     line(x-5,y+8,x-5,y+19);
    end;

    procedure interface1;
    var
       i :integer;
       st:string;
    begin
        GetMem(interimg, ImageSize(0, 0, 639, 40));
        GetImage(0, 0, 639, 40, interimg^);

       setfillstyle(1,0); setcolor(7);  setlinestyle(3,0,1);
       bar(0,0,639,20);
       rectangle(0,0,639,20);
       {putimage(0,0,interimg^,normalput);}
       setcolor(4);
       settextstyle(2,0,6);
       outtextxy(3,1,'hp: ');
       setlinestyle(0,0,3); setcolor(2);
       for i:=1 to hp do
         line(24+(6*i),5,24+(6*i),15);
       setcolor(4);
       if i<MAXhp then
          for i:=i to MAXhp do
            line(24+(6*i),5,24+(6*i),15);
       settextstyle(2,0,6);
       str(ammo, st); st:='ammo: '+st;
       outtextxy(200,1,st);
       setcolor(7);
       setfillstyle(1,7);
       if disk>0 then
       begin
       for i:=1 to  disk do
         begin
           circle(300+(20*i),10,7);
           floodfill(300+20*i,10,7);       {диски}
         end;
       setcolor(4);  setlinestyle(0,0,1);
       for i:=1 to disk do
         line(295+20*i,10,305+20*i,10);
       end;

       setfillstyle(1,2);
       if liser>0 then
       for i:=1 to liser do                    {лазеры}
         bar(420+(i*20),3,434+(i*20),17);
       delay(3000);
       putimage(0,0,interimg^,normalput);
       freemem(interimg,ImageSize(0, 0, 639, 40));
    end;
end.