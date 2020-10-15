function [cell,edge,vtx,tie]=InitialSetting2DMonolayer(initprm, r, INIT_VER)

vtx.pos(1:length(r.x),1:2)=[r.x' r.y'];

%% number
if INIT_VER==1
    cell.numb=initprm.cnumb;
    vtx.numb=initprm.cnumb*2;
    edge.numb=initprm.cnumb*3;
    tie.numb=initprm.cnumb*2;
elseif INIT_VER==2
    cell.numb=initprm.cnumb;
    vtx.numb=(initprm.cnumb+1)*2;
    edge.numb=initprm.cnumb*3+1;
    tie.numb=initprm.cnumb*2;
elseif INIT_VER==3 || INIT_VER==4
    cell.numb=initprm.cnumb;
    vtx.numb=(initprm.cnumb+1)*2;
    edge.numb=initprm.cnumb*3+1;
    tie.numb=initprm.cnumb*2;
end

vtx.initnumb=vtx.numb;
cell.initnumb=initprm.cnumb;


%% Initial setting for cell, edge, and vtx
cell.vtx=zeros(cell.numb,4);
cell.edge=zeros(cell.numb,4);
cell.cell=zeros(cell.numb,2);
cell.tie=zeros(cell.numb,2);

edge.vtx=zeros(edge.numb,2);
edge.cell=zeros(edge.numb,2); % <=2
edge.type=zeros(edge.numb,1);

vtx.vtx=zeros(vtx.numb,3);
vtx.edge=zeros(vtx.numb,3);
vtx.cell=zeros(vtx.numb,2);
vtx.angle=zeros(vtx.numb,1);
vtx.f_area=zeros(vtx.numb,2);
vtx.f_perim=zeros(vtx.numb,2);
vtx.f_apicaledge=zeros(vtx.numb,2);
vtx.f_basaledge=zeros(vtx.numb,2);
vtx.f_lateraledge=zeros(vtx.numb,2);
vtx.f_hitavoid=zeros(vtx.numb,2);
vtx.f_bend=zeros(vtx.numb,2);
vtx.f_outward=zeros(vtx.numb,2); % 190504 added
vtx.f_luminal=zeros(vtx.numb,2); % 190716 added

tie.vtx=zeros(tie.numb,2);
tie.cell=zeros(tie.numb,1);

cell.target_area=zeros(cell.numb,1);
cell.erk=zeros(cell.numb,1); % 181107 add
cell.div=ones(cell.numb,1);


%% cell.vtx, cell.edge, cell.cell, edge.cell, cell.tie
vid=1; eid=1; tid=1;
for cid = 1:cell.numb
    
    if cid<cell.numb
        % cell.vtx
        cell.vtx(cid,1)=vid;
        cell.vtx(cid,2)=vid+1;
        cell.vtx(cid,3)=vid+3;
        cell.vtx(cid,4)=vid+2;
        vid=vid+2;
        
        % cell.edge
        cell.edge(cid,1:3)=[eid:eid+2];
        cell.edge(cid,4)=eid+4;
        eid=eid+3;
        
        % cell.cell
        cell.cell(cid,1)=cid-1;
        cell.cell(cid,2)=cid+1;
        
        % cell.tie
        cell.tie(cid,1)=tid;
        cell.tie(cid,2)=tid+1;
        tid=tid+2;
        
    elseif cid==cell.numb
        % cell.vtx
        cell.vtx(cid,1)=vid;
        cell.vtx(cid,2)=vid+1;
        cell.vtx(cid,3)=2;
        cell.vtx(cid,4)=1;
        
        % cell.edge
        cell.edge(cid,1:3)=[eid:eid+2];
        cell.edge(cid,4)=2;
        
        % cell.cell
        cell.cell(cid,1)=cid-1;
        cell.cell(cid,2)=1;
        
        % cell.tie
        cell.tie(cid,1)=tid;
        cell.tie(cid,2)=tid+1;
        tid=tid+2;
        
    end
    
    % edge.cell
    tmp=3*(cid-1)+1;
    edge.cell([tmp:tmp+2],1)=cid;
    
