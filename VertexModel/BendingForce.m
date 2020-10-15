%% SECTION TITLE
% DESCRIPTIVE TEXT
function vtx = BendingForce(vtx, prm, INIT_VER)

ls = (1:vtx.numb)';

%% 190401
rv = vtx.vtx(ls,1); % vertex list in the right side
zlst_rv=find(rv==0);
rv(zlst_rv)=1; % dummy

rrv = vtx.vtx(rv,1); % vertex list in the right->right side
zlst_rrv=find(rrv==0);
rrv(zlst_rrv)=1; % dummy

lv = vtx.vtx(ls,3); % vertex list in the left side
zlst_lv=find(lv==0);
lv(zlst_lv)=vtx.initnumb; % dummy

llv = vtx.vtx(lv,3); % vertex list in the left->left side
zlst_llv=find(llv==0);
llv(zlst_llv)=vtx.initnumb; % dummy

if INIT_VER==1
    vec_l = vtx.pos(ls,:)-vtx.pos(lv,:); % vector from lv -> target vertex
    vec_ll = vtx.pos(lv,:)-vtx.pos(llv,:); % vector from llv -> lv
    vec_r = vtx.pos(rv,:)-vtx.pos(ls,:); % vector from target vertex -> rv
    vec_rr = vtx.pos(rrv,:)-vtx.pos(rv,:); % vector from rv -> rrv
    
elseif INIT_VER>=3
    
    % left
    nbvtx1=vtx.vtx(vtx.initnumb-1,1);
    nbvtx2=vtx.vtx(vtx.initnumb,1);  
    r1 = 2*vtx.pos(vtx.initnumb-1,1:2)-vtx.pos(nbvtx1,1:2);
    r2 = 2*vtx.pos(vtx.initnumb,1:2)-vtx.pos(nbvtx2,1:2);  
    pos1=vtx.pos(lv,:);
    pos1(vtx.initnumb-1:vtx.initnumb,1:2)=[r1;r2] +0.01*normrnd(0,1,[2,2]); % noise is required;
    
    r3 = 3*vtx.pos(vtx.initnumb-1,1:2)-vtx.pos(nbvtx1,1:2);
    r4 = 3*vtx.pos(vtx.initnumb,1:2)-vtx.pos(nbvtx2,1:2);  
    pos2=vtx.pos(llv,:);
    pos2(vtx.initnumb-3:vtx.initnumb-2,1:2)=[r1;r2] +0.01*normrnd(0,1,[2,2]); % noise is required
    pos2(vtx.initnumb-1:vtx.initnumb,1:2)=[r3;r4] +0.01*normrnd(0,1,[2,2]); % noise is required
        
    % right
    nbvtx1=vtx.vtx(1,3);
    nbvtx2=vtx.vtx(2,3);  
    r1 = 2*vtx.pos(1,1:2)-vtx.pos(nbvtx1,1:2);
    r2 = 2*vtx.pos(2,1:2)-vtx.pos(nbvtx2,1:2);  
    pos3=vtx.pos(rv,:);
    pos3(1:2,1:2)=[r1;r2] +0.01*normrnd(0,1,[2,2]); % noise is required;

    r3 = 3*vtx.pos(1,1:2)-vtx.pos(nbvtx1,1:2);
    r4 = 3*vtx.pos(2,1:2)-vtx.pos(nbvtx2,1:2); 
    pos4=vtx.pos(rrv,:);
    pos4(3:4,1:2)=[r1;r2] +0.01*normrnd(0,1,[2,2]); % noise is required;
    pos4(1:2,1:2)=[r3;r4] +0.01*normrnd(0,1,[2,2]); % noise is required;

    
    vec_l = vtx.pos(ls,:)-pos1; % vector from lv -> target vertex
    vec_ll = pos1-pos2; % vector from llv -> lv
    
    vec_r = pos3-vtx.pos(ls,:); % vector from target vertex -> rv
    vec_rr = pos4-pos3; % vector from rv -> rrv

    
    
    %{
    pos1=vtx.pos(lv,:);
    pos1(zlst_lv(1),1:2)=[1000 -1];
    pos1(zlst_lv(2),1:2)=[1000 1];
    
    pos2=vtx.pos(llv,:);
    pos2(zlst_llv(1),1:2)=[1000 -1];
    pos2(zlst_llv(2),1:2)=[1000 1];
    pos2(zlst_llv(3),1:2)=[1001 -1];
    pos2(zlst_llv(4),1:2)=[1001 1];
    
    pos3=vtx.pos(rv,:);
    pos3(zlst_rv(1),1:2)=[-10 -1];
    pos3(zlst_rv(2),1:2)=[-10 1];
    
    pos4=vtx.pos(rrv,:);
    pos4(zlst_rrv(1),1:2)=[-11 -1];
    pos4(zlst_rrv(2),1:2)=[-11 1];
    pos4(zlst_rrv(3),1:2)=[-10 -1];
    pos4(zlst_rrv(4),1:2)=[-10 1];
    
    vec_l = vtx.pos(ls,:)-pos1; % vector from lv -> target vertex
    vec_ll = pos1-pos2; % vector from llv -> lv
    
    vec_r = pos3-vtx.pos(ls,:); % vector from target vertex -> rv
    vec_rr = pos4-pos3; % vector from rv -> rrv
    %}
end


d_vec_l = sqrt(sum(vec_l.*vec_l,2)); % distance
d_vec_ll = sqrt(sum(vec_ll.*vec_ll,2));
d_vec_r = sqrt(sum(vec_r.*vec_r,2));
d_vec_rr = sqrt(sum(vec_rr.*vec_rr,2));

u_l = vec_l./d_vec_l;
u_ll = vec_ll./d_vec_ll;
u_r = vec_r./d_vec_r;
u_rr = vec_rr./d_vec_rr;

%%
% NOTE: sin function in denomitors should be careful when it's value is
% zero, but this is already avoided in the "vertex.angle function"
tmp = vtx.angle(lv)./sin(vtx.angle(lv)) .* (u_ll-cos(vtx.angle(lv)).*u_l)./d_vec_l ...
    + vtx.angle(ls)./sin(vtx.angle(ls)) .* (u_r-cos(vtx.angle(ls)).*u_l)./d_vec_l ...
    - vtx.angle(ls)./sin(vtx.angle(ls)) .* (u_l-cos(vtx.angle(ls)).*u_r)./d_vec_r ...
    - vtx.angle(rv)./sin(vtx.angle(rv)) .* (u_rr-cos(vtx.angle(rv)).*u_r)./d_vec_r;

als = (1:2:vtx.numb)';
bls = (2:2:vtx.numb)';

vtx.f_bend(als,:) = prm.ap_bend .* tmp(als,:);
vtx.f_bend(bls,:) = prm.bs_bend .* tmp(bls,:);

%%{
if INIT_VER==3
    vtx.f_bend(1:2,1:2)=0;
    vtx.f_bend(vtx.initnumb-1:vtx.initnumb,1:2)=0;

%    vtx.f_bend(1:4,1:2)=0;
%    vtx.f_bend(vtx.initnumb-3:vtx.initnumb,1:2)=0;
end
%}

end