function worm2histogram(filename, wormFiles, varargin)
%WORM2HISTOGRAM Convert worm features to their histogram.
%
%   WORM2HISTOGRAM(FILENAME, WORMFILES)
%
%   WORM2HISTOGRAM(FILENAME, WORMFILES, CONTROLFILES)
%
%   WORM2HISTOGRAM(FILENAME, WORMFILES, CONTROLFILES, VERBOSE)
%
%   WORM2HISTOGRAM(FILENAME, WORMFILES, CONTROLFILES, VERBOSE,
%                  STARTTIME, ENDTIME)
%
%   WORM2HISTOGRAM(FILENAME, WORMFILES, CONTROLFILES, VERBOSE,
%                  STARTTIME, ENDTIME, PROGFUNC, PROGSTATE)
%
%   Inputs:
%       filename     - the file name for the histograms;
%                      the file includes:
%
%                      wormInfo    = the worm information
%                      worm        = the worm histograms
%                      controlInfo = the control information (if it exists)
%                      worm        = the control histograms (if they exist)
%
%       wormFiles    - the feature files to use for the worm
%       controlFiles - the feature files to use for the control;
%                      if empty, the worm has no control
%       isVerbose    - verbose mode display the progress;
%                      the default is no (false)
%       startTime    - the start time (in seconds) for the data to use
%                      if empty, start at the first data point
%       endTime      - the end time (in seconds) for the data to use
%                      if empty, end at the last data point
%       progFunc     - a function to update on the progress
%       progState    - a state for the progress function
%
%       Note: the progress function signature should be
%
%       FUNCSTATE = PROGFUNC(PERCENT, MSG, FUNCSTATE)
%
%       Arguments:
%          funcState = a progress function state
%          percent   = the progress percent (0 to 100%)
%          msg       = a message on our progress (to display)
%
% See also ADDWORMHISTOGRAMS, HISTOGRAM, WORM2CSV, WORMDISPLAYINFO,
%          WORMDATAINFO
%
%
% ? Medical Research Council 2012
% You will not remove any copyright or other notices from the Software; 
% you must reproduce all copyright notices and other proprietary 
% notices on any copies of the Software.

% Do we have a control?
controlFiles = [];
if ~isempty(varargin)
    controlFiles = varargin{1};
end

% Are we in verbose mode?
isVerbose = false;
if length(varargin) > 1
    isVerbose = varargin{2};
end

% Initialize the start and end times for the data to use.
startTime = [];
endTime = [];
if length(varargin) > 2
    startTime = varargin{3};
end
if length(varargin) > 3
    endTime = varargin{4};
    if endTime <= startTime
        error('worm2histogram:BadTime', ...
            'The start time exceeds the end time.');
    end
    
    % If empty, initialize the start time.
    if isempty(startTime) && ~isempty(endTime)
        startTime = 0;
    end
end

% Initialize the progress function.
progFunc = [];
progState = [];
if length(varargin) > 4
    progFunc = varargin{5};
    if length(varargin) > 5 && ~isempty(progFunc)
        progState = varargin{6};
    end
end

% Organize the worm files.
if ~iscell(wormFiles)
    wormFiles = {wormFiles};
end
if ~isempty(controlFiles) && ~iscell(controlFiles)
    controlFiles = {controlFiles};
end

% Delete the file if it already exists.
if exist(filename, 'file')
    delete(filename);
end

% Initialize the worm data information.
histInfo = wormDisplayInfo();
dataInfo = wormDataInfo();

% Initilize the progress.
progCount = 0;
progSize = length(dataInfo) + 2;

% Load the worm information.
if isVerbose
    disp('Saving "wormInfo" ...');
end
[progState, progCount] = progress('Saving "wormInfo" ...', ...
    progFunc, progState, progCount, progSize);
wormInfo = cellfun(@(x) load(x, 'info'), wormFiles);
wormInfo = [wormInfo.info];
if size(wormInfo, 1) < size(wormInfo, 2)
    wormInfo = wormInfo';
end

% Compute the lengthS of the worm time-series data.
wormFrames = arrayfun(@(x) x.video.length.frames, wormInfo);

