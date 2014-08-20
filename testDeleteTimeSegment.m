classdef testDeleteTimeSegment < matlab.unittest.TestCase
    %TESTDELETETIMESEGMENT Test class for deleteTimeSegment.m function
    %   
    
    properties
    end
    
    methods (Test)
        function testCharacterEventCodes(testCase)
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
            ignoredEventCodes   = [];
            
            [outputEEG rejectionWindows] = deleteTimeSegment(EEG, timeThreshold, eventBufferStart, eventBufferEnd, ignoredEventCodes);
            
            
            eegplot(EEG.data, 'winrej', matrixrej, 'srate', EEG.srate,'butlabel','REJECT','command', commrej,'events', EEG.event,'winlength', 75);

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
            ignoredEventCodes   = [];
            
            outputEEG = deleteTimeSegment(EEG, timeThreshold, eventBufferStart, eventBufferEnd, ignoredEventCodes);
            
            
            
        end

        
    end
    
end

