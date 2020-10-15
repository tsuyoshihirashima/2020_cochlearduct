function [cell,edge,vtx,tie]=CellDivision2DMonolayer(cid,cell,edge,vtx,prm,INIT_VER,tie)

% vtx.position
vl1=edge.vtx(cell.edge(cid,1),:)';
vl2=edge.vtx(cell.edge(cid,3),:)';
vpos1=vtx.pos(vl1,:); % apical
vpos2=vtx.pos(vl2,:); % basal

% noise
ns1 = 0.005*(rand(1,2)-0.5);
ns2 = 0.005*(rand(1,2)-0.5);
vtx.pos(vtx.numb+1,1:2) = 0.5*(vpos1(2,:)+vpos1(1,:)) + ns1;
vtx.pos(vtx.numb+2,1:2) = 0.5*(vpos2(2,:)+vpos2(1,:)) + ns2;

% cell.vtx
cell.vtx(cell.numb+1,1:2)=[vtx.numb+1 vtx.numb+2];
cell.vtx(cell.numb+1,3:4)=cell.vtx(cid,3:4);
cell.vtx(cid,3:4)=[vtx.numb+2 vtx.numb+1];

% cell.edge
elist=cell.edge(cid,:);
cell.edge(cell.numb+1,1:3) = edge.numb+1:edge.numb+3;
cell.edge(cell.numb+1,4) = cell.edge(cid,4);
cell.edge(cid,4)=edge.numb+2;

% cell.cell
nbcid=cell.cell(cid,2);
cell.cell(cell.numb+1,1:2)=[cid nbcid];
cell.cell(cid,2)=cell.numb+1;
cell.cell(nbcid,1)=cell.numb+1;

% cell.tie
%cell.tie(cell.numb+1,1:2)=[tie.numb+1:tie.numb+2];

% vtx.vtx
vtx.vtx(vtx.numb+1,1:3)=[vl1(1) vtx.numb+2 vl1(2)];
vtx.vtx(vtx.numb+2,1:3)=[vl2(1) vtx.numb+1 vl2(2)];
vtx.vtx(vl1(1),3)=vtx.numb+1;
vtx.vtx(vl1(2),1)=vtx.numb+1;
vtx.vtx(vl2(1),3)=vtx.numb+2;
vtx.vtx(vl2(2),1)=vtx.numb+2;

% vtx.edge
vtx.edge(vtx.numb+1,1:3)=[elist(1) edge.numb+1 edge.numb+2];
vtx.edge(vtx.numb+2,1:3)=[elist(3) edge.numb+2 edge.numb+3];
vtx.edge(vl1(2),find(vtx.edge(vl1(2),:)==elist(1)))=edge.numb+1;
vtx.edge(vl2(2),find(vtx.edge(vl2(2),:)==elist(3)))=edge.numb+3;

% vtx.cell
vtx.cell(vtx.numb+1,1:2)=[cid cell.numb+1];
vtx.cell(vtx.numb+2,1:2)=[cid cell.numb+1];
vtx.cell(vl1(2),1)=cell.numb+1;
vtx.cell(vl2(2),1)=cell.numb+1;

% edge.vtx
edge.vtx(edge.numb+1,1:2)=[vtx.numb+1 vl1(2)];
edge.vtx(edge.numb+2,1:2)=[vtx.numb+1 vtx.numb+2];
edge.vtx(edge.numb+3,1:2)=[vtx.numb+2 vl2(2)];
edge.vtx(elist(1),2)=vtx.numb+1;
edge.vtx(elist(3),2)=vtx.numb+2;

% edge.cell
edge.cell(edge.numb+1,1:2)=[cell.numb+1 0];
edge.cell(edge.numb+2,1:2)=[cid cell.numb+1];
edge.cell(edge.numb+3,1:2)=[cell.numb+1 0];
edge.cell(elist(4),2)=cell.numb+1; % <- the order of cells is different from others

% tie.vtx, tie.cell
%{
tls=cell.tie(cid,:);
tid1=tie.vtx(tls(1),2);
tid2=tie.vtx(tls(2),2);
tie.vtx(tls(1),2)=vtx.numb+2;
tie.vtx(tls(2),2)=vtx.numb+1;
tie.vtx(tie.numb+1,1:2)=[vtx.numb+1 tid1];
tie.vtx(tie.numb+2,1:2)=[vtx.numb+2 tid2];

tie.cell(tie.numb+1:tie.numb+2)=cell.numb+1;
%}
%% Updating Edge Properties
edge.type(edge.numb+1)=1;
edge.type(edge.numb+2)=2;
edge.type(edge.numb+3)=3;

