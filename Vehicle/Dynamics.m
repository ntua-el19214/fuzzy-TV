function output = Dynamics(t, vector, vehicle, steeringAngle)
%DYNAMICS Describes all the dynamic equations needed to model a 4 Wheel 
% Vehicle with the Reduced nonlinear double-track method

% Positive rotation is defined by the right hand rule

%% Calculate forces


%% Form Equation System
% Wheel lognitudinal force matrix
wheelFxMatrix = [vehicle.wheels.frontRight.Fx;...
                 vehicle.wheels.frontLeft.Fx ;...
                 vehicle.wheels.RearRight.Fx ;...
                 vehicle.wheels.RearLeft.Fx];
% Wheel lateral force matrix
wheelFyMatrix = [vehicle.wheels.frontRight.Fy;...
                 vehicle.wheels.frontLeft.Fy ;...
                 vehicle.wheels.RearRight.Fy ;...
                 vehicle.wheels.RearLeft.Fy];

% Wheel self aligning torque 
wheelMzMatrix = [vehicle.wheels.frontRight.Mz;...
                 vehicle.wheels.frontLeft.Mz ;...
                 vehicle.wheels.RearRight.Mz ;...
                 vehicle.wheels.RearLeft.Mz];

steerAngle    = [steeringAngle;...
                 steeringAngle;...
                 0            ;...
                 0            ];

halfTrack     = [-vehicle.trackFront/2;...
                  vehicle.trackFront/2;...
                 -vehicle.trackFront/2;...
                  vehicle.trackFront/2];

xDistCoG     =  [ vehicle.wb * (1-vehicle.wd);...
                  vehicle.wb * (1-vehicle.wd);...
                 -vehicle.wb * (1-vehicle.wd);...
                 -vehicle.wb * (1-vehicle.wd)];

% Equation system
tempFxVector = wheelFxMatrix.*cos(steerAngle) - wheelFyMatrix.*sin(steerAngle);
tempFyVector = wheelFyMatrix.*cos(steerAngle) + wheelFxMatrix.*sin(steerAngle);

vehicle.sigmaFx = sum(tempFxVector);
vehicle.sigmaFy = sum(tempFyVector);
vehicle.sigmaMz = sum(wheelMzMatrix) + sum(tempFyVector.*xDistCoG) + sum(tempFxVector.*halfTrack);
end

