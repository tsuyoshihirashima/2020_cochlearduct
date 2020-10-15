function vtx = VertexAngle(vtx, flag, INIT_VER)

if flag==1
    lst=[1:2:vtx.numb]';
elseif flag==2
    lst=[2:2:vtx.numb]';
elseif flag==3
    lst=[1:vtx.numb]';
end
   
nb1=vtx.vtx(lst,1); % vertex on the right side from the center
nb2=vtx.vtx(lst,3); % vertex on the left side from the center

if INIT_VER==1
    vec1=vtx.pos(lst,:)-vtx.pos(nb1,:);
    vec2=vtx.pos(nb2,:)-vtx.pos(lst,:);
else
    nb1(1:2)=1; nb2(vtx.initnumb-1:vtx.initnumb)=1; % dummy
    pos1=vtx.pos(nb1,:);
    pos2=vtx.pos(nb2,:);
    pos1(1,1:2)=[-1 -1]; pos1(2,1:2)=[-1 1];
    pos2(vtx.initnumb-1,1:2)=[1000 -1]; pos2(vtx.initnumb,1:2)=[1000 1];
    
    vec1=vtx.pos(lst,:)-pos1;
    vec2=pos2-vtx.pos(lst,:);
end

dist1=sqrt(sum(vec1.*vec1,2));
dist2=sqrt(sum(vec2.*vec2,2));

nvec1 = vec1./dist1;
nvec2 = vec2./dist2;

vtx.angle(lst) = acos( dot(nvec1,nvec2,2) );
vtx.angle(find(vtx.angle==0))=0.001; % 190505 added for avoiding errors in "bending force"

if INIT_VER==3
    vtx.angle(1:2)=0.001*normrnd(0,1,[2,1]);
    vtx.angle(vtx.initnumb-1:vtx.initnumb)=0.001*normrnd(0,1,[2,1]);
end

%% normal vector
sn=(nvec1(:,1).*nvec2(:,2)-nvec1(:,2).*nvec2(:,1));

norm_vec = sign(sn).*(nvec1 - nvec2);
vtx.n_norm_vec = norm_vec ./ sqrt(sum(norm_vec.*norm_vec,2));

if INIT_VER==3
    vtx.n_norm_vec(1:2,1:2)=0;
    vtx.n_norm_vec(vtx.initnumb-1:vtx.initnumb,1:2)=0;
end


end