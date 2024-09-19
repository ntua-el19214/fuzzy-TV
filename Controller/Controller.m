function [axleTorque, TorqueSplit] = Controller(targetVx, targetYawRate, vx, yawRate, timeStep, vxPrev, yawRatePrev, yawRateIntegral, vxIntegral)
%CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

% Define controller gains
P = 10;
I = 30;
D = 2;

vxError      = targetVx - vx;
yawRateError = targetYawRate - yawRate;

vxErrorPrev      = vxPrev - targetVx;
yawRateErrorPrev = yawRatePrev - targetYawRate;


end

