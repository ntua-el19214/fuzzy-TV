function torque = MotorTorque(vehicle, motorSpeed, motorTorqueReq, torqueSplit)
% Maximum torque achievable by the motor
maxTorque = vehicle.Motors(motorSpeed);

torque = min(motorTorqueReq*torqueSplit, maxTorque*torqueSplit);

end
