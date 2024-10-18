function [FR, FL] = Controller(targetVx, targetYawRate, vx, yawRate, timeStep, vxPrev, yawRatePrev, yawRateIntegral, vxIntegral, vehicle, RRTireMaxFx, RLTireMaxFx)
%CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

% Define controller gains
P = 2;
I = 0.5;
D = 2;

vxError      = targetVx - vx;
yawRateError = targetYawRate - yawRate;

vxErrorPrev      = vxPrev - targetVx;
yawRateErrorPrev = yawRatePrev - targetYawRate;

vxDerivativeError       = (vxError - vxErrorPrev)/timeStep;
yawRateDerivativeError  = (yawRateError - yawRateErrorPrev)/timeStep;

% Positive yaw rate -> left hand turn
% Negative yaw rate -> right hand turn 
yawMomentCommand = P * yawRateError + I * yawRateIntegral + D * yawRateDerivativeError;
deltaForce      = yawMoment2TorqueSplit(yawMomentCommand, RRTireMaxFx, RLTireMaxFx, vehicle);

axleForce     = (P * vxError + I * vxIntegral + D * vxDerivativeError)*vehicle.mass;

FR = min((axleForce + deltaForce)/2, RRTireMaxFx);
FL = min((axleForce - deltaForce)/2, RLTireMaxFx);
end

