function cell=GetCellPosition(vtx,cell,cid)

if nargin<3
    for cid=1:cell.numb
        denom=sum(cell.vtx(cid,:)>0);
        xpos=vtx.pos(cell.vtx(cid,:),1);
        ypos=vtx.pos(cell.vtx(cid,:),2);
        cell.pos(cid,:)=sum([xpos ypos])/denom;
    end
    
elseif nargin==3
    denom=sum(cell.vtx(cid,:)>0);
    xpos=vtx.pos(cell.vtx(cid,:),1);
    ypos=vtx.pos(cell.vtx(cid,:),2);
    cell.pos(cid,:)=sum([xpos ypos])/denom;
end


