% Dummy script to test the Dynamics function
% global slipAnglesMatrix;
% slipAnglesMatrix = [];
%% Define a dummy vehicle structure
vehicle.mass = 270; % kg
vehicle.wd = 0.5; % weight distribution (percentage of mass on the front axle)
vehicle.trackFront = 1.24; % m (track width at the front)
vehicle.trackRear = 1.24; % m (track width at the rear)
vehicle.wb = 1.57; % m (wheelbase)
vehicle.CoGz = 0.3; % m (height of center of gravity)
vehicle.Reff = 0.2; % m (effective radius of the wheels)
vehicle.InertiaZ = 200; % kg.m^2 (yaw inertia)
vehicle.Jw = 0.06; % kg.m^2 (wheel inertia)

%% Define initial conditions for the state vector
% [vx, vy, yawRate, ax, ay, yawAcc, omegaRR, omegaRL, distanceX, distanceY, thetaZ]
initialState = [0.01; 0; 0; 0; 0; 0; 0.01/vehicle.Reff; 0.01/vehicle.Reff; 0; 0; 0];

tspan = [0 6];
% Define the steering angle as a sinusoidal input
steeringInput =@(t) 0.1*sin(t / 5);

% Call the ODE solver
[t, result, slipAnglesMatrix] = ode45(@(t, vector) Dynamics(t, vector, vehicle, steeringInput(t)), tspan, initialState);

%% Plot the results
figure;

% Velocities and Yaw Rate
subplot(3, 2, 1);
plot(t, result(:, 1), 'DisplayName', 'vx'); hold on;
plot(t, result(:, 2), 'DisplayName', 'vy');
plot(t, result(:, 3), 'DisplayName', 'yawRate');
xlabel('Time (s)');
ylabel('Velocity (m/s), Yaw Rate (rad/s)');
title('Velocities and Yaw Rate');
legend;

% Accelerations
subplot(3, 2, 2);
plot(t, result(:, 4), 'DisplayName', 'ax'); hold on;
plot(t, result(:, 5), 'DisplayName', 'ay');
plot(t, result(:, 6), 'DisplayName', 'yawAcc');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2), Yaw Acc (rad/s^2)');
title('Accelerations');
legend;

% Rear Wheel Angular Speeds
subplot(3, 2, 3);
plot(t, result(:, 7), 'DisplayName', 'omegaRR'); hold on;
plot(t, result(:, 8), 'DisplayName', 'omegaRL');
xlabel('Time (s)');
ylabel('Angular Speed (rad/s)');
title('Rear Wheel Angular Speeds');
legend;

% Distance X
subplot(3, 2, 4);
plot(t, result(:, 9), 'DisplayName', 'Distance X');
xlabel('Time (s)');
ylabel('Distance (m)');
title('Distance X');
legend;

% Distance Y
subplot(3, 2, 5);
plot(t, result(:, 10), 'DisplayName', 'Distance Y');
xlabel('Time (s)');
ylabel('Distance (m)');
title('Distance Y');
legend;

% Yaw Angle
subplot(3, 2, 6);
plot(t, result(:, 11), 'DisplayName', 'Yaw Angle');
xlabel('Time (s)');
ylabel('Angle (rad)');
title('Yaw Angle');
legend;
