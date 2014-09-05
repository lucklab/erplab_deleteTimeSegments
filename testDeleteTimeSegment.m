classdef testDeleteTimeSegment < matlab.unittest.TestCase
    %TESTDELETETIMESEGMENT Test class for deleteTimeSegment.m function
    %   
    
    properties
    end
    
    methods (Test)
        function testCharacterEventCodes(testCase)
            testFileName = 'P3Test.set';
            testFilePath = './testFiles';
            
            %             eeglab;
            EEG = pop_loadset( ...
                  'filename', testFileName ...
                , 'filepath', testFilePath );
            EEG = eeg_checkset( EEG );
            
            
            
            timeThreshold       = 3000;
            eventBufferStart    = 1000;
            eventBufferEnd      = 1000;
            ignoredEventCodes   = [];
            
            [outputEEG, ~] = JFAdeleteTimeSegment(EEG, timeThreshold, eventBufferStart, eventBufferEnd, ignoredEventCodes, true);
            
            eegplot(outputEEG.data, 'srate', outputEEG.srate,'events', outputEEG.event,'winlength', 75, 'spacing', 200)
%             eegplot(EEG.data, 'winrej', matrixrej, 'srate', EEG.srate,'butlabel','REJECT','command', commrej,'events', EEG.event,'winlength', 75);
%             eegplot(EEG.data, 'srate', EEG.srate,'events', EEG.event,'winlength', 75, 'spacing', 200)

        end
        
        function testIgnoredEventCodes(testCase)
            testFileName = 'P3Test.set';
            testFilePath = './testFiles';
            
            eeglab;
            EEG = pop_loadset( ...
                  'filename', testFileName ...
                , 'filepath', testFilePath );
            EEG = eeg_checkset( EEG );
            
            
            
            timeThreshold       = 3000;
            eventBufferStart    = 200;
            eventBufferEnd      = 400;
            ignoredEventCodes   = 202;
            
            outputEEG = JFAdeleteTimeSegment(EEG, timeThreshold, eventBufferStart, eventBufferEnd, ignoredEventCodes);
            eegplot(outputEEG.data, 'srate', outputEEG.srate,'events', outputEEG.event,'winlength', 75, 'spacing', 200)

            
            
        end

        
    end
    
end

