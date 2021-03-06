%% Demo 2: Segmentation of an acoustic mixture with background noise
%
% This script demonstrates the usage of the Segmentation Knowledge Source
% with the blackboard system for a mixture of 3 sound sources with
% additional background noise in anechoic conditions. The acoustic scene 
% contains three speakers at 30°, 0° and -30°. The background noise is 
% simulated as diffuse white noise.
%
% AUTHOR:
%   Christopher Schymura (christopher.schymura@rub.de)
%   Cognitive Signal Processing Group
%   Ruhr-Universitaet Bochum
%   Universitaetsstr. 150, 44801 Bochum


% Initialize Binaural Simulator
sim = simulator.SimulatorConvexRoom('test_scene_noise.xml');

% Suppress simulator messages
set(sim, 'Verbose', false);

% Set look direction to zero degrees
sim.rotateHead(0, 'absolute');

% Initialize simulation
set(sim, 'Init', true);

% Initialize Blackboard System
bbs = BlackboardSystem(false);
bbs.setRobotConnect(sim);
bbs.buildFromXml('segmentation_blackboard_noise.xml');

% Start Blackboard System and run simulation
bbs.run();

% Shut down simulation
set(sim, 'ShutDown', true);

% Get segmentation results and plot them
hypotheses = bbs.blackboard.data.values;

figure(1)
% Get background noise hypothesis (first hypothesis element)
softMask = hypotheses{end}.segmentationHypotheses(1).softMask;

% Get number of frames/channels and compute time and frequency-scales
[nFrames, nChannels] = size(softMask);
timescale = linspace(0, sim.LengthOfSimulation, nFrames);
freqscale = 1 : nChannels;

subplot (2, 2, 1)
imagesc(timescale, freqscale, softMask');
set(gca, 'YDir', 'normal');
axis square;
colorbar;
caxis([0, 1]);
xlabel('Time / [s]');
ylabel('Channel index');
title('Estimated soft mask for background noise.')

% Plot results for sound sources
for k = 2 : 4
    % Get hypotheses for current source
    softMask = hypotheses{end}.segmentationHypotheses(k).softMask;
    position = hypotheses{end}.sourceAzimuthHypotheses(k - 1).sourceAzimuth;
    
    % Convert position from [rad] to [deg]
    position = position * 180 / pi;
    
    % Get number of frames/channels and compute time and frequency-scales
    [nFrames, nChannels] = size(softMask);
    timescale = linspace(0, sim.LengthOfSimulation, nFrames);
    freqscale = 1 : nChannels;
    
    subplot (2, 2, k)
    imagesc(timescale, freqscale, softMask');
    set(gca, 'YDir', 'normal');
    axis square;
    colorbar;
    caxis([0, 1]);
    xlabel('Time / [s]');
    ylabel('Channel index');
    title(['Estimated soft mask for source at ', num2str(position), '°.'])
end
