function [peaks indices] = minPeaksDistHeight(x, dist, height)
%MINPEAKSDISTHEIGHT Find the minimum peaks in a vector. The peaks are
%   separated by, at least, the given distance unless interrupted and are,
%   at most, the given height.
%
%   [PEAKS INDICES] = MINPEAKSDISTHEIGHT(X, DIST, HEIGHT)
%
%   Input:
%       x      - the vector to search for maximum peaks
%       dist   - the minimum distance between peaks
%       height - the maximum height for peaks
%
%   Output:
%       peaks   - the minimum peaks
%       indices - the indices for the peaks
%
%
% ? Medical Research Council 2012
% You will not remove any copyright or other notices from the Software; 
% you must reproduce all copyright notices and other proprietary 
% notices on any copies of the Software.

% Is the vector larger than the search window?
winSize = 2 * dist + 1;
if length(x) < winSize
    [peaks indices] = min(x);
    if peaks < height
        peaks = [];
        indices = [];
    end
    return;
end

% Initialize the peaks and indices.
wins = ceil(length(x) / winSize);
peaks = zeros(wins, 1); % pre-allocate memory
indices = zeros(wins, 1); % pre-allocate memory

% Search for peaks.
im = []; % the last minima index
ip = []; % the current, potential, min peak index
p = []; % the current, potential, min peak value
i = 1; % the vector index
j = 1; % the recorded, minimal peaks index
while i <= length(x)
    
    % Found a potential peak.
    if x(i) <= height && (isempty(p) || x(i) < p)
        ip = i;
        p = x(i);
    end
    
    % Test the potential peak.
    if ~isempty(p) && (i - ip >= dist || i == length(x))
        
        % Check the untested values next to the previous maxima.
        if ~isempty(im) && ip - im <= 2 * dist
            
            % Record the peak.
            if p < min(x((ip - dist):(im + dist)))
                indices(j) = ip;
                peaks(j) = p;
                j = j + 1;
            end
            
            % Record the minima.
            im = ip;
            ip = i;
            p = x(ip);
            
        % Record the peak.
        else
            indices(j) = ip;
            peaks(j) = p;
            j = j + 1;
            im = ip;
            ip = i;
            p = x(ip);
        end
    end
        
    % Advance.
    i = i + 1;
end

% Collapse any extra memory.
indices(j:end) = [];
peaks(j:end) = [];
end
