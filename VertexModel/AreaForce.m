function vtx = AreaForce(cell,vtx)

% 180903 Area force calculation 

vl=cell.vtx;
[row col]=size(vl);

len=sum(vl~=0,2);
vid = sub2ind(size(vl), [1:cell.numb]', len); % (same) -> lid = (len-1)*cell.numb + i;

% v_next
v_next=circshift(vl,-1,2);
v_next(vid)=vl(:,1); % Še×–E‚Ì’†‚ÌÅŒã‚Ìvid‚ÉA‚Í‚¶‚ß‚Ìvid‚ğ“ü‚ê‚éB

% v_before
v_before=circshift(vl,1,2);
v_before(:,1)=vl(vid);

% Calculation of force at each vertex on cells
ga_x = reshape(vtx.pos(v_next,2)-vtx.pos(v_before,2), row, col) .* (vl>0);
ga_y = reshape(vtx.pos(v_before,1)-vtx.pos(v_next,1), row, col) .* (vl>0);

prm = repmat(cell.prm_area,1,col);
area = repmat(cell.area',1,col);
tararea = repmat(cell.target_area,1,col);

cfx = -prm .* ga_x.*(area - tararea);
cfy = -prm .* ga_y.*(area - tararea);

% Rearrange the vertices force for each vertex
vl1 = vl(:);
len1 = row*col;
i = [1:len1]';

vtabx = zeros(len1, vtx.numb);
vtaby = zeros(len1, vtx.numb);

ls = (vl1-1)*len1 + i;
cfx1=cfx(ls>0);
cfy1=cfy(ls>0);
ls1 = ls(ls>0);
vtabx(ls1) = cfx1;
vtaby(ls1) = cfy1;

vtx.f_area(1:vtx.numb,1)=sum(vtabx)';
vtx.f_area(1:vtx.numb,2)=sum(vtaby)';

end