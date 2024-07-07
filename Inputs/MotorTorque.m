function value = MotorTorque(currentTime, throttle)
% Check if currentTime is within the totalTime
if currentTime <= 0.1
    % Linearly interpolate the value based on the current time
    value = (50 / 0.1) * currentTime*throttle;
else
    % If currentTime exceeds totalTime, the value is capped at maxValue
    value = 50*throttle;
end
end

