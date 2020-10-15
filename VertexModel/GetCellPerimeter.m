function cell=GetCellPerimeter(cell,edge,vtx,cid)

if nargin<4
    
    cell.perim=sum(edge.dist(cell.edge),2);

    %{
    for cid=1:cell.numb
        vl1=cell.vtx(cid,:);
        vl2=circshift(vl1,-1);
        v1pos=[vtx.pos(vl1,1) vtx.pos(vl1,2)];
        v2pos=[vtx.pos(vl2,1) vtx.pos(vl2,2)];
        
        dist_list=sqrt(sum((v2pos-v1pos).*(v2pos-v1pos),2));
        cell.perimetr(cid)=sum(dist_list);
    end
    %}
elseif nargin==4
    
    cell.perim(cid)=sum(edge.dist(cell.edge(cid,:)));

    %{
    vl1=cell.vtx(cid,:);
    vl2=circshift(vl1,-1);
    v1pos=[vtx.pos(vl1,1) vtx.pos(vl1,2)];
    v2pos=[vtx.pos(vl2,1) vtx.pos(vl2,2)];
    
    dist_list=sqrt(sum((v2pos-v1pos).*(v2pos-v1pos),2));
    cell.perimeter(cid)=sum(dist_list);
    %}
end