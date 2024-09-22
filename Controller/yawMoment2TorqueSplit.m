function torqueSplit = yawMoment2TorqueSplit(yawMomentCommand)
%YAWMOMENT2TORQUESPLIT Summary of this function goes here
%   Detailed explanation goes here

% Arbitrary value
maxYawMomentCommand = 200;

% Calculate percentage of yaw moment, either positive, or negative
signYawMoment   = sign(yawMomentCommand);
% Torque split of 1 means 100% of power is sent to the outside wheel
torqueSplit     = signYawMoment * max(yawMomentCommand/maxYawMomentCommand, 1)/2; 

end

