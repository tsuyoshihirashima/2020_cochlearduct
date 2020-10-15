%% main.m
% This program was used for Figure S2 (2020, Ishii et al., eLife)
% Credits: Tsuyoshi Hirashima at Kyoto University
% hirashima.tsuyoshi.2m (at) kyoto-u.ac.jp

clear
close all

%% Parameters for initial configuration
INIT_VER=3; % linear case for IKNM
initprm.cnumb=20; % initial cell number
nucwidth=2.5; % [ƒÊm]
initprm.thick=50; % Thickness: 50 ƒÊm

time_max=3001;

prm.apical = 1.0; % positive/negative: constriction/extension
prm.basal = 1.0; % positive/negative: constriction/extension
prm.lateral = 1.0; % positive/negative: constriction/extension

prm.area = 0.01;
prm.perim = 0.0;

prm.ap_bend = 30;
prm.bs_bend = 30;

maxz=0.75; % corresponding to the parameter gamma

%% Cell Division
DIVISION=1;
initprm.cell_cycle_length=144*3;
prm.cell_cycle_length=initprm.cell_cycle_length;
cycle_thr=0.0;

%% Fixed Parameters
dt=0.01;
initprm.noise = 0.01;

%% Creating a depository
DateString = datestr(datetime('now'))
dir_name=['graph' DateString];
mkdir(dir_name)


