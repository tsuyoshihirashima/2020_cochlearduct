%% erk1d.m
% This program was used for Figure S4 (2020, Ishii et al., eLife)
% Credits: Tsuyoshi Hirashima at Kyoto University
% hirashima.tsuyoshi.2m (at) kyoto-u.ac.jp

%% Clear all memories and graphs
clear
close all

TYPE=0; % 1: coupling, 0: uncoupling

%% Parameters
CELL_NUMB=200;
TIME_MAX=1512;
DT=0.01;
L=5; % Ideal distance between neighboring cells

k=20; % 4 [nN] in 2012, Serra-Picamal et al.)

leading_F=6; % 4[nN] -- (2012, Serra-Picamal et al.)
lambda=leading_F*1.5;

alpha=3; % determined as the strain curve

tau_C=40; % 9.2 [nN.min/É m] -- (2012, Serra-Picamal et al.)
tau_E=30; % [min] -- 
tau_F=10; % [min] -- 

% uncoupling parameter
E_width=84; % 84 [É m]
E_vel=0.42*1; % 0.42 [É m/min]
%

%% Initial condition
x=[0:CELL_NUMB-1]*L; %- initial position of cells
dxdt=zeros(1,CELL_NUMB);
strain = diff(x)/L -1;
ERK=zeros(1,CELL_NUMB-1);
F=zeros(1,CELL_NUMB-1);

%% Setting misc.
tmax=TIME_MAX*round(1/DT);
y(1:CELL_NUMB)=0; % for figure
fig_x_range=CELL_NUMB*L*1.5;
fig_y_range=fig_x_range*0.05;

t_interval=2; % [min]

cnt=1;
prev_x=x;
prev_strain=strain;
prev_ERK=ERK;

tspan=0:DT:1;

i=[0:10000];
% ----- pattern 1 %
%syntERK=sin(i/E_width*pi); syntERK(find(syntERK<0))=0.0;
% ----- pattern 2 %
syntERK=0.5*(sin(i/E_width*pi)+1);

%% Dynamics
for t=1:tmax
    
    % for Figure
    if mod(t,round(t_interval/DT))==0
        
        if mod(t,round(t_interval/DT*10))==0
            disp(t*DT)
        end
        
        vel(cnt,1:CELL_NUMB) = (x - prev_x)/t_interval;
        X(cnt,1:CELL_NUMB)=(x+prev_x)*0.5;
        Y(cnt,1:CELL_NUMB)=t*DT;
        
        kymo_erk(cnt,1:CELL_NUMB-1)=ERK;
        strain_rate(cnt,1:CELL_NUMB-1)=(strain - prev_strain)/t_interval;
        ERK_rate(cnt,1:CELL_NUMB-1)=(ERK-prev_ERK)/t_interval;
        
        cnt=cnt+1;
        
        prev_x=x;
        prev_strain=strain;
        prev_ERK=ERK;
        
        % Graph for spring dynamics
        %{
        plot(x', y','o-')
        xlim([0 fig_x_range])
        ylim([-fig_y_range fig_y_range])
        daspect([1 1 1])
        pause(0.1)
        %}
    end
    
    % Calculation of strain
    strain = diff(x)/L -1;

    
    % ODE calculation using the Euler method
    if TYPE==1
        dERKdt = (tanh(alpha*strain) - ERK)/tau_E;
    elseif TYPE==0
        e_tip=round((CELL_NUMB-1)*L-t*DT*E_vel);
        tmp_x = round(x - e_tip);
        list=find(tmp_x>0);
        if numel(list)>1
            list(end)=[];
            ERK(list)=syntERK(tmp_x(list));
            ERK(1:list(1)-1)=0.0;
        end
    end
     
    % ver.1
