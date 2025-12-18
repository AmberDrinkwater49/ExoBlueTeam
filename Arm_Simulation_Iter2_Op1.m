% Arm Model with Connector Constraint (Min + Max)
% Upper arm and forearm = 30 cm
% Connector attaches 6 cm from shoulder and 10 cm from elbow
% Connector length must be between 29.24 and 44.48 cm
% Original line thickness and animation speed

clear; clc; close all;

% Segment lengths (cm)
L1 = 30; % Shoulder to Elbow
L2 = 30; % Elbow to Wrist

% Connector attachment offsets
connector_offset_elbow = 10; % From elbow along forearm
connector_offset_shoulder = 4; % From shoulder along upper arm

% Connector constraints
min_connector_length = 29.24;
max_connector_length = 44.48;

% Shoulder position (fixed)
shoulder = [0, 0];

% Create figure
figure;
axis equal;
axis([-80 80 -80 80]);
grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
title('Arm Model with Dual-Offset Connector Constraints');

% Loop through angles
for shoulder_angle = 315
    for elbow_angle = 0:5:135
        
        % Convert to radians
        sh_rad = deg2rad(shoulder_angle);
        el_rad = deg2rad(elbow_angle);
        
        % Elbow position
        elbow = shoulder + [L1*cos(sh_rad), L1*sin(sh_rad)];
        
        % Wrist position
        wrist = elbow + [L2*cos(sh_rad + el_rad), L2*sin(sh_rad + el_rad)];
        
        % Connector point on forearm (10 cm from elbow)
        forearm_point = elbow + [connector_offset_elbow*cos(sh_rad + el_rad), ...
                                 connector_offset_elbow*sin(sh_rad + el_rad)];
        
        % Connector point on upper arm (6 cm from shoulder)
        shoulder_connector_point = shoulder - ...
                                   [connector_offset_shoulder*cos(sh_rad), ...
                                    connector_offset_shoulder*sin(sh_rad)];
        
        % Connector length
        connector_length = sqrt((forearm_point(1)-shoulder_connector_point(1))^2 + ...
                                (forearm_point(2)-shoulder_connector_point(2))^2);
        
        % Apply constraints
        if connector_length < min_connector_length || connector_length > max_connector_length
            continue;
        end
        
        % Clear frame
        cla;
        
        % Plot upper arm
        plot([shoulder(1) elbow(1)], [shoulder(2) elbow(2)], 'b-', 'LineWidth', 3);
        hold on;
        
        % Plot forearm
        plot([elbow(1) wrist(1)], [elbow(2) wrist(2)], 'r-', 'LineWidth', 3);
        
        % Plot connector
        plot([shoulder_connector_point(1) forearm_point(1)], ...
             [shoulder_connector_point(2) forearm_point(2)], ...
             'g--', 'LineWidth', 2);
        
        % Plot joints and connector points
        plot(shoulder(1), shoulder(2), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
        plot(elbow(1), elbow(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        plot(wrist(1), wrist(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        plot(forearm_point(1), forearm_point(2), 'mo', 'MarkerSize', 6, 'MarkerFaceColor', 'm');
        plot(shoulder_connector_point(1), shoulder_connector_point(2), ...
             'co', 'MarkerSize', 6, 'MarkerFaceColor', 'c');
        
        % Title update
        title(sprintf('Shoulder = %d°, Elbow = %d°', shoulder_angle, elbow_angle));
        
        % Original animation speed
        pause(0.5);
    end
end