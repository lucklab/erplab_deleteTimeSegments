classdef test_erplabDeleteTimeSegments < matlab.unittest.TestCase
    %TESTDELETETIMESEGMENT Test class for deleteTimeSegment.m function
    %   
    
    properties
    end
    
    
    methods(TestMethodSetup)
        function loadData(testCase) %#ok<*MANU>
            [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab; %#ok<*ASGLU>
            testFileName = 'P3Test.set';
            testFilePath = './testFiles';
            
            %             eeglab;
            EEG = pop_loadset( ...
                  'filename', testFileName ...
                , 'filepath', testFilePath );
            EEG = eeg_checkset( EEG );
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG );

            eeglab('redraw')
        end
    end
    
    %% Test Method Block
    methods (Test)
        
        
        %% Test Function
        function testCharacterEventCodes(testCase)
            %% Exercise function under test
            % act = the value from the function under test
            
            
            %% Verify using the test qualification
            % exp = your expected value
            % testCase.<qualification method>(act, exp)
            % See Types of Qualifications: http://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html
            
            
            
            timeThreshold       = 3000;
            eventBufferStart    = 1000;
            eventBufferEnd      = 1000;
            ignoredEventCodes   = [];
            displayEegPlot      = true;
            
            [outputEEG, ~] = erplab_deleteTimeSegments(EEG, ...
                timeThreshold, eventBufferStart, eventBufferEnd, ...
                ignoredEventCodes, displayEegPlot);
            
            eegplot(outputEEG.data, ...
                'srate', outputEEG.srate, ...
                'events', outputEEG.event, ...
                'winlength', 75, 'spacing', 200);
            
%             eegplot(EEG.data, 'winrej', matrixrej, 'srate', EEG.srate,'butlabel','REJECT','command', commrej,'events', EEG.event,'winlength', 75);
%             eegplot(EEG.data, 'srate', EEG.srate,'events', EEG.event,'winlength', 75, 'spacing', 200)

        end
        
        function testIgnoredEventCodes(testCase)

               
            
            timeThreshold       = 3000;
            eventBufferStart    = 200;
            eventBufferEnd      = 400;
            ignoredEventCodes   = 202;
            
            outputEEG = JFAdeleteTimeSegment(EEG, timeThreshold, eventBufferStart, eventBufferEnd, ignoredEventCodes);
            eegplot(outputEEG.data, 'srate', outputEEG.srate,'events', outputEEG.event,'winlength', 75, 'spacing', 200)

            
            
        end

        
    end
    
end

