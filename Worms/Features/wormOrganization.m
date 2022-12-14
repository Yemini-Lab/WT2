%% The worm morphology data.
%
%
% ? Medical Research Council 2012
% You will not remove any copyright or other notices from the Software; 
% you must reproduce all copyright notices and other proprietary 
% notices on any copies of the Software.

% The worm widths.
widths = struct( ...
    'head', headWidths, ...
    'midbody', midbodyWidths, ...
    'tail', tailWidths);

%% The worm morphology.
morphology = struct( ...
    'length', lengths, ...
    'width', widths, ....
    'area', areas, ...
    'areaPerLength', fatness, ...
    'widthPerLength', thickness);



%% The worm posture data.

% The worm posture bends.
headPosBends = struct( ...
    'mean', headPosMeanBends, ...
    'stdDev', headPosStdDevBends);
neckPosBends = struct( ...
    'mean', neckPosMeanBends, ...
    'stdDev', neckPosStdDevBends);
midbodyPosBends = struct( ...
    'mean', midbodyPosMeanBends, ...
    'stdDev', midbodyPosStdDevBends);
hipsPosBends = struct( ...
    'mean', hipsPosMeanBends, ...
    'stdDev', hipsPosStdDevBends);
tailPosBends = struct( ...
    'mean', tailPosMeanBends, ...
    'stdDev', tailPosStdDevBends);
postureBends = struct( ...
    'head', headPosBends, ...
    'neck', neckPosBends, ...
    'midbody', midbodyPosBends, ...
    'hips', hipsPosBends, ...
    'tail', tailPosBends);

% The worm amplitudes.
postureAmplitudes = struct( ...
    'max', maximumAmpPosture, ...
    'ratio', ratioAmpPosture);

% The worm wavelengths.
wavelengths = struct( ...
    'primary', wavelength1, ...
    'secondary', wavelength2);

% The worm coils.
coilFrames = struct( ...
    'start', coilStartFrames, ...
    'end', coilEndFrames, ...
    'time', coilTimes, ...
    'interTime', coilInterTimes, ...
    'interDistance', coilInterDistances);
coils = struct( ...
    'frames', coilFrames, ...
    'frequency', coilFrequency, ...
    'timeRatio', coilTimeRatio);

% The worm posture directions.
postureDirections = struct( ...
    'tail2head', tailToHeadDirection, ...
    'head', headPosDirection, ...
    'tail', tailPosDirection);

% The worm posture skeletons.
% Note: the orientation is from head to tail in the rows; row 1 is the
% head, the end row is the tail. Each frame is represented by a column.
postureSkeletons = struct( ...
    'x', postureXSkeletons, ...
    'y', postureYSkeletons);

% The worm eigen projections.
% Note: the eigen projections are oriented, by their contribution, in rows;
% row 1 accounts for the most variance. Each frame is represented by a
% column.
eigenProjections;

%% The worm posture.
posture = struct( ...
    'bends', postureBends, ...
    'amplitude', postureAmplitudes, ...
    'wavelength', wavelengths, ...
    'tracklength', trackLength, ...
    'eccentricity', eccentricity, ...
    'kinks', kinks, ...
    'coils', coils, ...
    'directions', postureDirections, ...
    'skeleton', postureSkeletons, ...
    'eigenProjection', eigenProjections);



%% The worm locomotion data.

% The worm forward motion.
forwardFrames = struct( ...
    'start', forwardStartFrames, ...
    'end', forwardEndFrames, ...
    'time', forwardTimes, ...
    'distance', forwardDistances, ...
    'interTime', forwardInterTimes, ...
    'interDistance', forwardInterDistances);
forwardRatios = struct( ...
    'time', forwardTimeRatio, ...
    'distance', forwardDistanceRatio);
forward = struct( ...
    'frames', forwardFrames, ...
    'frequency', forwardFrequency, ...
    'ratio', forwardRatios);

% The worm backward motion.
backwardFrames = struct( ...
    'start', backwardStartFrames, ...
    'end', backwardEndFrames, ...
    'time', backwardTimes, ...
    'distance', backwardDistances, ...
    'interTime', backwardInterTimes, ...
    'interDistance', backwardInterDistances);
backwardRatios = struct( ...
    'time', backwardTimeRatio, ...
    'distance', backwardDistanceRatio);
backward = struct( ...
    'frames', backwardFrames, ...
    'frequency', backwardFrequency, ...
    'ratio', backwardRatios);

% The worm paused motion.
pausedFrames = struct( ...
    'start', pausedStartFrames, ...
    'end', pausedEndFrames, ...
    'time', pausedTimes, ...
    'distance', pausedDistances, ...
    'interTime', pausedInterTimes, ...
    'interDistance', pausedInterDistances);