end
if INIT_VER==1
    cell.cell(1,1)=cell.numb; % this is required.
    edge.cell(circshift([2:3:edge.numb],-1),2)=[1:1:cell.numb]; % this is required.
elseif INIT_VER==2 || INIT_VER==3 || INIT_VER==4
    cell.cell(1,1)=0;
    cell.cell(cell.numb,2)=0;
    
    edge.cell(2,2)=0;
    edge.cell(edge.numb,1)=cell.numb;
    for c=2:initprm.cnumb
        edge.cell(c*3-1,1:2)=[c-1 c];
    end
    
    cell.edge(cell.numb,4)=edge.numb;
    cell.vtx(cell.numb,3)=vtx.numb;
    cell.vtx(cell.numb,4)=vtx.numb-1;
end


%% vtx
for vid=1:vtx.numb
    if vid<=2
        if mod(vid,2)==1
            vtx.vtx(vid,1)=vtx.numb-1;
            vtx.vtx(vid,2)=vid+1;
            vtx.vtx(vid,3)=vid+2;
        elseif mod(vid,2)==0
            vtx.vtx(vid,1)=vtx.numb;
            vtx.vtx(vid,2)=vid-1;
            vtx.vtx(vid,3)=vid+2;
        end
        
        % vtx.cell
        vtx.cell(vid,1)=cell.numb;
        vtx.cell(vid,2)=1;
        
    elseif vid>=vtx.numb-1
        if mod(vid,2)==1
            vtx.vtx(vid,1)=vid-2;
            vtx.vtx(vid,2)=vid+1;
            vtx.vtx(vid,3)=1;
            
            % vtx.cell
            vtx.cell(vid,1)=floor(vid/2);
            vtx.cell(vid,2)=floor(vid/2)+1;
            
        elseif mod(vid,2)==0
            vtx.vtx(vid,1)=vid-2;
            vtx.vtx(vid,2)=vid-1;
            vtx.vtx(vid,3)=2;
            
            % vtx.cell
            vtx.cell(vid,1)=floor(vid/2)-1;
            vtx.cell(vid,2)=floor(vid/2);
            
        end
        
    else
        if mod(vid,2)==1
            vtx.vtx(vid,1)=vid-2;
            vtx.vtx(vid,2)=vid+1;
            vtx.vtx(vid,3)=vid+2;
            
            % vtx.cell
            vtx.cell(vid,1)=floor(vid/2);
            vtx.cell(vid,2)=floor(vid/2)+1;
            
        elseif mod(vid,2)==0
            vtx.vtx(vid,1)=vid-2;
            vtx.vtx(vid,2)=vid-1;
            vtx.vtx(vid,3)=vid+2;
            
            % vtx.cell
            vtx.cell(vid,1)=floor(vid/2)-1;
            vtx.cell(vid,2)=floor(vid/2);
        end
    end
end
if INIT_VER==2 || INIT_VER==3 || INIT_VER==4
    vtx.vtx(1,1)=0; vtx.vtx(2,1)=0;
    vtx.vtx(vtx.numb-1,3)=0; vtx.vtx(vtx.numb,3)=0;
    vtx.cell(1,1)=0; vtx.cell(2,1)=0;
    vtx.cell(vtx.numb-1,2)=0; vtx.cell(vtx.numb,2)=0;
end

%% edge
if INIT_VER==1
    
    % edge.vtx
    j=1;
    for i=1:3:edge.numb
        if i==edge.numb-2
            edge.vtx(i,1:2)=[2*(j-1)+1 1];
            edge.vtx(i+1,1:2)=[2*(j-1)+1 2*j];
            edge.vtx(i+2,1:2)=[2*j 2];
        else
            edge.vtx(i,1:2)=[2*(j-1)+1 2*j+1];
            edge.vtx(i+1,1:2)=[2*(j-1)+1 2*j];
            edge.vtx(i+2,1:2)=[2*j 2*(j+1)];
        end
        j=j+1;
    end
    
