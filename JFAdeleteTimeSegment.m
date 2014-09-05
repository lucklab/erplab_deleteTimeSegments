% JFAdeleteTimeSegment.m (alpha version)
%
% Deletes segment of data between 2 event codes (string or number) if the size of the segment
% is greater than a specified time (in msec)
%
% USAGE
%
% EEG = JFAdeleteTimeSegment(EEG, inputMaxDistanceMS, inputStartPeriodBufferMS, inputEndPeriodBufferMS, ignoreEventCodes);
%
%
% Input:
%
%  EEG                      - continuous EEG dataset (EEGLAB's EEG structure)
%  maxDistanceMS            - 
%  startEventCodeBufferMS   -
%  endEventCodeBufferMS     - 
%
% Optional
%  ignoreEventCodes         - (cell array for character 
%  displayEEGPLOTGUI        - (true|false)
%
% Output:
%
% EEG                       - continuous EEG dataset  (EEGLAB's EEG structure)
%
%
% Example:
%  
%      EEG = JFAdeleteTimeSegment(EEG, 3000, 100, 200, []);   % Delete segment of data between any two event codes when it is longer than 3000 ms (3 secs).
%
% 
%
%
% *** This function is part of ERPLAB Toolbox ***
% Author: Javier Lopez-Calderon
% Center for Mind and Brain
% University of California, Davis,
% Davis, CA
% 2009

%b8d3721ed219e65100184c6b95db209bb8d3721ed219e65100184c6b95db209b
%
% ERPLAB Toolbox
% Copyright © 2007 The Regents of the University of California
% Created by Javier Lopez-Calderon and Steven Luck
% Center for Mind and Brain, University of California, Davis,
% javlopez@ucdavis.edu, sjluck@ucdavis.edu
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [EEG, rejectionWindows] = JFAdeleteTimeSegment(EEG, inputMaxDistanceMS, inputStartPeriodBufferMS, inputEndPeriodBufferMS, varargin)


% Error check the input variables
if nargin<1
    help JFAdeleteTimeSegment
    return
elseif nargin<4
    error('ERPLAB:JFAdeleteTimeSegment: needs 5 inputs.')
elseif length(varargin) > 2                                      % only want 3 optional inputs at most
    error('ERPLAB:JFAdeleteTimeSegment:TooManyInputs', ...
        'requires at most 2 optional inputs');
else
    disp('Working...')
end

if length(EEG.event)<1
        fprintf('\ndelshortseg.m did not find remaining event codes.\n')
        return
end



% Hand optional variables
optargs = {[] false}; % Default optional inputs


% now put these defaults into the valuesToUse cell array, 
% and overwrite the ones specified in varargin.
optargs(1:length(varargin)) = varargin;     % if vargin is empty, optargs keep their default values. If vargin is specified then it overwrites 

% Place optional args into variable names
[ignoreEventCodes, eegplotGUIFeedback] = optargs{:};




% Insert event codes at the beginning and end of the EEG data set
% eegEdgeEventCode    = 9999;
% startTime           = EEG.xmin;
% endTime             = EEG.xmax;
% firstEventCode      = 1;
% lastEventCode       = length(EEG.event);
% % newLastEventCode    = lastEventCode + 1;

% EEG = pop_editeventvals(EEG,'insert',{firstEventCode [] [] []}   ,'changefield', {firstEventCode    'type' eegEdgeEventCode},'changefield',{firstEventCode    'latency' startTime   });
% EEG = pop_editeventvals(EEG,'insert',{lastEventCode  [] [] []}   ,'changefield', {lastEventCode + 1 'type' eegEdgeEventCode},'changefield',{lastEventCode + 1 'latency' endTime     });


% Convert all timing info to samples

% analyzedEventCodes        = unique({EEG.event.type});
% inputMaxDistanceMS        = 3000;     % (ms)
% inputStartPeriodBufferMS  = 100;      % (ms)
% inputEndPeriodBufferMS    = 200;      % (ms)
% ignoreEventCodes          = {'9'};      % (event numbers)


maxDistanceSample       = round(inputMaxDistanceMS       *(EEG.srate/1000));  % ms to samples
startPeriodBufferSample = round(inputStartPeriodBufferMS *(EEG.srate/1000));  % ms to samples
endPeriodBufferSample   = round(inputEndPeriodBufferMS   *(EEG.srate/1000));  % ms to samples


% eventWindowSample       = 0.5*(EEG.srate/1000);



%% Set up FUNCTIONING event codes + IGNORED event codes
% if  iscell(analyzedEventCodes)
%         % latx  = strmatch(analyzedEventCodes, {EEG.event.type}, 'exact');
%         try
%                 latx  = find(ismember({EEG.event.type}, analyzedEventCodes));
%         catch
%                 error('ERPLAB: Your specified code must have the same format as your event codes (string or numeric).')
%         end
% elseif ischar(EEG.event(1).type) && ischar(analyzedEventCodes)
%         latx = find(ismember({EEG.event.type}, {analyzedEventCodes}));
% elseif ~ischar(EEG.event(1).type) && isnumeric(analyzedEventCodes)
%         latx = find(ismember([EEG.event.type], analyzedEventCodes));
% else
%         error('ERPLAB: Your specified code must have the same format as your event codes (string or numeric).')
% end


if ischar(EEG.event(1).type)
    analyzedEventCodes    = setdiff({EEG.event.type}, ignoreEventCodes);                            % Filter out the ignored event code
    analyzedEventIndices  = ismember({EEG.event.type}, analyzedEventCodes);                         % 
    analyzedSamples       = round([EEG.event(analyzedEventIndices).latency]);                       % Convert event codes to samples
else
    analyzedEventCodes    = setdiff([EEG.event.type], ignoreEventCodes);                            % Filter out the ignored event code
    analyzedEventIndices  = ismember([EEG.event.type], analyzedEventCodes);                         % 
    analyzedSamples       = round([EEG.event(analyzedEventIndices).latency]);                       % Convert event codes to samples
end




% analyzedSamples = round([EEG.event.latency]);
if analyzedSamples(end) ~= EEG.pnts
    analyzedSamples(end+1) = EEG.pnts; % add the last sample
end

lastSampleAnalyzed      = 1;
rejectionWindows        = zeros(length(analyzedSamples), 2); % [];
rejectionWindowCount    = 0;
samplesStart            = 1;
samplesEnd              = analyzedSamples(end);

% Original Code:
% --------------
% look for large segments
% for segmentIndex=1:length(analyzedSamples)
%         if abs(analyzedSamples(segmentIndex)-lastSample) >= maxDistanceSample
%                 t1          = lastSample;
%                 t2          = analyzedSamples(segmentIndex);
%                 rejectionWindows(rejectionWindowCount+1,:)  = [t1+startPeriodBufferSample t2-endPeriodBufferSample];
%                 rejectionWindowCount=rejectionWindowCount+1;
%         end
%         lastSample = analyzedSamples(segmentIndex);
% end

% Main Algorithm: Look for time/sample segments that exceed the MAXDISTANCESAMPLE
for currentSegmentNum=1:length(analyzedSamples)
    
        if abs(analyzedSamples(currentSegmentNum)-lastSampleAnalyzed) >= maxDistanceSample
                t1          = lastSampleAnalyzed;
                t2          = analyzedSamples(currentSegmentNum);
                
                if(     t1 == samplesStart)
                    rejectionWindows(rejectionWindowCount+1,:)  = [t1                           t2-endPeriodBufferSample    ];  % Do not use buffer for the first sample (ie. start of the EEG dataset)
                elseif( t2 == samplesEnd ) 
                    rejectionWindows(rejectionWindowCount+1,:)  = [t1+startPeriodBufferSample   t2                          ];  % Do not use buffer for the last sample (ie. end of the EEG dataset)
                else
                    rejectionWindows(rejectionWindowCount+1,:)  = [t1+startPeriodBufferSample   t2-endPeriodBufferSample    ];
                end
                
                rejectionWindowCount=rejectionWindowCount+1;
        end
        lastSampleAnalyzed = analyzedSamples(currentSegmentNum);
end


rejectionWindows(any(rejectionWindows==0,2),:) = []; % trim empty rows

if rejectionWindowCount==1
        fprintf('\nNote: No large segment was found.\n')
else
        rejectionWindows = JFAjoinclosesegments(rejectionWindows, [], 5);
        
        if eegplotGUIFeedback
            % Plot EEG data with to-be-rejected time windows
            rejectionWindowChannelMatrix    = zeros(size(rejectionWindows,1),EEG.nbchan, 1);                                % do not mark any channel in EEGPLOT
            rejectionWindowColorMatrix      = repmat([.5 .5 .5], size(rejectionWindows,1),1);                                  % color matrix for EEGPLOT highlighting
            rejectionWindowMatrix           = [rejectionWindows rejectionWindowColorMatrix rejectionWindowChannelMatrix];   % combined rejection window highlighting for EEGPLOT

            % Rejection command feature removed because I can't get it to
            % work.
            %             rejectionCommand                = sprintf('%s = eeg_eegrej( %s, rejectionWindows);', inputname(1), inputname(1));             % inputname(1), inputname(1));
            %             assignin('base', 'rejectionWindows', rejectionWindows); % not sure why this is needed. Perhaps for the rejectionCommand
            %             eegplot(EEG.data, 'winrej', rejectionWindowMatrix, 'srate', EEG.srate,'butlabel','REJECT','command', rejectionCommand,'events', EEG.event,'winlength', 50);
            
            
            eegplot(EEG.data, 'winrej', rejectionWindowMatrix, 'srate', EEG.srate,'events', EEG.event,'winlength', 50, 'spacing', 100);

            fprintf('\n %g rejection segments marked.\n\n', size(rejectionWindows,1));

        end
        
        EEG = eeg_eegrej( EEG, rejectionWindows);

        
end

% get rid of the first boundary when is on the first sample.
if ischar(EEG.event(1).type)
        if strcmpi(EEG.event(1).type,'boundary') && EEG.event(1).latency<=1 % in sample
                EEG = pop_editeventvals(EEG,'delete',1);
        end
end









