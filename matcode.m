clc
close all
clear all

% default plotting style
fs = 16;    % font size
ms = 10;    % marker size
lw = 2;     % line width

% Load data from CSV file 
[datafile,pathname] = uigetfile('*.xls','Pick data file');
if isequal(datafile,0)
    return
end
cd(pathname)
if exist('datafile','var') && ~isempty(datafile)
    disp(['File: ',datafile])
end			
s = importdata([pathname datafile],',',2);
t = s.data(:,1);    % Time (sec)
%T = s.data(:,2:11);  % Disc temperatures (C)
T = s.data(:,2:5);    % Sphere temperatures (C)

%% Plot the the data
figure
T_i = 60;
T_inf = 29;
theta = (T - T_inf)./(T_i - T_inf);
semilogy(t,theta,'linewidth',lw)
legend('Steel center','Steel surface','Copper center','Copper surface')
set(gca,'FontSize',fs-2);
xlabel('Time (sec)','Fontsize',fs)
ylabel('\theta','Fontsize',fs)

%% Fit the copper sphere cooling curves
figure
T_inf = 30.3;
T_i = 61.2;
r = 0.023875;   % radius (m)
V = (4/3)*pi*r^3;
As = 4*pi*r^2;
h = 1000;
rho = 8933; % kg/m^3
cp = 385;   % J/kgK
tau = rho*cp*V/(h*As);  % timne constant (sec)
T_copper = T_inf + (T_i-T_inf)*exp(-t/tau);
t_offset = 0; % eliminate unwanted data recorded initially
plot(t(1:10:end)-t_offset,T(1:10:end,3),'ro','linewidth',lw,'markersize',ms)
hold on
plot(t(1:10:end),T_copper(1:10:end),'linewidth',lw)
title('Copper sphere cooling','Fontsize',fs)
xlabel('Time (sec)','Fontsize',fs)
ylabel('Temperature (\circC)','Fontsize',fs)
cell = cellstr(num2str(h, 'h = %d W/m^2K'));
legend(['Center temperature',cell])
set(gca,'FontSize',fs-2);

%%
% Steel sphere cooling curves
t_offset = 0; % eliminate unwanted data recorded initially
figure
plot(t(1:10:end)-t_offset,T(1:10:end,1),'ro','linewidth',lw,'markersize',ms)    % plot the center data
hold on
plot(t(1:10:end)-t_offset,T(1:10:end,2),'bs','linewidth',lw,'markersize',ms)    % plot the edge data

h = 2700;   % adjustable guess for h   
rho = 8238; % kg/m^3
cp = 468;   % J/kgK
k = 13.4;   % W/mK
alpha = k./(rho*cp);
Bi = h*r/k;
r = 0.023875;   % radius (m)
V = (4/3)*pi*r^3;
As = 4*pi*r^2;
tau = rho*cp*V/(h*As);  % lumped time constant

% Find the first 15 series terms
clear lambda lambda_new
lambda = linspace(0,50,1000000);
% plot(lambda/pi,cot(lambda))
% hold on
% plot(lambda/pi,(1-Bi)./lambda)
% break
tol = 1e-4;
lambda = lambda(abs(cot(lambda) - (1-Bi)./lambda) < tol);  % find intersections, text book eq (5.51c)
j = 1;  % index for temporary lambda vector
for i = 1:length(lambda) - 1    % remove duplicates
    if abs(lambda(i)-lambda(i+1)) > tol
        lambda_new(j) = lambda(i);
        j = j+1;
    end
end
lambda = lambda_new;
A = 2*(sin(lambda) - lambda.*cos(lambda))./(lambda - sin(lambda).*cos(lambda)); % text book eq (5.51b)
f = sin(0.8*lambda)./(0.8*lambda);    % position function f at the surface r = 0.8*ro (thermo couple location)
Fo = alpha*t/r^2;
T_center_model = ones(size(t)); % pre-allocate
T_surface_model = ones(size(t));
for i = 1:length(t)
    T_center_model(i) = T_inf+(T_i-T_inf)*sum(A.*exp(-lambda.^2*Fo(i)));
    T_surface_model(i) = T_inf+(T_i-T_inf)*sum(A.*exp(-lambda.^2*Fo(i)).*f);
end
plot(t,T_center_model,'r','linewidth',lw)   % plot the model
plot(t,T_surface_model,'b','linewidth',lw)   % plot the model
xlim([0 max(t)])
title('Steel sphere cooling','Fontsize',fs)
xlabel('Time (sec)','Fontsize',fs)
ylabel('Temperature (\circC)','Fontsize',fs)
legend('Center data','Surface data','Center model', 'Surface model')
set(gca,'FontSize',fs-2);






