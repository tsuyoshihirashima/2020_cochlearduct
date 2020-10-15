function edge=GetEdgeDistance(cell,edge,vtx,eid)

if nargin<4
    
    vl1=edge.vtx(:,1);
    vl2=edge.vtx(:,2);
    v1pos=[vtx.pos(vl1,1) vtx.pos(vl1,2)];
    v2pos=[vtx.pos(vl2,1) vtx.pos(vl2,2)];
    
    dist=sqrt(sum((v2pos-v1pos).*(v2pos-v1pos),2));
    edge.dist=dist;
    
elseif nargin==4
    
    vl1=edge.vtx(eid,1);
    vl2=edge.vtx(eid,2);
    v1pos=[vtx.pos(vl1,1) vtx.pos(vl1,2)];
    v2pos=[vtx.pos(vl2,1) vtx.pos(vl2,2)];
    
    dist=sqrt(sum((v2pos-v1pos).*(v2pos-v1pos)));
    edge.dist(eid)=dist;
    
end