pausedRatios = struct( ...
    'time', pausedTimeRatio, ...
    'distance', pausedDistanceRatio);
paused = struct( ...
    'frames', pausedFrames, ...
    'frequency', pausedFrequency, ...
    'ratio', pausedRatios);

% The worm motion.
motion = struct( ...
    'mode', motionModes, ...
    'forward', forward, ...
    'backward', backward, ...
    'paused', paused);

% The worm velocity.
headTipVelocity = struct( ...
    'speed', headTipSpeed, ...
    'direction', headTipVelDirection);
headVelocity = struct( ...
    'speed', headSpeed, ...
    'direction', headVelDirection);
midbodyVelocity = struct( ...
    'speed', midbodySpeed, ...
    'direction', midbodyVelDirection);
tailVelocity = struct( ...
    'speed', tailSpeed, ...
    'direction', tailVelDirection);
tailTipVelocity = struct( ...
    'speed', tailTipSpeed, ...
    'direction', tailTipVelDirection);
velocity = struct( ...
    'headTip', headTipVelocity, ...
    'head', headVelocity, ...
    'midbody', midbodyVelocity, ...
    'tail', tailVelocity, ...
    'tailTip', tailTipVelocity);

% The worm locomotion bends.
foragingLocBends = struct( ...
    'amplitude', foragingAmpBends, ...
    'angleSpeed', foragingFreqBends);
headLocBends = struct( ...
    'amplitude', headAmpBends, ...
    'frequency', headFreqBends);
midbodyLocBends = struct( ...
    'amplitude', midbodyAmpBends, ...
    'frequency', midbodyFreqBends);
tailLocBends = struct( ...
    'amplitude', tailAmpBends, ...
    'frequency', tailFreqBends);
locomotionBends = struct( ...
    'foraging', foragingLocBends, ...
    'head', headLocBends, ...
    'midbody', midbodyLocBends, ...
    'tail', tailLocBends);

% The worm omega turns.
omegaFrames = struct( ...
    'start', omegaStartFrames, ...
    'end', omegaEndFrames, ...
    'time', omegaTimes, ...
    'interTime', omegaInterTimes, ...
    'interDistance', omegaInterDistances, ...
    'isVentral', isOmegaFramesVentral);

omegas = struct( ...
    'frames', omegaFrames, ...
    'frequency', omegaFrequency, ...
    'timeRatio', omegaTimeRatio);

% The worm upsilon turns.
upsilonFrames = struct( ...
    'start', upsilonStartFrames, ...
    'end', upsilonEndFrames, ...
    'time', upsilonTimes, ...
    'interTime', upsilonInterTimes, ...
    'interDistance', upsilonInterDistances, ...
    'isVentral', isUpsilonFramesVentral);
upsilons = struct( ...
    'frames', upsilonFrames, ...
    'frequency', upsilonFrequency, ...
    'timeRatio', upsilonTimeRatio);

% The worm locomotion turns.
locomotionTurns = struct( ...
    'omegas', omegas, ...
    'upsilons', upsilons);

% The worm locomotion path centroid coordinates.
centroidCoordinates = struct( ...
    'x', centroidXCoordinates, ...
    'y', centroidYCoordinates);

%% The worm locomotion.
locomotion = struct( ...
    'motion', motion, ...
    'velocity', velocity, ...
    'bends', locomotionBends, ...
    'turns', locomotionTurns);



%% The worm path data.

% The worm path duration.
pathArenaXYMin = struct( ...
    'x', pathArenaXMin, ...
    'y', pathArenaYMin);
pathArenaXYMax = struct( ...
    'x', pathArenaXMax, ...
    'y', pathArenaYMax);
pathArenaSize = struct( ...
    'height', pathArenaHeight, ...
    'width', pathArenaWidth, ...
    'min', pathArenaXYMin, ...
    'max', pathArenaXYMax);
wormDuration = struct( ...
    'indices', wormDurationIndices, ...
    'times', wormDurationTimes);
headDuration = struct( ...
    'indices', headDurationIndices, ...
    'times', headDurationTimes);
midbodyDuration = struct( ...
    'indices', midbodyDurationIndices, ...
    'times', midbodyDurationTimes);
tailDuration = struct( ...
    'indices', tailDurationIndices, ...
    'times', tailDurationTimes);
pathDuration = struct( ...
    'arena', pathArenaSize, ...
    'worm', wormDuration, ...
    'head', headDuration, ...
    'midbody', midbodyDuration, ...
    'tail', tailDuration);

%% The worm path.
wormPath = struct( ...
    'curvature', pathCurvature, ...
    'range', pathRange, ...
    'duration', pathDuration, ...
    'coordinates', centroidCoordinates);



%% The worm data.
worm = struct(...
    'morphology', morphology, ...
    'posture', posture, ...
    'locomotion', locomotion, ...
    'path', wormPath);
