function tie=GetTieDistance(tie,vtx,tid)

if nargin<3
    
    vl1=tie.vtx(:,1);
    vl2=tie.vtx(:,2);
    v1pos=[vtx.pos(vl1,1) vtx.pos(vl1,2)];
    v2pos=[vtx.pos(vl2,1) vtx.pos(vl2,2)];
    
    dist=sqrt(sum((v2pos-v1pos).*(v2pos-v1pos),2));
    tie.dist=dist;
    
elseif nargin==3
    
    vl1=tie.vtx(tid,1);
    vl2=tie.vtx(tid,2);
    v1pos=[vtx.pos(vl1,1) vtx.pos(vl1,2)];
    v2pos=[vtx.pos(vl2,1) vtx.pos(vl2,2)];
    
    dist=sqrt(sum((v2pos-v1pos).*(v2pos-v1pos)));
    tie.dist(tid)=dist;
    
end