% Compute the start and end frames for the worm time-series data.
wormStartFrames = [];
wormEndFrames = [];
if ~isempty(startTime)
    
    % Compute the start frames for the worm time-series data.
    wormFPS = arrayfun(@(x) x.video.resolution.fps, wormInfo);
    wormStartFrames = round(startTime * wormFPS) + 1;
    badTimes = find(wormStartFrames > wormFrames);
    if ~isempty(badTimes)
        error('worm2histogram:BadTime', ['The start time, ' ...
            num2str(startTime) ' seconds, exceeds the length of "' ...
            wormFiles{badTimes(1)} '"']);
    end
    
    % Compute the end frames for the worm time-series data.
    if isempty(endTime)
        wormEndFrames = wormFrames;
    else
        wormEndFrames = round(endTime * wormFPS) + 1;
        badTimes = find(wormEndFrames > wormFrames);
        if ~isempty(badTimes)
            error('worm2histogram:BadTime', ['The end time, ' ...
                num2str(endTime) ' seconds, exceeds the length of "' ...
                wormFiles{badTimes(1)} '"']);
        end
    end
end

% Save the worm information.
if isempty(controlFiles)
    save(filename, 'wormInfo', '-v7.3');

% Load and save the worm and control information.
else
    
    % Load the control information.
    if isVerbose
        disp('Saving "controlInfo" ...');
    end
    controlInfo = cellfun(@(x) load(x, 'info'), controlFiles);
    controlInfo = [controlInfo.info];
    if size(controlInfo, 1) < size(controlInfo, 2)
        controlInfo = controlInfo';
    end
    controlFrames = arrayfun(@(x) x.video.length.frames, controlInfo);
    
    % Compute the start and end frames for the control time-series data.
    controlStartFrames = [];
    controlEndFrames = [];
    if ~isempty(startTime)
        
        % Compute the start frames for the worm time-series data.
        controlFPS = arrayfun(@(x) x.video.resolution.fps, controlInfo);
        controlStartFrames = round(startTime * controlFPS) + 1;
        badTimes = find(controlStartFrames > controlFrames);
        if ~isempty(badTimes)
            error('worm2histogram:BadTime', ['The start time, ' ...
                num2str(controlStartTime) ...
                ' seconds, exceeds the length of "' ...
                controlFiles{badTimes(1)} '"']);
        end
        
        % Compute the end frames for the worm time-series data.
        if isempty(endTime)
            controlEndFrames = controlFrames;
        else
            controlEndFrames = round(endTime * controlFPS) + 1;
            badTimes = find(controlEndFrames > controlFrames);
            if ~isempty(badTimes)
                error('worm2histogram:BadTime', ['The end time, ' ...
                    num2str(controlEndTime) ...
                    ' seconds, exceeds the length of "' ...
                    controlFiles{badTimes(1)} '"']);
            end
        end
    end

    % Save the worm and control information.
    save(filename, 'wormInfo', 'controlInfo', '-v7.3');
end

% Free memory.
clear('wormInfo', 'controlInfo');

% Save the worm histograms.
saveHistogram(filename, wormFiles, wormFrames, histInfo, dataInfo, ...
    'worm', isVerbose, wormStartFrames, wormEndFrames, ...
    progFunc, progState, progCount, progSize);

% Save the control histograms.
if ~isempty(controlFiles)
    saveHistogram(filename, controlFiles, controlFrames, histInfo, ...
        dataInfo, 'control', isVerbose, ...
        controlStartFrames, controlEndFrames, ...
        progFunc, progState, progCount, progSize);
end
end



%% Load worm data from files.
function data = loadWormFiles(filenames, field)
data = cellfun(@(x) loadStructField(x, 'worm', field), filenames, ...
    'UniformOutput', false);
end



%% Save the worm histograms.
function saveHistogram(filename, wormFiles, frames, histInfo, dataInfo, ...
    wormName, isVerbose, startFrames, endFrames, ...
    progFunc, progState, progCount, progSize)

% Initialize the locomotion mode information.
motionModes = loadWormFiles(wormFiles, 'locomotion.motion.mode');
motionNames = { ...
    'forward', ...
    'paused', ...
    'backward'};
motionValues = [ ...
     1
     0
    -1];

% Determine the locomotion modes.
motionEvents = cell(3,1);
if isempty(startFrames)
    for i = 1:length(motionValues)
        for j = 1:length(motionModes)
            motionEvents{i}{j} = motionModes{j} == motionValues(i);
        end
    end
else
    for i = 1:length(motionValues)
        for j = 1:length(motionModes)
            motionEvents{i}{j} = ...
                motionModes{j}(startFrames(j):endFrames(j)) == ...
                motionValues(i);
        end
    end
end

% Check the locomotion modes.
for i = 1:length(motionEvents)
    for j = 1:length(motionEvents{i})
        if all(motionEvents{i}{j} ~= 1)
            warning('worm2histogram:NoMotionData', ...
                ['There are no ' motionNames{i} ' motion frames in "' ...
                wormFiles{j} '"']);
        end
    end
