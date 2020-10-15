function cell = CellCycleToZPosition(cell, prm, flag)

if flag==1 
%    cell.maxz(1:cell.numb)=1.0; % homogeneous
    
    cstate=cell.timer./cell.cycle_length;
    
    l1=find(cstate<0);
    cell.zpos(l1)=0.0;
    
    l2=find(0<=cstate & cstate<0.5);
    cell.zpos(l2)=cell.maxzpos(l2)'/0.5 .*cstate(l2);
    
%    l3=find(0.5<=cstate & cstate<=1.0); % 0.95~23/24
%    cell.zpos(l3)= -cell.maxzpos(l3)'/0.5 .*cstate(l3) + cell.maxzpos(l3)'/0.5*1.0;
    l3=find(0.5<=cstate & cstate<=0.95); % 0.95~23/24
    cell.zpos(l3)= -cell.maxzpos(l3)'/0.45 .*cstate(l3) + cell.maxzpos(l3)'/0.45*0.95;
    
%    l4=find(1.0<cstate);
    l4=find(0.95<cstate);
    cell.zpos(l4)= 0.0;

elseif flag ==2
    cell.zpos(1:cell.numb)=0.5;

end

end