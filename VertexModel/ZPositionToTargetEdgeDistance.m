function edge = ZPositionToTargetEdgeDistance(cell, edge, flag)

d1=5.0; % [ƒÊm] maximum length
d2=1.0; % [ƒÊm] minimum length

if flag==1 % linear
    
    a_edge=cell.edge(:,3); % apical
    b_edge=cell.edge(:,1); % basal
    
    edge.target_dist(a_edge) = -(d1-d2)*cell.zpos'+ d1; % apical
    edge.target_dist(b_edge) = (d1-d2)*cell.zpos'+ d2; % apical
    
    % ’[‚Ì×–E‚ÉŠÖ‚µ‚Ä‚Íapical‚àbasal‚à•Ï‰»‚µ‚È‚¢B
    list=[cell.edge(1,1);cell.edge(1,3);cell.edge(cell.initnumb,1);cell.edge(cell.initnumb,3)];
    edge.target_dist(list)=edge.apical_original_length;
    
end

end