end

% Combine the histograms.
for i = 1:length(dataInfo)
    field = dataInfo(i).field;
    if isVerbose
        disp(['Saving "' field '" ...']);
    end
    [progState, progCount] = progress(['Saving "' field '" ...'], ...
        progFunc, progState, progCount, progSize);
    subFields = dataInfo(i).subFields;
    switch dataInfo(i).type
        
        % Compute the simple histogram.
        case 's'
            data = data2histogram(wormFiles, field, subFields, ...
                histInfo, dataInfo(i).isTimeSeries, startFrames, endFrames);
            eval([wormName '.' field '=data;']);
            
        % Compute the motion histogram.
        case 'm'
            if ~isempty(dataInfo(i).subFields)
                field = [field '.' dataInfo(i).subFields{1}]
            end
            data = motion2histograms(wormFiles, field, subFields, ...
                histInfo, startFrames, endFrames, ...
                motionNames, motionEvents);
            eval([wormName '.' field '=data;']);
            
        % Compute the event histogram.
        case 'e'
            data = event2histograms(wormFiles, frames, field, ...
                subFields.summary, subFields.data, subFields.sign, ...
                histInfo, startFrames, endFrames);
            eval([wormName '.' field '=data;']);
    end
end

% Save the histograms.
save(filename, wormName, '-append');
end



%% Convert data to a histogram.
function histData = data2histogram(wormFiles, field, subFields, ...
        histInfo, isTimeSeries, startFrames, endFrames)

% Get the histogram information.
resolution = [];
isZeroBin = [];
isSigned = [];
info = getStructField(histInfo, field);
if isempty(info)
    warning('worm2histogram:NoInfo', ...
        ['There is no information for "' field '"']);
else
    resolution = info.resolution;
    isZeroBin = info.isZeroBin;
    isSigned = info.isSigned;
end

% Get the data.
dataField = field;
if ~isempty(subFields)
    dataField = [dataField '.' subFields{1}];
end
data = loadWormFiles(wormFiles, dataField);

% Get the data subset.
if ~isempty(startFrames)
    for i = 1:length(data)
        if isTimeSeries
            data{i} = data{i}(startFrames(i):endFrames(i));
        else
            data{i} = [];
        end
    end
end

% Check the data.
for i = 1:length(data)
    if isempty(data{i})
        warning('worm2histogram:NoData', ['"' field '" in "' ...
            wormFiles{i} '" contains no data']);
    end
end

% Compute the histogram.
histData.histogram = histogram(data, resolution, isZeroBin, isSigned);
end



%% Convert motion data to a set of histograms.
function histData = motion2histograms(wormFiles, field, subFields, ...
    histInfo, startFrames, endFrames, motionNames, motionEvents)

% Get the histogram information.
resolution = [];
isZeroBin = [];
isSigned = [];
info = getStructField(histInfo, field);
if isempty(info)
    warning('worm2histogram:NoInfo', ...
        ['There is no information for "' field '"']);
else
    resolution = info.resolution;
    isZeroBin = info.isZeroBin;
    isSigned = info.isSigned;
end

% Get the data.
dataField = field;
if ~isempty(subFields)
    dataField = [dataField '.' subFields{1}];
end
data = loadWormFiles(wormFiles, dataField);

% Get the data subset.
if ~isempty(startFrames)
    for i = 1:length(data)
        data{i} = data{i}(:,startFrames(i):endFrames(i));
    end
end

% Check the data.
for i = 1:length(data)
    if isempty(data{i})
        warning('worm2histogram:NoData', ['"' field '" in "' ...
            wormFiles{i} '" contains no data']);
    end
end

% Initialize the histogram data.
histData(size(data{1}, 1)).histogram = [];
for i = 1:size(data{1}, 1)
    for j = 1:length(motionNames)
        histData(i).(motionNames{j}).histogram = [];
    end
end

% Go through the data.
for i = 1:size(data{1}, 1)
    
    % Compute the data histogram.
    subData = cellfun(@(x) x(i,:), data, 'UniformOutput', false);
    histData(i).histogram = ...
        histogram(subData, resolution, isZeroBin, isSigned);
    
    % Compute the motion histograms.
    for j = 1:length(motionEvents)
        
        % Organize the motion data.
        isData = false;
        motionData = cell(length(subData),1);
        for k = 1:length(subData)
            motionData{k} = subData{k}(motionEvents{j}{k});
            if ~isempty(motionData{k})
                isData = true;
            end
        end
        
        % Compute the motion histogram.
        if isData
            histData(i) = setStructField(histData(i), ...
                [motionNames{j} '.histogram'], ...
                histogram(motionData, resolution, isZeroBin, isSigned));
        end
    end
