% Dummy script to test the Dynamics function

% Add files to current path
addpath(genpath('./'))

% Define the time span and number of steps
a = 0;
b = 4;
N = 100000;

timeStep = (b-a)/N;
% Define the Butcher tableau for a 4th-order Runge-Kutta method (example)
A = [0 0 0 0;
     0.5 0 0 0;
     0 0.5 0 0;
     0 0 1 0];
bhta = [1/6; 1/3; 1/3; 1/6];
tau = [0; 0.5; 0.5; 1];

% Define a dummy vehicle structure
vehicle.mass = 270;         % kg
vehicle.wd = 0.5;           % weight distribution (percentage of mass on the front axle)
vehicle.trackFront = 1.24;  % m (track width at the front)
vehicle.trackRear = 1.24;   % m (track width at the rear)
vehicle.wb = 1.57;          % m (wheelbase)
vehicle.CoGz = 0.3;         % m (height of center of gravity)
vehicle.Reff = 0.2;         % m (effective radius of the wheels)
vehicle.InertiaZ = 73.1250; % kg.m^2 (yaw inertia)
vehicle.Jw = 0.06;          % kg.m^2 (wheel inertia)
vehicle.GR = 15;            % Gear ratio
vehicle.Motors = Motors('AMK-FSAE Motors Data.xlsx');

% Define initial conditions for the state vector
% [vx, vy, yawRate, ax, ay, yawAcc, omegaRR, omegaRL, distanceX, distanceY, thetaZ]
initialState = [10; 0; 0; 0; 0; 0; 10 / vehicle.Reff; 10 / vehicle.Reff; 0; 0; 0];

% Define Input
steeringInput = deg2rad(20);
targetVx      = 15;
targetYawRate = 0;

global yawRateIntegral vxIntegral;
yawRateIntegral = 0;
vxIntegral      = 0;
% Call the RKESys function
F = @(t, Y, Yprev, vehicle, steeringAngle, targetVx, targetYawRate, timeStep)...
    Dynamics(t, Y, Yprev, vehicle, steeringInput, targetVx, targetYawRate, timeStep);

[t, result, ax] = RKESys(a, b, N, F, initialState, A, bhta, tau, vehicle, steeringInput, targetVx, targetYawRate, timeStep);

% Plot the results
figure;

% Velocities and Yaw Rate
subplot(3, 2, 1);
plot(t, result(1, :), 'DisplayName', 'vx'); hold on;
plot(t, result(2, :), 'DisplayName', 'vy');
plot(t, result(3, :), 'DisplayName', 'yawRate');
xlabel('Time (s)');
ylabel('Velocity (m/s), Yaw Rate (rad/s)');
title('Velocities and Yaw Rate');
legend;

% Accelerations
subplot(3, 2, 2);
plot(t, result(4, :), 'DisplayName', 'ax'); hold on;
plot(t, result(5, :), 'DisplayName', 'ay');
plot(t, result(6, :), 'DisplayName', 'yawAcc');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2), Yaw Acc (rad/s^2)');
title('Accelerations');
legend;

% Rear Wheel Angular Speeds
subplot(3, 2, 3);
plot(t, result(7, :), 'DisplayName', 'omegaRR'); hold on;
plot(t, result(8, :), 'DisplayName', 'omegaRL');
xlabel('Time (s)');
ylabel('Angular Speed (rad/s)');
title('Rear Wheel Angular Speeds');
legend;

% Distance X
subplot(3, 2, 4);
plot(t, result(9, :), 'DisplayName', 'Distance X');
xlabel('Time (s)');
ylabel('Distance (m)');
title('Distance X');
legend;

% Distance Y
subplot(3, 2, 5);
plot(t, result(10, :), 'DisplayName', 'Distance Y');
xlabel('Time (s)');
ylabel('Distance (m)');
title('Distance Y');
legend;

% Yaw Angle
subplot(3, 2, 6);
plot(t, result(11, :), 'DisplayName', 'Yaw Angle');
xlabel('Time (s)');
ylabel('Angle (rad)');
title('Yaw Angle');
legend;

% % Plot steering angle
% figure('Name','Steering Angle')
% plot(t, steeringInput(t))
% xlabel('Time [s]')
% ylabel('Steering Angle [deg]')

% Figure, attempt to plot trajectory 
tp = theaterPlot;
view(14,50)
trajPlotter = trajectoryPlotter(tp,DisplayName="Trajectories");
plotTrajectory(trajPlotter,{[result(9,:)',result(10,:)', zeros(N+1,1)]})