%% Updating Cell Position
cell=GetCellPosition(vtx,cell,cell.numb+1);
cell=GetCellPosition(vtx,cell,cid);

%% Updating Cell Area
cell=GetCellArea(vtx,cell,cell.numb+1);
cell=GetCellArea(vtx,cell,cid);

%% Updating Edge Distance
edge=GetEdgeDistance(cell,edge,vtx,edge.numb+1);
edge=GetEdgeDistance(cell,edge,vtx,edge.numb+2);
edge=GetEdgeDistance(cell,edge,vtx,edge.numb+3);
edge=GetEdgeDistance(cell,edge,vtx,elist(1));
edge=GetEdgeDistance(cell,edge,vtx,elist(3));

%% Updating Tie Distance
%tie=GetTieDistance(tie,vtx,tie.numb+1);
%tie=GetTieDistance(tie,vtx,tie.numb+2);

%% Updating target edge distance
edge.target_dist(edge.numb+1:edge.numb+3)=edge.apical_original_length;
if INIT_VER==3
    edge.target_dist(edge.numb+2)=edge.lateral_original_length;
end
%tie.target_dist(tie.numb+1:tie.numb+2)=tie.original_length;

%% Get Cell Perimeter
cell=GetCellPerimeter(cell,edge,vtx,cell.numb+1);
cell=GetCellPerimeter(cell,edge,vtx,cid);

%% Adding parameter values in Cell/Edge/Vtx
cell.target_area(cid,1)=cell.original_area;
cell.target_area(cell.numb+1,1)=cell.original_area;
cell.prm_area(cell.numb+1,1)=prm.area;
cell.target_perim(cell.numb+1,1)=prm.target_perim;
cell.prm_perim(cell.numb+1,1)=prm.perim;
cell.erk(cell.numb+1,1)=cell.erk(cid,1); % 181107

edge.prm_edge(edge.numb+1)=prm.apical;
edge.prm_edge(edge.numb+2)=prm.lateral;
edge.prm_edge(edge.numb+3)=prm.basal;

%tie.prm_tie(tie.numb+1)=prm.tie;
%tie.prm_tie(tie.numb+2)=prm.tie;

%% Reset the cell timer -- 190427
%{ 
200805: lungƒ‚ƒfƒ‹‚É‚Í‚¢‚ç‚È‚¢‚Ì‚ÅÁ‚·B‚µ‚©‚µCochlear‚Å‚Í×–EŽüŠú“àŠO‚Ì‚Qó‘Ô‚ª‚ ‚é‚Ì‚Å‚±‚ê‚ðÝ‚¯‚Ä‚¢‚½B
if cell.state(cid)==1 % within cell cycle
    cell.timer(cid)= randi([0 round(0.05*prm.cell_cycle_length)]);
    cell.timer(cell.numb+1) = randi([round(0.05*prm.cell_cycle_length) round(0.1*prm.cell_cycle_length)]);
    cell.cycle_length(cid) = randi([prm.cell_cycle_length*0.5,prm.cell_cycle_length*1.5]);
    cell.cycle_length(cell.numb+1) = randi([prm.cell_cycle_length*0.5,prm.cell_cycle_length*1.5]);

elseif cell.state(cid)==2 % out of cell cycle
    cell.timer(cid)= 0;
    cell.timer(cell.numb+1) = 0;
    cell.cycle_length(cid) = prm.cell_cycle_length;
    cell.cycle_length(cell.numb+1) = prm.cell_cycle_length;
end
%}

cell.timer(cid)= randi([0 round(0.05*prm.cell_cycle_length)]);
cell.timer(cell.numb+1) = randi([0 round(0.05*prm.cell_cycle_length)]);
cell.cycle_length(cid) = randi([round(prm.cell_cycle_length*0.8),round(prm.cell_cycle_length*1.2)]);
cell.cycle_length(cell.numb+1) = randi([round(prm.cell_cycle_length*0.8),round(prm.cell_cycle_length*1.2)]);

%% Updating the number of elements: no need
vtx.f_area(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);
vtx.f_perim(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);
vtx.f_apicaledge(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);
vtx.f_basaledge(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);
vtx.f_lateraledge(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);
vtx.f_bend(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);
vtx.f_luminal(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);
vtx.f_tie(vtx.numb+1:vtx.numb+2,1:2)=zeros(2,2);

%% Updating All numbers
cell.numb=cell.numb+1;
vtx.numb=vtx.numb+2;
edge.numb=edge.numb+3;
%tie.numb=tie.numb+2;

end

