function torque = MotorTorque(currentTime, throttle, vehicle, motorSpeed)
% Maximum torque achievable by the motor
maxTorque = vehicle.Motors(motorSpeed);
% Total ramp-up time in seconds
rampUpTime = 0.1;

if currentTime <= rampUpTime
    % Linearly interpolate the torque based on the current time
    torque = (maxTorque ./ rampUpTime) * currentTime * throttle;
else
    % After ramp-up time, the torque is capped at maxTorque
    torque = maxTorque * throttle;
end
end
