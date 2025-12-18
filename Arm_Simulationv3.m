% Arm Model with Connector Constraint
% Upper arm and forearm = 30 cm
% Connector from shoulder to forearm point (10 cm from elbow)
% Restrict motion so connector length >= 29.24 cm
% Original line thickness and animation speed

clear; clc; close all;

% Segment lengths (cm)
L1 = 30; % Shoulder to Elbow
L2 = 30; % Elbow to Wrist
connector_offset = 10; % Distance from elbow along forearm
min_connector_length = 29.24; % Minimum allowed connector length

% Shoulder position (fixed at origin)
shoulder = [0, 0];

% Create figure
figure;
axis equal;
axis([-80 80 -80 80]); % Set axis limits
grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
title('Arm Model with Connector Constraint');

% UpperArmLen = [];
% ForearmLen = [];
% ConnectorOff = [];
% ConnectorLenLog = [];
% Elbow_Angle = [];
% Angle_Act_to_Sh = [];
% Angle_Act_to_Wr = [];

% Loop through angles dynamically
for shoulder_angle = 315   % Fix shoulder angle (degrees) for demo
    for elbow_angle = 0:5:135   % Animate elbow bend (degrees, constrained)
        
        % Convert to radians
        sh_rad = deg2rad(shoulder_angle);
        el_rad = deg2rad(elbow_angle);
        
        % Elbow position (relative to shoulder)
        elbow = shoulder + [L1*cos(sh_rad), L1*sin(sh_rad)];
        
        % Wrist position (forearm rotates relative to upper arm)
        wrist = elbow + [L2*cos(sh_rad + el_rad), L2*sin(sh_rad + el_rad)];
        
        % Point on forearm 10 cm away from elbow
        forearm_point = elbow + [connector_offset*cos(sh_rad + el_rad), ...
                                 connector_offset*sin(sh_rad + el_rad)];
        
        % Connector length (distance from shoulder to forearm point)
        connector_length = sqrt((forearm_point(1)-shoulder(1))^2 + ...
                                (forearm_point(2)-shoulder(2))^2);
        
        % Apply constraint: skip frames where connector < minimum length
        if connector_length < min_connector_length
            continue; % Skip this angle
        end
        
        % Clear figure for each frame
        cla;
        
        % Plot arm segments (original thickness)
        plot([shoulder(1) elbow(1)], [shoulder(2) elbow(2)], 'b-', 'LineWidth', 3); % Upper arm
        hold on;
        plot([elbow(1) wrist(1)], [elbow(2) wrist(2)], 'r-', 'LineWidth', 3); % Forearm
        
        % Plot connector
        plot([shoulder(1) forearm_point(1)], [shoulder(2) forearm_point(2)], ...
             'g--', 'LineWidth', 2); % Connector line
        
        % Plot joints
        plot(shoulder(1), shoulder(2), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
        plot(elbow(1), elbow(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        plot(wrist(1), wrist(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        plot(forearm_point(1), forearm_point(2), 'mo', 'MarkerSize', 6, 'MarkerFaceColor', 'm'); % Connector point
        
        % Update title with current angles
        title(sprintf('Shoulder = %d°, Elbow = %d°', shoulder_angle, elbow_angle));
        
        % Original animation speed
        pause(0.1);
    end
end