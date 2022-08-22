function [ info ] = parseWormFilename( filename )
%parseWormFilename Parses a filename, from a worm experiment, into a struct
%of information.
%
%   The input argument 'filename' is the file's name as a string. The
%   output 'info' is a struct containing the worm type, strain, whether
%   it's crawling on food, what side it's crawling on, and the timestamp of
%   when the file was created.
%
%
% � Medical Research Council 2012
% You will not remove any copyright or other notices from the Software; 
% you must reproduce all copyright notices and other proprietary 
% notices on any copies of the Software.

% Parse the file name.
pattern = ['(?<type>\S+)\s*' ...
    '(?<strain>\(\w+\)\w*)?\s+' ...
    '(?<food>on\s+food)?\s*' ...
    '(?<side>[LR])_' ...
    '(?<year>\d\d\d\d)_' ...
    '(?<month>\d\d)_' ...
    '(?<day>\d\d)__' ...
    '(?<hour>\d\d)_' ...
    '(?<minute>\d\d)_' ...
    '(?<second>\d\d).*'];
matches = regexpi(filename, pattern, 'names');
if isempty(matches)
    error('parseWormFilename:NoMatches', 'The filename does not parse');
end

% Parse the strain.
smatches(1) = struct('strain', [], 'chromosome', []);
if ~isempty(matches(1).strain)
    spattern = '\((?<strain>\w+)\)(?<chromosome>\w+)?';
    smatches = regexpi(matches(1).strain, spattern, 'names');
end
    
% Construct the date.
date = datenum(str2num(matches(1).year), ...
    str2num(matches(1).month), ...
    str2num(matches(1).day), ...
    str2num(matches(1).hour), ...
    str2num(matches(1).minute), ...
    str2num(matches(1).second));
    
% Fill the info.
info = struct('type', matches(1).type, ...
    'strain', smatches(1).strain, ...
    'chromosome', smatches(1).chromosome, ...
    'food', ~isempty(matches(1).food), ...
    'side', matches(1).side, ...
    'timestamp', date);

end

