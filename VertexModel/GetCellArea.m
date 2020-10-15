function cell=GetCellArea(vtx,cell,cid)

if nargin<3
    
    for cid = 1:cell.numb
        vlist=cell.vtx(cid,:);
        x=vtx.pos(vlist,1);
        y=vtx.pos(vlist,2);
        cell.area(cid)=polyarea(x,y);
    end
    
elseif nargin==3
    vlist=cell.vtx(cid,:);
    x=vtx.pos(vlist,1);
    y=vtx.pos(vlist,2);
    cell.area(cid)=polyarea(x,y);
end