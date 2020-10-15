function cell=AddTimer(cell, flag)

if flag==1
    cell.timer=cell.timer+1;
    
elseif flag==2
    list=find(cell.div==1);
    cell.timer(list)=cell.timer(list)+1;
     
end

end