%    tmp=(ERK>=ERK_thre);
%    dFdt = (lambda*tmp - F)/tau_F;
    
    % ver.2
    dFdt = (lambda*ERK - F)/tau_F;
    
    dxdt(2:CELL_NUMB-1) = (F(2:CELL_NUMB-1) + k/L * (x(3:CELL_NUMB) + x(1:CELL_NUMB-2) ...
        - 2*x(2:CELL_NUMB-1)))/tau_C;
    dxdt(1) = 0; % fixed
    dxdt(CELL_NUMB) = (leading_F - k/L * (x(CELL_NUMB) - x(CELL_NUMB-1) - L) )/tau_C; % free
    
    if TYPE==1
        ERK = ERK + dERKdt*DT;
    end
    F = F + dFdt*DT;
    x = x + dxdt*DT;
    
end


%% Graph
XX=X(:,2:end);
YY=Y(:,2:end);
vel(:,1)=[];

figure,
subplot(2,2,1)
surf(XX,YY,kymo_erk,'EdgeColor','none')
%xlim([CELL_NUMB*10/2 CELL_NUMB*10/2*3])
%xlim([0 max(XX(:))])
%xlim([max(XX(:))-337 max(XX(:))])
xlim([CELL_NUMB*L-152 CELL_NUMB*L+85])
ylim([10 TIME_MAX-100])
caxis([0 .6])
%caxis([0 .4])
%caxis([min(kymo_erk(:)) max(kymo_erk(:))])
view([0 270])
colormap(jet)
colorbar
set(gca,'Color','k')

%figure,
subplot(2,2,2)
surf(XX,YY,ERK_rate,'EdgeColor','none')
%xlim([CELL_NUMB*10/2 CELL_NUMB*10/2*3])
%xlim([0 max(XX(:))])
%xlim([max(XX(:))-337 max(XX(:))])
xlim([CELL_NUMB*L-152 CELL_NUMB*L+85])
ylim([10 TIME_MAX-100])
caxis([-0.01 0.01])
%caxis([0 .4])
%caxis([min(kymo_erk(:)) max(kymo_erk(:))])
view([0 270])
colormap(jet)
colorbar
set(gca,'Color','k')


%figure,
subplot(2,2,3)
surf(XX,YY,vel,'EdgeColor','none')
%xlim([(CELL_NUMB-1)*L max(XX(:))])
%xlim([0 max(XX(:))])
%xlim([max(XX(:))-337 max(XX(:))])
xlim([CELL_NUMB*L-152 CELL_NUMB*L+85])
ylim([10 TIME_MAX-100])

caxis([0 0.2])
view([0 270])
colormap(jet)
colorbar
set(gca,'Color','k')

%figure,
subplot(2,2,4)
surf(XX,YY,strain_rate,'EdgeColor','none')
%xlim([CELL_NUMB*10/2 CELL_NUMB*10/2*3])
%xlim([0 max(XX(:))])
%xlim([max(XX(:))-337 max(XX(:))])
xlim([CELL_NUMB*L-152 CELL_NUMB*L+85])
ylim([10 TIME_MAX-100])
caxis([-0.002 0.002])
view([0 270])
colormap(jet)
colorbar
set(gca,'Color','k')

%% additional
[row col]=size(X);
xmin=930; xmax=950;
for i=1:row
    tmp=X(i,:);
    list=find(xmin<tmp & tmp<xmax);
    
    erk_t(i)=mean(ERK_rate(i,list));
    strain_t(i)=mean(strain_rate(i,list));
end

t_start=200;

strain_t2=smooth(strain_t(t_start:end));
erk_t2=smooth(erk_t(t_start:end),20);

figure,
subplot(2,1,1)
plot(erk_t(t_start:end),'--')
hold on
plot(erk_t2,'r')
hold off

subplot(2,1,2)
plot(strain_t(t_start:end),'--')
hold on
plot(strain_t2,'r')
hold off

[acor,lag] = xcorr(zscore(strain_t2), zscore(erk_t2),'coeff');
figure,
plot(lag*t_interval,acor)
xlim([-240 240])

disp('lag time=')
disp(lag(find(max(acor)==acor))*t_interval)