%% Initial vertices seeding
% ver.3 -- linear
if INIT_VER==3
    c=initprm.cnumb;
    w=initprm.thick;
    x1 = [c/2:-1:-c/2]*nucwidth;
    y1 = -w/2*ones(1,initprm.cnumb+1);
    x2 = [c/2:-1:-c/2]*nucwidth;
    y2 = w/2*ones(1,initprm.cnumb+1);
    r.x = reshape([x1' x2']',1,2*(initprm.cnumb+1));
    r.y = reshape([y1' y2']',1,2*(initprm.cnumb+1));
end

init_window = max([r.x r.y])*3;
[cell,edge,vtx]=InitialSetting2DMonolayer(initprm, r, INIT_VER);


%% Cell State Setting
cell = GetCellState(cell, 1);

%% Misc setting -- numb
prm.target_area=mean(cell.area);
prm.target_perim=mean(cell.perim);

%% Parameter setting
edge.prm_edge = zeros(edge.numb,1);
edge.prm_edge(find(edge.type==1))=prm.apical;
edge.prm_edge(find(edge.type==2))=prm.lateral;
edge.prm_edge(find(edge.type==3))=prm.basal;

% area, perimeter
cell.prm_area(1:cell.numb,1) = prm.area;
cell.prm_perim(1:cell.numb,1) = prm.perim;
cell.target_perim(1:cell.numb,1) = prm.target_perim;

%% pre-registoration
cell=CellCurvature(cell,INIT_VER, 2); % flag -1: angle based, 2: spiline based
vtx=VertexAngle(vtx, 3, INIT_VER); % flag - 1: apical, 2: basal, 3: both(apical&basal)

if DIVISION==1
    cell = DivisionSwitch(cell, cycle_thr, INIT_VER);
    cell = GetMaxZPosition(cell, 1, maxz, 0);
    cell = CellCycleToZPosition(cell, prm, 1);
    edge = ZPositionToTargetEdgeDistance(cell, edge, 1);
end


tic
for t=1:round(time_max/dt)
    
    time=t*dt;
    
    %% Calculation of Forces
    vtx = AreaForce(cell,vtx);
    vtx = ApicalEdgeForce(edge,vtx,2);
    vtx = BasalEdgeForce(edge,vtx,2);
    vtx = LateralEdgeForce(edge,vtx,2);
    vtx = BendingForce(vtx,prm, INIT_VER);
    
    %% Force calculation
    vtx.force = vtx.f_area + vtx.f_apicaledge + vtx.f_lateraledge + vtx.f_basaledge + vtx.f_bend;
    vtx.force = vtx.force + 0.01*normrnd(0,1,[vtx.numb,2]); % white gaussian noise if necessary -- stability of numerical simulation is enhanced when included.    
    
    %% Relativity in Vertex Dynamics %%
    prev_cpos=cell.pos;
    
    vtx.pos = vtx.pos + vtx.force*dt;
    cell=GetCellPosition(vtx,cell);
    dif_cpos = cell.pos - prev_cpos;
    
    clist1=vtx.cell(:,1);
    vlist1=find(clist1>0);
    cellpos1x=dif_cpos(clist1(vlist1),1);
    cellpos1y=dif_cpos(clist1(vlist1),2);
    
    clist2=vtx.cell(:,2);
    vlist2=find(clist2>0);
    cellpos2x=dif_cpos(clist2(vlist2),1);
    cellpos2y=dif_cpos(clist2(vlist2),2);
    
    vposx=nan(vtx.numb,2);
    vposy=nan(vtx.numb,2);
    vposx(vlist1,1)=cellpos1x;
    vposy(vlist1,1)=cellpos1y;
    vposx(vlist2,2)=cellpos2x;
    vposy(vlist2,2)=cellpos2y;
    
    mean_vpos(1:vtx.numb,1:2)=[nanmean(vposx,2) nanmean(vposy,2)];
    mean_vpos(1:2,1:2)=0.0;
    mean_vpos(vtx.initnumb-1:vtx.initnumb,1:2)=0.0;
    
    vtx.pos = vtx.pos - vtx.force*dt;
    vtx.force = vtx.force - mean_vpos;
    
    
    %% Updating vertices positions
    vtx.pos = vtx.pos + vtx.force*dt;
    
    cell=GetCellPosition(vtx,cell);
    cell=GetCellArea(vtx,cell);
    edge=GetEdgeDistance(cell,edge,vtx);
    
    
    %% Visualization
    if mod(time,10)==0
        disp(['time: ', num2str(time)])
        
        window=max(abs(reshape(vtx.pos,vtx.numb*2,1)));
        if window*1.1>init_window
            vis_window=window*1.1;
        else
            vis_window=init_window;
        end
        
        Visualization(cell,edge,vtx,prm,vis_window);
        
        filename = [dir_name, '/image', num2str(round(time)),'-', num2str(cell.numb), '.png'];
        saveas(gcf, filename)
        
        filename = [dir_name, '/data', num2str(round(time))];
        save(filename)
    end
    
    
    %% CellCycle -- Note that the "CellCycle" should be ahead of "Curvature in monolayer"
    if mod(time,1)==0
        
        if DIVISION==1
            
            cell = DivisionSwitch(cell, cycle_thr, INIT_VER);
            
            % Cell Cycle
            cell=AddTimer(cell, 2); % flag: 1->non-conditional, 2->curv-dependent
            
            list=find(cell.timer>initprm.cell_cycle_length);
            numb=numel(list);
            
            for n=1:numb
                cid=list(n);
                
                cell = GetCellState(cell, 1, cid);
                cell = GetMaxZPosition(cell, 2, maxz, 0, cid);
                
                [cell,edge,vtx]=CellDivision2DMonolayer(cid,cell,edge,vtx,prm,INIT_VER);
                
                cell = GetCellState(cell, 1, cell.numb);
                cell = GetMaxZPosition(cell, 2, maxz, 0, cell.numb);
                
                if mod(cell.numb,20)==0
                    disp(['cell number: ', num2str(cell.numb)])
                end
                
            end
            
            cell = CellCycleToZPosition(cell, prm, 1);
            edge = ZPositionToTargetEdgeDistance(cell, edge, 1);
        end
    end
    
    
    %% Curvature in monolayer
    cell=CellCurvature(cell,INIT_VER, 2);
    vtx=VertexAngle(vtx, 3, INIT_VER); % flag - 1: apical, 2: basal, 3: both(apical&basal)
    
    
    if mod(time,1)==0
        if cell.numb>60
            save(dir_name);
            break;
        end
    end
    
    
    
end
%%
toc

file=fopen('curv.dat','a');
fprintf(file, '%f\n',mean(cell.curv));
fclose(file);

