% Arm Model with Connector Constraint (Min + Max)
% Upper arm and forearm = 30 cm
% Connector from shoulder to forearm point (10 cm from elbow)
% Restrict motion so connector length is between 29.24 and 44.48 cm
% Original line thickness and animation speed

clear; clc; close all;

% Segment lengths (cm)
L1 = 30; % Shoulder to Elbow
L2 = 30; % Elbow to Wrist
connector_offset = 10; % Distance from elbow along forearm

% Connector constraints
min_connector_length = 29.24; 
max_connector_length = 44.48;

% Shoulder position (fixed at origin)
shoulder = [0, 0];

% Create figure
figure;
axis equal;
axis([-80 80 -80 80]); % Set axis limits
grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
title('Arm Model with Connector Constraints');

% Loop through angles dynamically
for shoulder_angle = 315   % Fix shoulder angle (degrees)
    for elbow_angle = 0:5:135   % Animate elbow bend
        
        % Convert to radians
        sh_rad = deg2rad(shoulder_angle);
        el_rad = deg2rad(elbow_angle);
        
        % Elbow position
        elbow = shoulder + [L1*cos(sh_rad), L1*sin(sh_rad)];
        
        % Wrist position
        wrist = elbow + [L2*cos(sh_rad + el_rad), L2*sin(sh_rad + el_rad)];
        
        % Point on forearm 10 cm from elbow
        forearm_point = elbow + [connector_offset*cos(sh_rad + el_rad), ...
                                 connector_offset*sin(sh_rad + el_rad)];
        
        % Connector length
        connector_length = sqrt((forearm_point(1)-shoulder(1))^2 + ...
                                (forearm_point(2)-shoulder(2))^2);
        
        % Apply BOTH constraints
        if connector_length < min_connector_length || connector_length > max_connector_length
            continue; % Skip this configuration
        end
        
        % Clear figure
        cla;
        
        % Plot arm segments
        plot([shoulder(1) elbow(1)], [shoulder(2) elbow(2)], 'b-', 'LineWidth', 3); % Upper arm
        hold on;
        plot([elbow(1) wrist(1)], [elbow(2) wrist(2)], 'r-', 'LineWidth', 3); % Forearm
        
        % Plot connector
        plot([shoulder(1) forearm_point(1)], [shoulder(2) forearm_point(2)], ...
             'g--', 'LineWidth', 2);
        
        % Plot joints
        plot(shoulder(1), shoulder(2), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
        plot(elbow(1), elbow(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        plot(wrist(1), wrist(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        plot(forearm_point(1), forearm_point(2), 'mo', 'MarkerSize', 6, 'MarkerFaceColor', 'm');
        
        % Update title
        title(sprintf('Shoulder = %d°, Elbow = %d°', shoulder_angle, elbow_angle));
        
        % Original animation speed
        pause(0.1);
    end
end