Unit consts;
 Interface
  const
        GrP='c:\tpwdb\bgi';
        R_D=6;
        DS_DISK=8;
        N=100;
        N1=40;
        RBUL=1;
        DX_BUL=4;
        RH=20;
        RH1=30;
        STEP=5;
        H=20;
        ec=0;
        IT=4; MAXlvl=5;
        MAXhp=25;
        MAXd=5; MAXl=5;
        Cline=35;   {нахрен надо?}
        Aline=15;
        MAXpistol=50;
  type block =
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
  type blockh =     {record of hero}
     record
       x, y          :integer;
       xp, damage    :integer;
       disk, laser   :integer;
       dcount,lcount :integer;
       magazine      :integer;
       xdis, ydis    :integer;
       anglelas, angledis :real;
       dx, dy        :integer;
       pov           :integer;
     end;
  type bullet =
    record
      x,y,lr,damage : integer;
     end;
    type mas1 = array [1..N1] of bullet;
   type
     arblocks = array[1..N] of block;
     bot_file = file of block;
   var
    interimg :pointer;
   Implementation
end.