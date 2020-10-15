function cell = GetCellState(cell, flag, cid)

s=1; % 1:flat, 2:curv

if flag==1
    cell.state(1:cell.numb)=s; % 1:flat, 2:curv
    
elseif flag==2
    cell.state(cid)=s; % 1:flat, 2:curv
    
elseif flag==3
    
    wk_cid=cid;
    dist_total=0.0;
    for c=1:cell.numb
        nbcid=cell.cell(wk_cid,2);
        if nbcid==0
            break; end
        vec = cell.pos(nbcid,:)-cell.pos(wk_cid,:);
        dist = sqrt(sum(vec.*vec,2));
        dist_total = dist_total + dist;
        wk_cid=nbcid;
    end
    
    dist_thr = 50; %[É m]
    if dist_total<=dist_thr
        cell.state(cid)=1; % flat
    elseif dist_total>dist_thr
        cell.state(cid)=2; % curv
    end
end

end