function deltaForce = yawMoment2TorqueSplit(yawMomentCommand, RRTireMaxFx, RLTireMaxFx, vehicle)
%YAWMOMENT2TORQUESPLIT Summary of this function goes here
%   Detailed explanation goes here

% Calculate percentage of yaw moment, either positive, or negative
% (positive -> left turn -> RR outside wheel)
% (negative -> right turn -> RL outside wheel)
signYawMoment   = sign(yawMomentCommand);
% calculate wheel force delta to achieve said 
deltaForce = min(signYawMoment * yawMomentCommand/vehicle.trackRear, max(RRTireMaxFx, RLTireMaxFx));

end

