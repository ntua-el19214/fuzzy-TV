% Dummy script to test the Dynamics function

% Define a dummy vehicle structure
vehicle.mass = 270; % kg
vehicle.wd = 0.5; % weight distribution (percentage of mass on the front axle)
vehicle.trackFront = 1.24; % m (track width at the front)
vehicle.trackRear = 1.24; % m (track width at the rear)
vehicle.wb = 1.57; % m (wheelbase)
vehicle.CoGz = 0.3; % m (height of center of gravity)
vehicle.Reff = 0.2; % m (effective radius of the wheels)
vehicle.InertiaZ = 200; % kg.m^2 (yaw inertia)
vehicle.Jw = 0.06; % kg.m^2 (wheel inertia)

% Define initial conditions for the state vector
% [vx, vy, yawRate, ax, ay, yawAcc, omegaRR, omegaRL]
initialState = [0.01; 0; 0; 0; 0; 0; 0.01/vehicle.Reff; 0.01/vehicle.Reff];

tspan = [0 5];

% Define the steering angle as a sinusoidal input
steeringInput = @(t) 0.5 * sin(2*t);

% Call the ODE solver
[t, result] = ode45(@(t, vector) Dynamics(t, vector, vehicle, steeringInput(t)), tspan, initialState);

% Plot the results
% Plot the results
figure;
subplot(3, 1, 1);
plot(t, result(:, 1), 'DisplayName', 'vx'); hold on;
plot(t, result(:, 2), 'DisplayName', 'vy');
plot(t, result(:, 3), 'DisplayName', 'yawRate');
xlabel('Time (s)');
title('Velocities and Yaw Rate');
legend;

subplot(3, 1, 2);
plot(t, result(:, 4), 'DisplayName', 'ax'); hold on;
plot(t, result(:, 5), 'DisplayName', 'ay');
plot(t, result(:, 6), 'DisplayName', 'yawAcc');
xlabel('Time (s)');
title('Accelerations');
legend;

subplot(3, 1, 3);
plot(t, result(:, 7), 'DisplayName', 'omegaRR'); hold on;
plot(t, result(:, 8), 'DisplayName', 'omegaRL');
xlabel('Time (s)');
title('Rear Wheel Angular Speeds');
legend;
