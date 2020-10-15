function [cell, kappa, dist] = CellCurvature(cell, INIT_VER, flag)

% flag, 1: angle based, 2: spline based
if flag==1
    a=cell.cell(:,1);
    o=[1:cell.numb]';
    b=cell.cell(:,2);
    
    if INIT_VER==1
        vec1=cell.pos(o,:)-cell.pos(a,:);
        vec2=cell.pos(b,:)-cell.pos(o,:);
    else
        a(1)=1; b(cell.initnumb)=cell.initnumb; % dummy
        pos1=cell.pos(a,:); pos2=cell.pos(b,:);
        pos1(1,:)=[-1 0]; pos2(cell.initnumb,:)=[100 0];
        vec1=cell.pos(o,:)-pos1;
        vec2=pos2-cell.pos(o,:);
    end
    
    dist1=sqrt(sum(vec1.*vec1,2));
    dist2=sqrt(sum(vec2.*vec2,2));
    
    sn=(vec1(:,1).*vec2(:,2)-vec1(:,2).*vec2(:,1));
    theta=dot(vec1./dist1,vec2./dist2,2);
    cell.curv=-sign(sn).*acos(theta);
    
    if INIT_VER==3
        cell.curv(1)=0; cell.curv(cell.initnumb)=0;
    end
    
elseif flag==2
    % This version is based on a spline-curvature calculation.
    % Added on 200314
    
    if INIT_VER>=3
        % step 0: make cell list in a linear chain order from left to right
        cid=cell.initnumb;
        clist=zeros(cell.initnumb,1);
        clist(1)=cid;
        for c=2:cell.numb
            nbcid = cell.cell(cid,1);
            clist(c)=nbcid;
            cid=nbcid;
        end
        
        % no need this step any more! (step 1: take 3 cells and get angles
        % for the rotate when calculating the curvature)
        %{
        list_l=circshift(clist,1); list_l(1)=[]; list_l(end)=[];
        list_r=circshift(clist,-1); list_r(1)=[]; list_r(end)=[];
        cvec = cell.pos(list_r,1:2) - cell.pos(list_l,1:2);
        dist = sqrt(sum(cvec.*cvec,2));
        ncvec = cvec./dist;
        %}
        
        % step 2: Spline to Curvature
        
        for i=1:cell.numb-2
            
            % 2-1: move to origin
            tmp = [clist(i) clist(i+1) clist(i+2)];
            ptx = cell.pos(tmp,1) - cell.pos(tmp(1),1);
            pty = cell.pos(tmp,2) - cell.pos(tmp(1),2);
            x = ptx(2);
            y = pty(2);
            
            % 2-2: Rotate and
            vecx=ptx(3)-ptx(1);
            vecy=pty(3)-pty(1);
            theta = atan2(vecy, vecx);
            
            T=[cos(theta) sin(theta);-sin(theta) cos(theta)];
            mat=[ptx';pty'];
            rot1=T*mat;
            rot2=T*[x;y];
            
            ptx=rot1(1,:);
            pty=rot1(2,:);
            x=rot2(1,1);
            
            pp = spline(ptx,pty);
            a = pp.coefs(:,1);
            b = pp.coefs(:,2);
            c = pp.coefs(:,3);
            
            upper=(6*a*(x - ptx(1)) + 2*b);
            lower=power(1 + power(3*a*power(x - ptx(1),2) + 2*b.*(x - ptx(1)) + c, 2), 1.5);
            
            cell.curv(clist(i+1)) = - upper/lower;
        end
        
        % step 3: curvature 0 at boundary cells
        cell.curv(1)=0.0;
        cell.curv(cell.initnumb)=0.0;
        
        
        % step 4: curvature sorted from the edge
        kappa=cell.curv(clist);
        %        kappa2 = smooth(kappa,30);
        %        figure, plot(kappa2)
        
        cell_x=cell.pos(clist,1);
        cell_y=cell.pos(clist,2);
        dist(1)=0;
        dist(2:cell.numb) = cumsum(sqrt(diff(cell_x).^2 + diff(cell_y).^2));
        
    elseif INIT_VER==1
        % step 1: make a cell list in a chain order
        cid=1;
        clist=zeros(cell.initnumb,1);
        clist(1)=cid;
        
        for c=2:cell.numb
            nbcid = cell.cell(cid,2);
            clist(c)=nbcid;
            cid=nbcid;
        end
        
        % step 1.5: add on clist
        clist(end+1:end+2)=[clist(1);clist(2)];
        
        % step 2: Spline to Curvature
        for i=1:cell.numb
            
            % 2-1: move to origin
            tmp = [clist(i) clist(i+1) clist(i+2)];
            ptx = cell.pos(tmp,1) - cell.pos(tmp(1),1);
            pty = cell.pos(tmp,2) - cell.pos(tmp(1),2);
            x = ptx(2);
            y = pty(2);
            
            % 2-2: Rotate and
            vecx=ptx(3)-ptx(1);
            vecy=pty(3)-pty(1);
            theta = atan2(vecy, vecx);
            
            T=[cos(theta) sin(theta);-sin(theta) cos(theta)];
            mat=[ptx';pty'];
            rot1=T*mat;
            rot2=T*[x;y];
            
            ptx=rot1(1,:);
            pty=rot1(2,:);
            x=rot2(1,1);
            
            pp = spline(ptx,pty);
            a = pp.coefs(:,1);
            b = pp.coefs(:,2);
            c = pp.coefs(:,3);
            
            upper=(6*a*(x - ptx(1)) + 2*b);
            lower=power(1 + power(3*a*power(x - ptx(1),2) + 2*b.*(x - ptx(1)) + c, 2), 1.5);
            
            cell.curv(clist(i+1)) = upper/lower;
        end
        
        % step 4: curvature sorted from the edge
        kappa= cell.curv(clist);
        %        kappa2 = smooth(kappa,30);
        %        figure, plot(kappa2)
        
    end
    
    
end

end