end
end



%% Convert event data to a set of histograms.
function histData = event2histograms(wormFiles, frames, field, ...
    statFields, histFields, signField, histInfo, startFrames, endFrames)

% Get the data.
data = loadWormFiles(wormFiles, field);

% Get the data subset.
if ~isempty(startFrames)
    for i = 1:length(data) 
        if ~isempty(data{i}.frames)
            
            % Which events should we keep?
            keepI = [data{i}.frames.start] >= (startFrames(i) - 1) & ...
                [data{i}.frames.end] <= (endFrames(i) - 1);
            
            % Recompute the event frequency.
            data{i}.frequency = data{i}.frequency * ...
                sum(keepI) / length(keepI);
            
            % Recompute the time spent in the event.
            if isfield(data{i}, 'timeRatio')
                data{i}.timeRatio = data{i}.timeRatio * ...
                    sum([data{i}.frames(keepI).time]) / ...
                    sum([data{i}.frames.time]);
                
            % Recompute the time spent and distance covered in the event.
            elseif isfield(data{i}, 'ratio')
                data{i}.ratio.time = data{i}.ratio.time * ...
                    sum([data{i}.frames(keepI).time]) / ...
                    sum([data{i}.frames.time]);
                data{i}.ratio.distance = data{i}.ratio.distance * ...
                    sum([data{i}.frames(keepI).distance]) / ...
                    sum([data{i}.frames.distance]);
            end
            
            % Remove events outside of the time range.
            data{i}.frames = data{i}.frames(keepI);
        end
    end
end

% Remove partial events.
for i = 1:length(data)
    data{i}.frames = removePartialEvents(data{i}.frames, frames(i));
end

% Check the data.
for i = 1:length(data)
    if isempty(data{i})
        warning('worm2histogram:NoEventData', ['"' field ...
            '" in "' wormFiles{i} '" contains no data (excluding ' ...
            'partial events at the start and end of the video)']);
    end
end

% Initialize the histogram data.
histData = [];
for i = 1:length(statFields)
    histData = setStructField(histData, statFields{i}, []);
end

% Compute the event statistics.
for i = 1:length(statFields)

    % Organize the event data.
    eventData = zeros(length(data),1);
    for j = 1:length(data)
        subData = getStructField(data{j}, statFields{i});
        if ~isempty(subData)
            eventData(j) = subData;
        end
    end
    
    % Compute the event statistics.
    histData = setStructField(histData, ...
        [statFields{i} '.data'], eventData);
    histData = setStructField(histData, ...
        [statFields{i} '.samples'], length(eventData));
    histData = setStructField(histData, ...
        [statFields{i} '.mean'], nanmean(eventData));
    histData = setStructField(histData, ...
        [statFields{i} '.stdDev'], nanstd(eventData));
end

% Create the histogram structures.
for i = 1:length(histFields)
    histData = setStructField(histData, [histFields{i} '.histogram'], []);
end

% Compute the event histograms.
for i = 1:length(histFields)
    
    % Get the histogram information.
    resolution = [];
    isZeroBin = [];
    isSigned = [];
    subField = [field '.' histFields{i}];
    info = getStructField(histInfo, subField);
    if isempty(info)
        warning('worm2histogram:NoInfo', ...
            ['There is no information for "' subField '"']);
    else
        resolution = info.resolution;
        isZeroBin = info.isZeroBin;
        isSigned = info.isSigned;
    end

    % Organize the event data.
    eventData = cell(length(data),1);
    for j = 1:length(data)
        subData = data{j}.frames;
        if ~isempty(field)
            eventData{j} = getStructField(subData, histFields{i});
            
            % Sign the event.
            if ~isempty(signField)
                signs = getStructField(subData, signField);
                eventData{j}(signs) = -eventData{j}(signs);
            end
        end
    end
    
    % Compute the event histogram.
    histData = setStructField(histData, [histFields{i} '.histogram'], ...
        histogram(eventData, resolution, isZeroBin, isSigned));
end
end



%% Progress.
function [progState, progCount] = ...
    progress(msg, progFunc, progState, progCount, progSize)

% Are we monitoring progression?
if ~isempty(progFunc)
    
    % Progress.
    progCount = progCount + 1;
    progState = progFunc(progCount / progSize, msg, progState);
end
end
