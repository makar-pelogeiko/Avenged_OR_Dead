Unit  grcomand;

Interface
         type
            graph_comand =
               record
                  comand                  :char;
                  parametr                :array[1..4] of integer;
                  point                   :array[1..2] of integer;
                  color, fill             :integer;
                  line_style, fill_style  :integer;
                  fill_color, line_width  :integer;

               end;
            map_file =
               file of graph_comand;

         procedure paint_background(var map_file :map_file; var xl,yu, xr,yd :integer);
         procedure create_map(var map_file :map_file);
         procedure create_map_from_file(var map_file :map_file; var input :text);

{-------------------------------------------------------------------------}

{-------------------------------------------------------------------------}
Implementation

         uses graph;


         procedure create_map_from_file;
           var
             active :graph_comand;
             ch     :char;
             i      :integer;
           begin
             rewrite(map_file);
             reset(input);
             while(not eof(input)) do begin
               write('comand: ');
               readln(input, ch);
               {-----}
               active.fill_color:=0; active.line_width:=0;
               active.line_style:=0; active.fill_style:=0;
               active.color:=0;      active.fill:=0;
               for i:=1 to 4 do
                   active.parametr[i]:=0;
               for i:=1 to 2 do
                   active.point[i]:=0;
               {-----}

                   active.comand:=ch;
                   case active.comand of

                       'C':
                           begin
                             writeln('circle');
                             readln(input,  active.parametr[1], active.parametr[2], active.parametr[3]);
                             write('(x,y)center: ', active.parametr[1],' ');
                             writeln(active.parametr[2],' radius: ', active.parametr[3]);
                             readln(input, active.color, active.line_width, active.fill);
                             write('color(0..15): ', active.color,' Line width(1/3): ');
                             writeln(active.line_width, ' fill(1/0): ', active.fill);
                             if active.fill=1 then
                                begin
                                  active.point[1]:=active.parametr[1];
                                  active.point[2]:=active.parametr[2];
                                  readln(input, active.fill_style, active.fill_color);
                                  write('Fill Style(0..11): ', active.fill_style);
                                  writeln(' Filling color(0..15): ', active.fill_color);
                                end;
                             write(map_file, active);
                             writeln('-------------------------------------------------------');
                           end;

                       'B':
                           begin
                             writeln('bar');
                             readln(input, active.parametr[1], active.parametr[2], active.parametr[3], active.parametr[4]);
                             write('(x,y)left top corner: ',  active.parametr[1],' ', active.parametr[2]);
                             writeln(' (x,y)right bottom corner: ', active.parametr[3],' ', active.parametr[4]);
                             readln(input, active.fill_style, active.fill_color);
                             writeln('Fill Style(0..11): ', active.fill_style,' Filling color(0..15): ', active.fill_color);
                             write(map_file, active);
                             writeln('-------------------------------------------------------');
                           end;

                        'R':
                           begin
                             writeln('rectangle');
                             readln(input, active.parametr[1], active.parametr[2], active.parametr[3], active.parametr[4]);
                             write('(x,y)left top corner: ', active.parametr[1],' ', active.parametr[2]);
                             writeln(' (x,y)right bottom corner: ',active.parametr[3],' ', active.parametr[4]);
                             readln(input, active.color, active.line_style, active.line_width);
                             write('color(0..15): ',active.color,' Line Style(0..3): ',active.line_style);
                             writeln(' Line width(1/3): ', active.line_width);
                             active.fill:=0;
                             write(map_file, active);
                             writeln('-------------------------------------------------------');
                           end;

                        'L':
                           begin
                             writeln('line');
                             readln(input, active.parametr[1], active.parametr[2], active.parametr[3], active.parametr[4]);
                             write('(x,y)first point: ', active.parametr[1],' ', active.parametr[2]);
                             writeln(' (x,y)second point: ',active.parametr[3], ' ',active.parametr[4]);
                             readln(input, active.color, active.line_style, active.line_width);
                             write('color(0..15): ',active.color,' Line Style(0..3): ', active.line_style);
                             writeln( ' Line width(1/3): ', active.line_width);
                             active.fill:=0;
                             write(map_file, active);
                             writeln('-------------------------------------------------------');
                           end;

                        'P':
                           begin
                             writeln('fill point');
                             readln(input, active.point[1], active.point[2]);
                             writeln('point(x,y): ', active.point[1],' ', active.point[2]);
                             readln(input, active.fill_color, active.color, active.fill_style);
                             write('Filling color(0..15): ', active.fill_color, ' color(border)(0..15): ');
                             writeln(active.color, ' Fill Style(0..11): ', active.fill_style);
                             write(map_file, active);
                             writeln('-------------------------------------------------------');
                           end;
                        'E':
                           begin
                             writeln('rectangle');
                             readln(input, active.parametr[1], active.parametr[2], active.parametr[3], active.parametr[4]);
                             write('(x,y)left top corner: ', active.parametr[1],' ', active.parametr[2]);
                             writeln(' (x,y)right bottom corner: ',active.parametr[3],' ', active.parametr[4]);

                             active.fill:=0;
                             write(map_file, active);
                             writeln('-------------------------------------------------------');
                           end;

                      else
                           writeln('empty comand, try again(C, B, R, L, P)');
                    end;

             end;
             close(map_file);
           end;


