function [xxx] = calibrate_nx(nx)

MATpars = [30       0.0283      0.725     0.4           1      -0.25        0.1];

choosecase=1;  
indexcase = 1;

per=6;                         % Periods per year, equal to 1/DELTA in attached notes
bold=MATpars(choosecase,1);    % Elasticity of process innovation cost (controls 1/elasticity of growth rate -- see attached notes)
annualr=MATpars(choosecase,2); % Annual interest rate; 
lambda=MATpars(choosecase,5);  % Share of labor in production of research good
nx = nx;      % Export fixed cost
anndelta=0.02;               % Annual depreciation rate;
sigma=0.25;                    % Std.Dev of shocks to productivity;
rho=3.17;                         % Elasticity of substitution; 

slope=MATpars(choosecase,6);   % Calibrated slope of employment-based distribution for large firms -- choose to match slope for 1000-5000 firms 
shtrade=0.1063;                 % Calibrated share of trade in output;
shNT=MATpars(choosecase,4);    % Calibrated share of employment of exporters; 

%newDratio=0.9995;               % Ratio of new to old D , 0.9995 is the value we use when we consider a small change
newDratio=0.90;                % "Large change" (maximum to guarantee convergence under b=10)
%newDratio=0.7;                % "Larger change" (maximum to guarantee convergence under b=30)

dotransition=1;                % 1 to compute the transition dynamics  -- note that computing this can take around 4 hours

z0=0;                          % z of entrants; 
L=1;                           % Labor force
n=1;                           % Entry cost 
nf=MATpars(choosecase,7);      % Fixed cost of operation;

T=floor(1000*per^0.5);         % Grid size: 2*T+1 
tol=1e-7;                      % Tolerance in convergence
periodmass=round(5000*per);    % Number of iterations when computing Statinoary Distributions
pertran=round(3000*per^0.5);   % Number of periods in transition dynamics

% Other parameters
r=(1+annualr)^(1/per)-1;       % Interest Rate 
delta=1-(1-anndelta)^(1/per);  % Period probability of exogenous death
beta=1/(1+r);                  % Discount factor

s=sigma/per^0.5;                     % Compute discrete step of progress/regress relative to trend. See attached note.
yy=exp((slope-1)*s);                 % See attached notes on this         
qcal=1/(1-yy^2)*(yy/(1-delta)-yy^2); % Calibrate q for large firms to match slope of firm size distribution

b=bold*2*s*per;                      % Make this adjustment so that elasticity of growth rate to incentives to innovate does not depend on per (see note)

D_1_rho=shtrade/shNT/(1-shtrade/shNT);  % D^(1-rho) chosen to match export share given employment share of exporters

grid=[-(T-1):1:(T-1)]';

vecemployD=exp(z0+s*grid);          % Normalized employment

disp(' ')
% disp(['Parameter values: primitive b = ',num2str(bold),' , r = ',num2str(annualr),' , lambda = ',num2str(lambda),' , per = ',num2str(per),' , target employ share of exp = ',num2str(shNT),' , target slope large firms = ',num2str(slope)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2- Computing the Initial and final steady States %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calib=1;
Pars=[per annualr n delta nx z0 T b bold nf rho lambda L beta qcal s];         
H0=0; V0=0; Pid0=0.5;    % Initial guesses for H0, V0 and Pid0 (V0 will not be used in the initial steady state)
[H,ZSS0,ZZSS0,MSS0,YSS0,wSS0,LPSS0,CSS0,XSS0,NTnoDSS0,NNSS0,VxSS0,VSS0,veczSS0,vecqSS0,shareYexpSS0,...
    shareNexpSS0,shareYexphybSS0,PidSS0,FSS0,employ500,StorevarsSS0]=...
    Steady(Pars,grid,periodmass,D_1_rho,calib,H0,V0,Pid0,vecemployD,0,indexcase);  % Initial Steady State

xxx = shareNexpSS0;