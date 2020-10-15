function cell=DivisionSwitch(cell,cycle_thr,INIT_VER)

list1=find(cell.curv>=cycle_thr);
cell.div(list1)=1;

list2=find(cell.curv<cycle_thr);
cell.div(list2)=0;

%%{
if INIT_VER==3 || INIT_VER==4
    cell.div(:)=1;
    cell.div(1)=0; cell.div(cell.initnumb)=0;
    
    list=find(cell.state==2);
    cell.div(list)=0;
    
end
%}

end