elseif INIT_VER==2 || INIT_VER==3 || INIT_VER==4
    
    % edge.vtx
    j=1;
    for i=1:3:(edge.numb-1)
        if i==edge.numb-2
            edge.vtx(i,1:2)=[2*(j-1)+1 1];
            edge.vtx(i+1,1:2)=[2*(j-1)+1 2*j];
            edge.vtx(i+2,1:2)=[2*j 2];
        else
            edge.vtx(i,1:2)=[2*(j-1)+1 2*j+1];
            edge.vtx(i+1,1:2)=[2*(j-1)+1 2*j];
            edge.vtx(i+2,1:2)=[2*j 2*(j+1)];
        end
        j=j+1;
    end
    edge.vtx(edge.numb,1:2)=[2*(j-1)+1 2*j];
    
end

% vtx.edge
for eid=1:edge.numb
    v1=edge.vtx(eid,1);
    v2=edge.vtx(eid,2);
    
    len1=length(find(vtx.edge(v1,:)));
    len2=length(find(vtx.edge(v2,:)));
    
    vtx.edge(v1,len1+1)=eid;
    vtx.edge(v2,len2+1)=eid;
end

%% Edge type
edge.type(3*[1:cell.numb]-2,1)=1; % 1: apical
edge.type([2:3:edge.numb],1)=2; % 2: lateral
edge.type(3*[1:cell.numb],1)=3; % 3: basal
if INIT_VER==2 || INIT_VER==3 || INIT_VER==4
    edge.type(edge.numb)=2; % 2: lateral
end


%% tie: tie.vtx, tie.cell
cid=1;
for tid=1:tie.numb
    if mod(tid,2)==0 % even number
        tie.vtx(tid,1)=tid;
        tie.vtx(tid,2)=tid+1;
        tie.cell(tid)=cid;
        cid=cid+1;
    else % odd number
        tie.vtx(tid,1)=tid;
        tie.vtx(tid,2)=tid+3;
        tie.cell(tid)=cid;
    end
end
if INIT_VER==1
    tie.vtx(tie.numb-1,2)=2;
    tie.vtx(tie.numb,2)=1;
end


%% Adding noise
ns = initprm.noise*(rand(vtx.numb,2)-0.5);
vtx.pos = vtx.pos + ns;

%% Updating cell position
cell=GetCellPosition(vtx,cell);

%% Get Cell Area - 180829
cell=GetCellArea(vtx,cell);
cell.original_area = mean(cell.area)*1.0;
cell.target_area(1:cell.numb,1) = cell.original_area*1.0;

%% Get Edge Distance
edge=GetEdgeDistance(cell,edge,vtx);

%% Get Tie Distance - 191107
tie=GetTieDistance(tie,vtx);

%% Get Cell Perimeter - 180830
cell=GetCellPerimeter(cell,edge,vtx);

%% Cell Timer - 190427
cell.timer=randi(round(0.8*initprm.cell_cycle_length),[cell.numb 1]);
cell.cycle_length=randi([round(initprm.cell_cycle_length*0.8),round(initprm.cell_cycle_length*1.2)],[cell.numb 1]);


%% Target edge distance - 190502
edge.apical_original_length=mean(edge.dist(edge.type==1)) * 1.0;
edge.lateral_original_length=mean(edge.dist(edge.type==2));
edge.target_dist=ones(edge.numb,1)*edge.apical_original_length;
if INIT_VER==3
    els=find(edge.type==2);
    edge.target_dist(els)=initprm.thick;
end
% 191107 added
tie.original_length=mean(tie.dist);
tie.target_dist=ones(tie.numb,1)*tie.original_length;

end