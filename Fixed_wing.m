%% Clear 
clc
clearvars
%% Data 
T = 35;                             % Air Temprature in C
T_K = 273+T;                        % Air Temprature in K
mu = 1.6603*10^-5;                  % Dynamic Viscosity Of Air
P=101325;                           % Atmospheric Pressure
gamma=1.4;
R=287;
rho=P/(R*T_K);                      % Air Denisty
a=sqrt(gamma*R*T_K);                % Speed Of Sound
g=9.8;                              % Gravity Of The Earth
%% Airplane Data
m=4.455;                            % Mass Of Airplane In Kg
W=m*g;                              % Weight Of Airplane In N
Ixx=0.532; Izz=0.985; Iyy=.474;
Ixy=0;
Ixz=0; Iyz=0;
I=[ Ixx Ixy Ixz;
    Ixy Iyy Iyz;
    Ixz Iyz Izz];
%% Wing Data
b=1.60;                             % Span Of The Wing
S=.48;                              % Wing Area
AR=5.333;                           % Aspect Ratio Of The Wing
V=15.5;                             % Velocity Of The Air 
Taper_ratio=1;                      % Taper Ratio
c=.3;                               % Chord Of The Wing
v=15.5;                               % Velocity of airplane
CL_3D=W/(.5*rho*v^2*S);             % Lift Cofficient 3D
CL_Max=1.7;                           % Max Lift Conditions 
L=.5*rho*v^2*CL_Max*S;              % Lift
V_Stall=sqrt((2*W)/(S*rho*CL_Max)); % Stall Velocity
 
%% Tail Data
V_Ht=0.75;                          % Volume Of Horizontal Tail
V_Vt=1;                             % Volume Of Vertical Tail
L_Ht=.8;                            % Arm Of Horizontal Tail
L_Vt=.8;                            % Arm Of Vertical Tail
S_Ht = V_Ht*c*S/L_Ht;               % Area Of Horizontal Tail  
Svt = V_Vt*b*S/L_Vt;                % Area Of Verical Tail
AR_Ht = 4;                          % Aspect Ratio Of Horizontal Tail  
b_Ht = sqrt(S_Ht*AR_Ht);            % Span Of Horizontal Tail
AR_Vt = 1.5;                        % Aspect Ratio Of Vertical Tail  
H_Vt = sqrt(AR_Vt*Svt);

%% Drag     
e=1/(1+.06);                        % Aswald Efficiency Factor           
K=1/(pi*AR*e);                      
CD_0=.022;                          % Zero Lift Drag
CD_l=CL_3D^2*K;                     % Lift Drag
CD=CD_l+CD_0;                       % Drag Cofficient
D=-.5*rho*v^2*CD*S;                 % Drag

%% Motors
b_m=1.645552813e-3;                               % Motor Thrust Cofficient
d_m=2.6675567e-3;                                 % Motor Torque Cofficient
no_of_motors=8;                                   % Motors Number

%% Longitudinal derivatives

%% Dimensional Stability Derivatives
Xu=-.027576;        Xw=1.4565;      
Zu=-5.7689;         Zw=-20.155;     Zq=-5.1172;
Mu=-.018759;        Mw=-.98618;     Mq=-1.8402;


%% Non-Dimensional Stability Derivatives
Cxu=-.062021;       Cxa=.32758;
Czu=.00096221;      
CLa=4.5329;         CLq=7.6727;
Cmu=-.014064;       Cma=-.73934;    Cmq=-9.1974;
%% Lateral Stability Derivatives
%% Dimensional Stability Derivatives
Yv=-2.1313;     Yp=.64879;          Yr=1.7005;
Lv=-.087827;    Lp=-2.4083;         Lr=1.1149;
Nv=1.5448;      Np=-1.0621;         Nr=-1.2416;
%% Non-Dimensional Stability Derivatives
Cyb=-.47936;    Cyp=.1824;          Cyr=.47808;
Clb=-.012346;   Clp=-.42316;        Clr=.1959;
Cnb=-.21715;     Cnp=-.18662;        Cnr=-.21817;

%% Matrix States
             %  u   v   w   p   q   r  
Matrix_states= [Xu  0   Xw  0   0   0   
                0   Yv  0   Yp  0   Yr  
                Zu  0   Zw  0   Zq  0
                0   Lv  0   Lp  0   Lr
                Mu  0   Mw  0   Mq  0
                0   Nv  0   Np  0   Nr];

V_cr=18;
AOA=3*pi/180;
u_0=V_cr*cos(AOA);
v_0=V_cr*sin(AOA);
w_0=sqrt(V_cr^2-u_0^2-v_0^2);
theta_0=AOA;
Z_0=20;
phi_0=0;
states_0=[u_0 v_0 w_0 0 0 0];
            % d_aileron        d_elevator      d_thrust        d_rudder
% Matrix_controls=[ 0             Xde             Xdth            0
%                   Yda           0               0               Ydr
%                   0             Zde             Zdth            0    
%                   Lda           0               0               Ldr
%                   0             Mde             Mdth            0
%                   Nda           0               0               Ndr];
%% Forces 
F_gravity_0=W*[sin(theta_0);-cos(theta_0)*sin(phi_0);-cos(theta_0)*cos(phi_0)];