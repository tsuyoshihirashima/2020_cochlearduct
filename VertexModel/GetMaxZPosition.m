function cell = GetMaxZPosition(cell, flag, maxz, rnd, cid)

if flag==1
    if rnd==1
        list1=find(cell.state==1); % flat
        flat_rnd= 0.5 + 0.4*rand(1,length(list1));
        cell.maxzpos(list1)=flat_rnd;
        
        list2=find(cell.state==2); % curv
        curv_rnd= 0.05 + 0.25*rand(1,length(list2));
        cell.maxzpos(list2)=curv_rnd;
    elseif rnd==0
        list1=find(cell.state==1); % flat
        cell.maxzpos(list1)=maxz;
        list2=find(cell.state==2); % curv
        cell.maxzpos(list2)=0.0;
    end
   
    
elseif flag ==2 % cidÇ™àÍÇ¬ÇÃèÍçá
    if rnd==1
        
        if cell.state(cid)==1
            cell.maxzpos(cid) = 0.5 + 0.4*rand(1,1);
        elseif cell.state(cid)==2
            cell.maxzpos(cid) = 0.05 + 0.25*rand(1,1);
        end
    elseif rnd==0
        if cell.state(cid)==1
            cell.maxzpos(cid)=maxz;
        elseif cell.state(cid)==2
            cell.maxzpos(cid)=0.0;
        end
    end
end

end