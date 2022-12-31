clc;
clear;
% Measurement and Control HW-2, Ömer Faruk CANBAZ

% Please read here, In this assignment, arduino uno and ky-037 sound sensor 
% are used to display both analog and digital signals.

% Define Variables
counter2Max= 3000;
counter1Max = 1000;
cntrlVal = 0;
totalVal=0;
calValue=0;
currValue=0;
constantVal = 22;
% define external hardware(arduino uno is used for this code) 
% this arduino function is from arduino matlab support package
arduIdentfy=arduino('COM3' ,'Uno');

% here we make a one turn loop, we will use this loop to average
if cntrlVal == 0
    for counter1 = 1:counter1Max:1
currValue(counter1) = readVoltage(arduIdentfy,'A0'); % we assign the current value
totalVal(counter1) = totalVal(counter1) + currValue(counter1); % do necessary operations to find the total value 
calValue(counter1) = totalVal(counter1) / counter1Max; % divide the total value by the number of measurements
fprintf("%f\n\n",calValue);
    end
cntrlVal = 1;
end


for counter2=1:counter2Max
analogVoltage(counter2)= readVoltage(arduIdentfy,'A0'); % Measures voltage on pin A0
digitalVoltage(counter2) = readDigitalPin(arduIdentfy,'D8'); % Reads the value on pin A0
pause(0.05); % delay
analogVoltage(counter2) = analogVoltage(counter2) - calValue(counter1); %subtract the calibration value from the current value

% IMPORTANT NOTE: 
% The sensor never makes 0 measurement due to non-ideal world conditions , sensor noise and low quality of the sensor. 
% Therefore, for digital signals, situations where the analog signal is greater than 0.5 are selected as reference.

if analogVoltage(counter2) < 0.5
    digitalVoltage(counter2) = 0;
end
 
fprintf('voltage=%f \n',analogVoltage(counter2));
fprintf('Digitalvoltage=%f \n',digitalVoltage(counter2));
plot(analogVoltage,'b');
set(gca,'color',[0,0,0]);
ylim([-2 5]); % Since the sensor does not take any minus value, 
% the limits are specified in this way so that the graph can be examined easily.
hold on;
title("Analog and Digital Signal & Ossiloscope");
ylabel("Voltage");
xlabel("number of measurements");
plot(digitalVoltage,'y');
drawnow;
end