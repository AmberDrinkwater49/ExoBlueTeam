% Human Arm Model: Shoulder-Elbow-Wrist with Connector
% Each segment length = 30 cm
% Elbow angle constrained between 45° and 180°
% Adds connector from shoulder to forearm (10 cm from elbow)

clear; clc; close all;

% Segment lengths (cm)
L1 = 30; % Shoulder to Elbow
L2 = 30; % Elbow to Wrist
connector_offset = 10; % Distance from elbow along forearm

% Shoulder position (fixed at origin)
shoulder = [0, 0];

% Create figure
figure;
axis equal;
axis([-70 70 -70 70]); % Set axis limits
grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
title('Dynamic Arm Model: Shoulder + Elbow Motion with Connector');

UpperArmLen = [];
ForearmLen = [];
ConnectorOff = [];
ConnectorLenLog = [];
Elbow_Angle = [];
Angle_Act_to_Sh = [];
Angle_Act_to_Wr = [];


% Loop through angles dynamically
for shoulder_angle = 315   % Fix shoulder angle (degrees) for demo
    for elbow_angle = 0:5:135   % Animate elbow bend (degrees, constrained)
        
        % Convert to radians
        sh_rad = deg2rad(shoulder_angle);
        el_rad = deg2rad(elbow_angle);
        
        % Upper arm vector (v1)
        upper_arm = [L1*cos(sh_rad), L1*sin(sh_rad)];
        
        % Elbow position (relative to shoulder)
        elbow = shoulder + upper_arm; 
        
        % Forearm vector (v2)
        forearm = [L2*cos(sh_rad + el_rad), L2*sin(sh_rad + el_rad)];
        
        % Wrist position (forearm rotates relative to upper arm)
        wrist = elbow + forearm;
        
        % Actuator (v3)
        actuator = [connector_offset*cos(sh_rad + el_rad), connector_offset*sin(sh_rad + el_rad)];
        
        % Point on forearm 10 cm away from elbow
        forearm_point = elbow + actuator;

        % Calculate angles between segments
        angleActToSh = rad2deg(acos(dot(elbow, forearm_point)/(norm(elbow)*norm(forearm_point)))); %v1 and v3
        angleActToWr = rad2deg(acos(dot(forearm_point, wrist)/(norm(forearm_point)*norm(wrist)))); %v2 and v3
                
        
        % Connector length (distance from shoulder to forearm point)
        connector_length = sqrt((forearm_point(1)-shoulder(1))^2 + ...
                                (forearm_point(2)-shoulder(2))^2);
        
        % Store table values
        UpperArmLen(end+1,1) = L1;
        ForearmLen(end+1,1) = L2;
        ConnectorOff(end+1,1) = connector_offset;
        ConnectorLenLog(end+1,1) = connector_length;
        Elbow_Angle(end+1,1) = 180 - elbow_angle;
        Angle_Act_to_Sh(end+1,1) = angleActToSh;
        Angle_Act_to_Wr(end+1,1) = angleActToWr;


        % Plot arm segments
        plot([shoulder(1) elbow(1)], [shoulder(2) elbow(2)], 'b-', 'LineWidth', 10); % Upper arm
        hold on;
        plot([elbow(1) wrist(1)], [elbow(2) wrist(2)], 'r-', 'LineWidth', 10); % Forearm
        
        % Plot connector
        plot([shoulder(1) forearm_point(1)], [shoulder(2) forearm_point(2)], ...
             'g--', 'LineWidth', 2); % Connector line
        
        % Plot joints
        plot(shoulder(1), shoulder(2), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
        plot(elbow(1), elbow(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        plot(wrist(1), wrist(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        plot(forearm_point(1), forearm_point(2), 'mo', 'MarkerSize', 6, 'MarkerFaceColor', 'm'); % Connector point
        
        % Display text annotations
        text(-65, 65, sprintf('Shoulder Angle = %d°', shoulder_angle), 'FontSize', 10, 'Color', 'b');
        text(-65, 60, sprintf('Elbow Angle = %d°', elbow_angle), 'FontSize', 10, 'Color', 'r');
        text(-65, 55, sprintf('Connector Length = %.2f cm', connector_length), 'FontSize', 10, 'Color', 'g');
        
        % Update title
        title(sprintf('Shoulder = %d°, Elbow = %d°', shoulder_angle, elbow_angle));
        
        % Pause for animation effect
        pause(0.2);
        
        % Clear for next frame
        hold off;
    end
end

T = table(UpperArmLen, ForearmLen, ConnectorOff, ConnectorLenLog, Elbow_Angle, Angle_Act_to_Sh, Angle_Act_to_Wr, 'VariableNames',{'Upper Arm Length', 'Forearm Length', 'Offset Distance from Elbow', 'Actuator Total Length', 'Elbow Angle', 'Angle Between Actuator and Shoulder', 'Angle Between Actuator and Forearm'});
disp(T);
%writetable(T, 'ArmSimulationResults.xlsx');