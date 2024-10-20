function dvdt = Dynamics(t, Y, Yprev, vehicle, steeringAngle, targetVx, targetYawRate, timeStep)
% DYNAMICS Describes all the dynamic equations needed to model a 4 Wheel 
% Vehicle with the Reduced nonlinear double-track method
% Declare integral variables for PID controller 
global yawRateIntegral vxIntegral; 
% Define Vector Values
vx      = Y(1);
vy      = Y(2);
yawRate = Y(3);
ax      = Y(4);
ay      = Y(5);
yawAcc  = Y(6);
omegaRR = Y(7);
omegaRL = Y(8);
distanceX = Y(9);
distanceY = Y(10);
thetaZ = Y(11);

g = 9.81;

% Calculate integral errors
yawRateIntegral = yawRateIntegral +  targetYawRate - yawRate;
vxIntegral      = vxIntegral + targetVx - vx;

%% Calculate forces 
% Vertical Wheel Forces
wheelForces.frontRight.Fz = vehicle.mass*g*vehicle.wd/2 + vehicle.CoGz*vehicle.mass*ay/2/vehicle.trackFront - vehicle.CoGz*vehicle.mass*ax/2/vehicle.wb     + 1/2*1/4*1.22*5.7*vx^2;
wheelForces.frontLeft.Fz  = vehicle.mass*g*vehicle.wd/2 - vehicle.CoGz*vehicle.mass*ay/2/vehicle.trackFront - vehicle.CoGz*vehicle.mass*ax/2/vehicle.wb     + 1/2*1/4*1.22*5.7*vx^2;
wheelForces.rearRight.Fz  = vehicle.mass*g*(1-vehicle.wd)/2 + vehicle.CoGz*vehicle.mass*ay/2/vehicle.trackFront + vehicle.CoGz*vehicle.mass*ax/2/vehicle.wb + 1/2*1/4*1.22*5.7*vx^2;
wheelForces.rearLeft.Fz   = vehicle.mass*g*(1-vehicle.wd)/2 - vehicle.CoGz*vehicle.mass*ay/2/vehicle.trackFront + vehicle.CoGz*vehicle.mass*ax/2/vehicle.wb + 1/2*1/4*1.22*5.7*vx^2;

% Wheel speeds
speedRR = (vx + yawRate*vehicle.trackRear/2);
speedRL = (vx - yawRate*vehicle.trackRear/2);

%% Calculate slip ratios
slipFR = 0;
slipFL = 0;

% Calculate RR slip ratio
if abs(omegaRR * vehicle.Reff) < 0.3
    slipRR = 2 * (omegaRR * vehicle.Reff - speedRR) / (0.3 + speedRR^2 / 0.3);
else
    slipRR = (omegaRR * vehicle.Reff - speedRR) / abs(speedRR);
end

% Calculate RL slip ratio
if abs(omegaRL * vehicle.Reff) < 0.3
    slipRL = 2 * (omegaRL * vehicle.Reff - speedRL) / (0.3 + speedRL^2 / 0.3);
else
    slipRL = (omegaRL * vehicle.Reff - speedRL) / abs(speedRL);
end

% Calculate slip angles
slipAngleFR = atan((vy + vehicle.wb * (1-vehicle.wd) * yawRate)/(vx + vehicle.trackFront/2*yawRate)) - steeringAngle;
slipAngleFL = atan((vy + vehicle.wb * (1-vehicle.wd) * yawRate)/(vx - vehicle.trackFront/2*yawRate)) - steeringAngle;
slipAngleRR = atan((vy - vehicle.wb * vehicle.wd * yawRate)/(vx + vehicle.trackRear/2*yawRate));
slipAngleRL = atan((vy - vehicle.wb * vehicle.wd * yawRate)/(vx - vehicle.trackRear/2*yawRate));

% Longitudinal Wheel Forces
wheelForces.frontRight.Fx = F_longit(slipAngleFR, slipFR, wheelForces.frontRight.Fz, deg2rad(-0.5));
wheelForces.frontLeft.Fx  = F_longit(slipAngleFL, slipFL, wheelForces.frontLeft.Fz, deg2rad(-0.5));
wheelForces.rearRight.Fx  = F_longit(slipAngleRR, slipRR, wheelForces.rearRight.Fz, deg2rad(-0.5));
wheelForces.rearLeft.Fx   = F_longit(slipAngleRL, slipRL, wheelForces.rearLeft.Fz, deg2rad(-0.5));

