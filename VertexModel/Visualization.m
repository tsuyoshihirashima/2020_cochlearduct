function Visualization(cell,edge,vtx,prm,vis_window)
%plot(cell.pos(:,1),cell.pos(:,2),'ob');


cv_x=vtx.pos(cell.vtx(:),1);
cv_y=vtx.pos(cell.vtx(:),2);
x=reshape(cv_x,cell.numb,4)';
y=reshape(cv_y,cell.numb,4)';

a1=axes;
%patch(x,y,cell.curv,'FaceColor','none')
patch(a1, x,y,cell.curv,'FaceColor','flat');

caxis(a1, [-.3 .3])
colormap(a1, BR_Lut)
%colorbar

tick_w=20;
tick_n=floor(vis_window/tick_w);

xlim(a1,[-vis_window vis_window]);
ylim(a1,[-vis_window vis_window]);
xticks(a1, -tick_n*tick_w:tick_w:tick_n*tick_w);
yticks(a1, -tick_n*tick_w:tick_w:tick_n*tick_w);
xticklabels(a1, {})
yticklabels(a1, {})

axis(a1,'square')
daspect(a1, [1 1 1])
box(a1, 'on')


%% Nuclei z-position, added on 200313
%{
vlist=cell.vtx;
bv_pos=0.5*(vtx.pos(vlist(:,1),:) + vtx.pos(vlist(:,4),:));
av_pos=0.5*(vtx.pos(vlist(:,2),:) + vtx.pos(vlist(:,3),:));

r0 = (bv_pos-av_pos) .* cell.zpos' + av_pos;

cstate=cell.timer/prm.cell_cycle_length;
list1=find(cstate<0); cstate(list1)=0.0;
list2=find(cstate>1); cstate(list2)=1.0;

% remove the boundary cells
r0(cell.initnumb,:)=[];
r0(1,:)=[];
cstate(cell.initnumb)=[];
cstate(1)=[];

nuc_x=r0(:,1); nuc_y=r0(:,2);

tmp_state=cell.state;
tmp_state(cell.initnumb)=[]; tmp_state(1)=[];

list_f=find(tmp_state==1);
list_c=find(tmp_state==2);


%hold on
sz = 5000/vis_window;

a2=axes;
scatter(a2, nuc_x(list_f),nuc_y(list_f),sz,cstate(list_f),'filled','MarkerFaceAlpha',.5);
caxis(a2, [0 1])
colormap(a2,hsv)
xlim(a2,[-vis_window vis_window])
ylim(a2,[-vis_window vis_window])
a2.Visible = 'off';
axis(a2,'square')
daspect(a2, [1 1 1])
box(a2, 'on')


a3=axes;
scatter(a3, nuc_x(list_c),nuc_y(list_c),sz*2,cstate(list_c),'filled','MarkerFaceAlpha',.5,'MarkerEdgeColor',[.8 .8 .8], 'LineWidth',0.5);
caxis(a3, [0 1])
colormap(a3,hsv)
xlim(a3,[-vis_window vis_window])
ylim(a3,[-vis_window vis_window])
a3.Visible = 'off';
axis(a3,'square')
daspect(a3, [1 1 1])
box(a3, 'on')


linkaxes([a1, a2, a3],'xy')

%hold off


%}

% normal vector
%{
vls = 2:2:vtx.numb;
vx=vtx.pos(vls,1);
vy=vtx.pos(vls,2);
vu = vtx.n_norm_vec(vls,1);
vv = vtx.n_norm_vec(vls,2);
quiver(vx,vy,vu,vv)
%}

%for i=1:cell.numb
%    vl=[cell.vtx(i,:) cell.vtx(i,1)]; 
%    plot(vtx.pos(vl',1), vtx.pos(vl',2), '.-k')
%end


%{
xlim([-max max])
ylim([-max max])
%}




%set(gca,'XTick',[])
%set(gca,'YTick',[])

end
