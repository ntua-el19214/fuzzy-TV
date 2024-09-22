function [axleTorque, torqueSplit] = Controller(targetVx, targetYawRate, vx, yawRate, timeStep, vxPrev, yawRatePrev, yawRateIntegral, vxIntegral)
%CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

% Define controller gains
P = 3;
I = 5;
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
torqueSplit      = yawMoment2TorqueSplit(yawMomentCommand);

axleTorque     = P * vxError + I * vxIntegral + D * vxDerivativeError;

end

