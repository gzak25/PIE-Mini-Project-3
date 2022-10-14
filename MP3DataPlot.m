% Script for collecting data from, and creating a plot from our MP3
% line-follower robot


% % % Initialize serial and collect data into this script (adapted from
% % % sample "matlabArduino-2021-updated-by-students.m" file

clear s
clf 

% Choose which port to use for Arduino (hardcode based on what port it 
% mentions in the arduino IDE)
ports = 'COM9';

baudrate = 9600;
s = serialport(ports, baudrate);

% Initialize a timeout in case MATLAB can't connect to the arduino and to
% recognize when the arduino is done sending data.
timeout = 0;    

% Initialize a matrix to store the data read from the arduino
scanData = [];

% Main loop to read and store data from the Arduino
while timeout < 5       % Check if data was received
% % % %     Do I include the below?
%    write(s, 1, 'uint8'); % Send signal to the Arduino to begin running it's firmware
   while s.NumBytesAvailable > 0
       %
       % reset timeout
       %
       timeout = 0;
       % 
       % Store the data coming in from the arduino scan in a matrix called
       % scanData
       % 
       scanData = [scanData ; readline(s)];
   end
    pause(1);
    timeout = timeout + 1;
end
%%
% Convert the stored data form strings into usable matrix int data 
numData = []; % Establish a matrix to contain data once it is in int form

for i = 1:height(scanData)
    % Remove the "begin" initialization message sent by the arduino and
    % print it
%    if i == 1
%       disp(scanData(i))
%       continue 
%    end
   
   % Convert the data into int form, and store in the numData matrix
   numData = [numData ; eval(scanData(i))];
end
%%
% Generate time stamps for plot (reverse engineered)
messageLength = 17; % Each message is 17 typical normal characters, so 17 bytes
mesLenBits = messageLength * 8; % Convert message length to bits

% Baud rate is 9600 for our serial communication
mesPerSec = 9600/mesLenBits;
timeBetweenMes = 1/mesPerSec;

TFinal = height(numData) * timeBetweenMes;
timeVect = 0:timeBetweenMes:(TFinal - timeBetweenMes);

% Attach timeVect to numData
totalData = [timeVect' numData];
% Structure of totalData:
% Column 1 - Time
% Column 2 - Left Motor Speed
% Column 3 - Right Motor Speed
% Column 4 - Left Sensor Reading
% Column 5 - Right Sensor Reading
%%
% Generate plots
clf 
hold off

% Plot for left motor speed
plot(totalData(:, 1), totalData(:, 2));

% Plot for the right motor speed
plot(totalData(:, 1), totalData(:, 3));

% Plot for the left sensor readings
plot(totalData(:, 1), totalData(:, 4));

% Plot for the right sensor readings
plot(totalData(:, 1), totalData(:, 5));

% Superimposed plot
% % % Include a line of the threshold for the the sensor values?
clf
hold on
title('Sensor Data and Commanded Motor Speeds over Short Trial Run')
xlabel('Time (seconds)')

yyaxis left
ylim([-10, 40]);
ylabel('Commanded Motor Speed (RPM)')
plot(totalData(:, 1), totalData(:, 2), 'y');
plot(totalData(:, 1), totalData(:, 3), 'b');

yyaxis right
ylabel('Sensor Readings (mV)')
ylim([90, 650]);
plot(totalData(:, 1), totalData(:, 4), 'r');
% plot(totalData(:, 1), totalData(:, 5), 'g');

legend('Left Motor Speed','Right Motor Speed','Left Sensor Reading','Right Sensor Reading')