{-------------------------------------------------------------}
         procedure create_map;
           var
             active :graph_comand;
             ch     :char;
             i      :integer;
           begin
             rewrite(map_file);
             repeat
               write('comand: ');
               readln(ch);
               {-----}
               active.fill_color:=0; active.line_width:=0;
               active.line_style:=0; active.fill_style:=0;
               active.color:=0;      active.fill:=0;
               for i:=1 to 4 do
                   active.parametr[i]:=0;
               for i:=1 to 2 do
                   active.point[i]:=0;
               {-----}
               if ch<>'0' then
                 begin
                   active.comand:=ch;
                   case active.comand of

                       'C':
                           begin
                             writeln('circle');
                             write('enter (x,y)center: '); readln(active.parametr[1], active.parametr[2]);
                             write('radius: '); readln(active.parametr[3]);
                             write('color(0..15): '); readln(active.color);
                             {write('Line Style(0..3): '); readln(active.line_style); }
                             write('Line width(1/3): '); readln(active.line_width);
                             write('fill(1/0): '); readln(active.fill);
                             if active.fill=1 then
                                begin
                                  active.point[1]:=active.parametr[1];
                                  active.point[2]:=active.parametr[2];
                                  write('Fill Style(0..11): '); readln(active.fill_style);
                                  write('Filling color(0..15): '); readln(active.fill_color);
                                end;
                             write(map_file, active);
                           end;

                       'B':
                           begin
                             writeln('bar');
                             write('enter (x,y)left top corner: '); readln(active.parametr[1], active.parametr[2]);
                             write('enter (x,y)right bottom corner: '); readln(active.parametr[3], active.parametr[4]);
                             {write('color(0..15): '); readln(active.color);}
                             {write('Line Style(0..3): '); readln(active.line_style); }
                             {write('Line width(1/3): '); readln(active.line_width); }
                             write('Fill Style(0..11): '); readln(active.fill_style);
                             write('Filling color(0..15): '); readln(active.fill_color);
                             write(map_file, active);
                           end;

                        'R':
                           begin
                             writeln('rectangle');
                             write('enter (x,y)left top corner: '); readln(active.parametr[1], active.parametr[2]);
                             write('enter (x,y)right bottom corner: '); readln(active.parametr[3], active.parametr[4]);
                             write('color(0..15): '); readln(active.color);
                             write('Line Style(0..3): '); readln(active.line_style);
                             write('Line width(1/3): '); readln(active.line_width);
                             active.fill:=0;
                             write(map_file, active);
                           end;

                        'L':
                           begin
                             writeln('line');
                             write('enter (x,y)first point: '); readln(active.parametr[1], active.parametr[2]);
                             write('enter (x,y)second point: '); readln(active.parametr[3], active.parametr[4]);
                             write('color(0..15): '); readln(active.color);
                             write('Line Style(0..3): '); readln(active.line_style);
                             write('Line width(1/3): '); readln(active.line_width);
                             active.fill:=0;
                             write(map_file, active);
                           end;

                        'P':
                           begin
                             writeln('fill point');
                             write('enter point(x,y): '); readln(active.point[1], active.point[2]);
                             write('Filling color(0..15): '); readln(active.fill_color);
                             write('color(border)(0..15): '); readln(active.color);
                             write('Fill Style(0..11): '); readln(active.fill_style);
                             write(map_file, active);
                           end;

                      else
                           writeln('empty comand, try again(C, B, R, L, P)');
                    end;
                 end;
             until(ch='0');
             close(map_file);
           end;
{---------------------------------------------------------------------}
         procedure paint_background;
           var
             active :graph_comand;
           begin
             reset(map_file);
             while not(eof(map_file)) do
                begin
                    read(map_file, active);
                    case active.comand of

                       'C':
                           begin
                             setcolor(active.color);
                             setlinestyle(active.line_style,0,active.line_width);
                             circle(active.parametr[1], active.parametr[2], active.parametr[3]);
                             if active.fill=1 then
                                begin
                                 setfillstyle(active.fill_style, active.fill_color);
                                 floodfill(active.point[1], active.point[2], active.color);
                                end;
                           end;

                       'B':
                           begin
                             setcolor(active.color);
                             setlinestyle(active.line_style,0,active.line_width);
                             setfillstyle(active.fill_style, active.fill_color);
                             bar(active.parametr[1],active.parametr[2],  active.parametr[3],active.parametr[4]);
                           end;

                       'R':
                           begin
                             setcolor(active.color);
                             setlinestyle(active.line_style,0,active.line_width);
                             setfillstyle(active.fill_style, active.fill_color);
                             rectangle(active.parametr[1],active.parametr[2],  active.parametr[3],active.parametr[4]);
                           end;

                       'L':
                           begin
                             setcolor(active.color);
                             setlinestyle(active.line_style, 0, active.line_width);
                             line(active.parametr[1],active.parametr[2],  active.parametr[3],active.parametr[4]);
                           end;

                       'P':
                           begin
                             setfillstyle(active.fill_style, active.fill_color);
                             floodfill(active.point[1], active.point[2], active.color);
                           end;
                       'E':
                           begin
                             xl:=active.parametr[1]; yu:=active.parametr[2];
                             xr:=active.parametr[3]; yd:=active.parametr[4];
                           end;

                    end;

                end;
             close(map_file);

           end;
end.