% Lateral Wheel Forces
wheelForces.frontRight.Fy = F_lateral(slipAngleFR, slipFR, wheelForces.frontRight.Fz, deg2rad(-0.5));
wheelForces.frontLeft.Fy  = F_lateral(slipAngleFL, slipFL, wheelForces.frontLeft.Fz, deg2rad(-0.5));
wheelForces.rearRight.Fy  = F_lateral(slipAngleRR, slipRR, wheelForces.rearRight.Fz, deg2rad(-0.5));
wheelForces.rearLeft.Fy   = F_lateral(slipAngleRL, slipRL, wheelForces.rearLeft.Fz, deg2rad(-0.5));

% Self Aligning wheel moments (Placeholder)
wheelForces.frontRight.Mz = 0;
wheelForces.frontLeft.Mz  = 0;
wheelForces.rearRight.Mz  = 0;
wheelForces.rearLeft.Mz   = 0;

%% Form Equation System
% Wheel longitudinal force matrix
wheelFxMatrix = [wheelForces.frontRight.Fx;...
                 wheelForces.frontLeft.Fx ;...
                 wheelForces.rearRight.Fx ;...
                 wheelForces.rearLeft.Fx];
% Wheel lateral force matrix
wheelFyMatrix = [wheelForces.frontRight.Fy;...
                 wheelForces.frontLeft.Fy ;...
                 wheelForces.rearRight.Fy ;...
                 wheelForces.rearLeft.Fy];

% Wheel self aligning torque 
wheelMzMatrix = [wheelForces.frontRight.Mz;...
                 wheelForces.frontLeft.Mz ;...
                 wheelForces.rearRight.Mz ;...
                 wheelForces.rearLeft.Mz];

steerAngle = [steeringAngle;...
              steeringAngle;...
              0            ;...
              0];

% Y-Axis Distance of wheels from the CoG
halfTrack = [-vehicle.trackFront/2;...
              vehicle.trackFront/2;...
             -vehicle.trackRear/2 ;...
              vehicle.trackRear/2];

% X-Axis Distance of wheels from the CoG
xDistCoG = [ vehicle.wb * (1-vehicle.wd);...
             vehicle.wb * (1-vehicle.wd);...
            -vehicle.wb * vehicle.wd;...
            -vehicle.wb * vehicle.wd];

% Equation system
tempFxVector = wheelFxMatrix.*cos(steerAngle) - wheelFyMatrix.*sin(steerAngle);
tempFyVector = wheelFyMatrix.*cos(steerAngle) + wheelFxMatrix.*sin(steerAngle);

% Longitudinal Acceleration
accelX  = sum(tempFxVector)/vehicle.mass + yawRate.*vy - 0.5*1.22*1.2*vx^2/vehicle.mass;
% Lateral Acceleration
accelY  = sum(tempFyVector)/vehicle.mass - yawRate.*vx;
% Yaw acceleration
accelJz = (sum(wheelMzMatrix) + sum(tempFyVector.*xDistCoG) + sum(tempFxVector.*halfTrack))/vehicle.InertiaZ;

% Define dummy motor torques (placeholders)
% TmotorRight = MotorTorque(t, 0.2, vehicle, omegaRR*vehicle.GR) * vehicle.GR; % Nm 
% TmotorLeft = MotorTorque(t, 0.2, vehicle, omegaRL*vehicle.GR) * vehicle.GR;  % Nm 

vxPrev      = Yprev(1);
yawRatePrev = Yprev(3);

% Calculate torque requests
RRTireMaxF = vehicle.TireMaxFx(slipAngleRR, wheelForces.rearRight.Fz);
RLTireMaxF = vehicle.TireMaxFx(slipAngleRL, wheelForces.rearLeft.Fz);
[FxR, FxL] = Controller(targetVx, targetYawRate, vx, yawRate, timeStep, vxPrev, yawRatePrev, yawRateIntegral, vxIntegral,vehicle, RRTireMaxF, RLTireMaxF);

% Rear wheel driven only
TmotorRight = MotorTorque(vehicle, omegaRR*vehicle.GR, FxR, RRTireMaxF) * vehicle.GR;  % Nm 
TmotorLeft  = MotorTorque(vehicle, omegaRL*vehicle.GR, FxL, RLTireMaxF) * vehicle.GR;  % Nm 

% Rear wheel angular accelaration
accelJwRR = (TmotorRight - wheelForces.rearRight.Fx * vehicle.Reff )/vehicle.Jw;
accelJwRL = (TmotorLeft - wheelForces.rearLeft.Fx * vehicle.Reff )/vehicle.Jw;

% Update distanceX, distanceY, and thetaZ
distanceX_dot = vx * cos(thetaZ) - vy * sin(thetaZ);
distanceY_dot = vx * sin(thetaZ) + vy * cos(thetaZ);
thetaZ_dot = yawRate;

dvdt = [ax; ay; yawAcc; accelX; accelY; accelJz ; accelJwRR; accelJwRL; distanceX_dot; distanceY_dot; thetaZ_dot];
end
