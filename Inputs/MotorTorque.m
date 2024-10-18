function torque = MotorTorque(vehicle, motorSpeed, Fx_Request, TireMaxForce)
% Maximum torque achievable by the motor
maxTorque = vehicle.Motors(motorSpeed);

torque = max(Fx_Request/TireMaxForce*maxTorque,0);
end
