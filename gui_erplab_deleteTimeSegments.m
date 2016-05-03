function varargout = gui_erplab_deleteTimeSegments(varargin)
% gui_erplab_deleteTimeSegments MATLAB code for gui_erplab_deleteTimeSegments.fig
%      gui_erplab_deleteTimeSegments, by itself, creates a new gui_erplab_deleteTimeSegments or raises the existing
%      singleton*.
%
%      H = gui_erplab_deleteTimeSegments returns the handle to a new gui_erplab_deleteTimeSegments or the handle to
%      the existing singleton*.
%
%      gui_erplab_deleteTimeSegments('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui_erplab_deleteTimeSegments.M with the given input arguments.
%
%      gui_erplab_deleteTimeSegments('Property','Value',...) creates a new gui_erplab_deleteTimeSegments or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_erplab_deleteTimeSegments_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_erplab_deleteTimeSegments_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_erplab_deleteTimeSegments

% Last Modified by GUIDE v2.5 03-May-2016 02:53:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_erplab_deleteTimeSegments_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_erplab_deleteTimeSegments_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before gui_erplab_deleteTimeSegments is made visible.
function gui_erplab_deleteTimeSegments_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_erplab_deleteTimeSegments (see VARARGIN)

% Choose default command line output for gui_erplab_deleteTimeSegments
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes gui_erplab_deleteTimeSegments wait for user response (see UIRESUME)
uiwait(handles.gui_figure);


% --- Outputs from this function are returned to the command line.
function varargout = gui_erplab_deleteTimeSegments_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.gui_figure);
pause(0.5)




% --- Executes on button press in pushbutton_deleteTimeSegment.
function pushbutton_deleteTimeSegment_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to pushbutton_deleteTimeSegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mass = handles.metricdata.density * handles.metricdata.volume;
% set(handles.mass, 'String', mass);

% Command-line feedback to user
display('Interpolating Channels');


% Save the input variables to output
handles.output = {        ...
    handles.replaceChannels,   ...
    handles.ignoreChannels,    ...
    handles.interpolationMethod ...
    };

% Update handles structure
guidata(hObject, handles);
uiresume(handles.gui_figure);

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Command-line feedback to user
disp('User selected Cancel')

% Clear all input variables
handles.output = []; 

% Update handles structure
guidata(hObject, handles);
uiresume(handles.gui_figure);



% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset) %#ok<*INUSD>
% If the metricdata field is present and the pushbutton_cancel flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to pushbutton_cancel the data.


handles.replaceChannels    = '[]';
handles.ignoreChannels     = '[]';
handles.interpolationMethod = 'spherical';
 
set(handles.editbox_maxDistanceMS,     'String',         num2str(handles.replaceChannels));
set(handles.editbox_startEventCodeBufferMS,      'String',         num2str(handles.ignoreChannels));
set(handles.uipanel_interpolationMethod, 'SelectedObject', handles.radiobutton_spherical);


%
% Name & version
%
version = geterplabversion;
set(handles.gui_figure,'Name', ['ERPLAB ' version '   -   EXTRACT BINEPOCHS GUI'])

%
% Color GUI
%
handles = painterplab(handles);

%
% Set font size
%
handles = setfonterplab(handles);


% Update handles structure
guidata(handles.gui_figure, handles);




function editbox_maxDistanceMS_Callback(hObject, eventdata, handles)
% hObject    handle to editbox_maxDistanceMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbox_maxDistanceMS as text
%        str2double(get(hObject,'String')) returns contents of editbox_maxDistanceMS as a double

% Use `str2num` (vs `str2double`) to handle both string arrray input and
% single string/character input

% returns contents of editbox_maxDistanceMS as a double
handles.maxDistanceMS = str2double(get(hObject,'String')); 

% Save the new replace channels value
guidata(hObject,handles)


function editbox_startEventCodeBufferMS_Callback(hObject, eventdata, handles)
% hObject    handle to editbox_startEventCodeBufferMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbox_startEventCodeBufferMS as text
%        str2double(get(hObject,'String')) returns contents of editbox_startEventCodeBufferMS as a double

% returns contents of editbox_maxDistanceMS as a double
handles.startEventCodeBufferMS = str2double(get(hObject,'String')); 

% Save the new value
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function editbox_startEventCodeBufferMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbox_startEventCodeBufferMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEndEventCodeBufferMS_Callback(hObject, eventdata, handles)
% hObject    handle to editEndEventCodeBufferMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEndEventCodeBufferMS as text
%        str2double(get(hObject,'String')) returns contents of editEndEventCodeBufferMS as a double

% returns contents of editbox_EndEventCodeBufferMS as a double
handles.endEventCodeBufferMS = str2double(get(hObject,'String')); 

% Save the new value
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function editEndEventCodeBufferMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEndEventCodeBufferMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editIgnoreEventCodes_Callback(hObject, eventdata, handles)
% hObject    handle to editIgnoreEventCodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIgnoreEventCodes as text
%        str2double(get(hObject,'String')) returns contents of editIgnoreEventCodes as a double


% --- Executes during object creation, after setting all properties.
function editIgnoreEventCodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIgnoreEventCodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxDisplayEEG.
function checkboxDisplayEEG_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDisplayEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxDisplayEEG
% returns contents of editbox_EndEventCodeBufferMS as a double
handles.displayEEG = get(hObject,'Value'); 

% Save the new value
guidata(hObject,handles)
