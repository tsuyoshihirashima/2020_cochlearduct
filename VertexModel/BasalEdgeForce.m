function vtx = BasalEdgeForce(edge,vtx,flag)

%% Basal extension/constriction
% find the basal edges and affiliated vertices
els=find(edge.type==3);
vl1=edge.vtx(els,1);
vl2=edge.vtx(els,2);

fx = zeros(vtx.numb, vtx.numb);
fy = zeros(vtx.numb, vtx.numb);

if flag==1
    % fx行列のvl2行、vl1列にf(:,1)とf(:,2)の数値をいれる
    f = -((vtx.pos(vl1,:)-vtx.pos(vl2,:)))./edge.dist(els) .* edge.prm_edge(els);
elseif flag==2
    % fx行列のvl2行、vl1列にf(:,1)とf(:,2)の数値をいれる
    f = -((vtx.pos(vl1,:)-vtx.pos(vl2,:))) .* (1-edge.target_dist(els)./edge.dist(els)) .* edge.prm_edge(els);
end

vid1 = (vl1-1)*vtx.numb + vl2;
fx(vid1) = f(:,1);
fy(vid1) = f(:,2);

% fx行列のvl1行、vl2列にf(:,1)とf(:,2)の数値をいれる
vid2 = (vl2-1)*vtx.numb + vl1;
fx(vid2) = fx(vid2) - f(:,1);
fy(vid2) = fy(vid2) - f(:,2);

vtx.f_basaledge(1:vtx.numb,1) = sum(fx)';
vtx.f_basaledge(1:vtx.numb,2) = sum(fy)';

end