function varargout = vocoder(varargin)
% VOCODER MATLAB code for vocoder.fig
%      VOCODER, by itself, creates a new VOCODER or raises the existing
%      singleton*.
%
%      H = VOCODER returns the handle to a new VOCODER or the handle to
%      the existing singleton*.
%
%      VOCODER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOCODER.M with the given input arguments.
%
%      VOCODER('Property','Value',...) creates a new VOCODER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vocoder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vocoder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vocoder

% Last Modified by GUIDE v2.5 08-Nov-2023 02:57:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vocoder_OpeningFcn, ...
                   'gui_OutputFcn',  @vocoder_OutputFcn, ...
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

% --- Executes just before vocoder is made visible.
function vocoder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vocoder (see VARARGIN)

% Choose default command line output for vocoder
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vocoder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vocoder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

 
% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sampleRate = str2double(get(handles.sampleRate,'String'));
bufferSize = str2double(get(handles.bufferSize,'String'));
numerator = str2double(get(handles.numerator,'String'));
denominator = str2double(get(handles.denominator,'String'));
hop_size = str2double(get(handles.hop_size,'String'));
global reader writer flag result input pvcoSpeed
reader = audioDeviceReader(sampleRate,bufferSize);
writer = audioDeviceWriter(sampleRate);
flag = false;
result= [];
input = [];
pvcoSpeed = [];
while(~flag)
    x = reader();
    % Change Pitch
%     Demo is 5/4th which is major third ratio so let input be 440 (A note) then output
%     is 550 (C# which is major third)
    speed = pvoc(x, numerator/denominator,hop_size); % 5/4 speed
    pitch = resample(speed, numerator, denominator); % resample(input, numerator, denominator), change pitch
%     len = max(length(speed), length(pitch)); % longer signal
    input = [input,x];
    pvcoSpeed = [pvcoSpeed,speed];
    result = [result; pitch];
    writer(pitch);

     pause(0.01); % D?ng 10 ms ð? x? l? các s? ki?n
    if flag == true    
        release(reader);
        release(writer);
        break;
    end
end



% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag result input pvcoSpeed
flag = true; 
input = reshape(input, [], 1);
pvcoSpeed = reshape(pvcoSpeed, [], 1);
assignin('base','input',input);
assignin('base','ouput',result);
assignin('base','speed',pvcoSpeed);
len = (min(length(pvcoSpeed), length(result)));
original = handles.axes1;
time_shift = handles.axes2;
pitch_shift = handles.axes3;
axes(original);
plot(input, 'm'); xlim([0, len]);
axes(time_shift)
plot(pvcoSpeed, 'b'); xlim([0, len]);
axes(pitch_shift)
plot(result, 'g'); xlim([0, len]);
% --- Executes on button press in reset_btn.
function reset_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reset_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.sampleRate,'String',44100);
set(handles.bufferSize,'String',8192);
set(handles.numerator,'String',1);
set(handles.denominator,'String',1);
set(handles.hop_size,'String',1024);



function numerator_Callback(hObject, eventdata, handles)
% hObject    handle to numerator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numerator as text
%        str2double(get(hObject,'String')) returns contents of numerator as a double


% --- Executes during object creation, after setting all properties.
function numerator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numerator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hop_size_Callback(hObject, eventdata, handles)
% hObject    handle to hop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hop_size as text
%        str2double(get(hObject,'String')) returns contents of hop_size as a double


% --- Executes during object creation, after setting all properties.
function hop_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function denominator_Callback(hObject, eventdata, handles)
% hObject    handle to denominator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of denominator as text
%        str2double(get(hObject,'String')) returns contents of denominator as a double


% --- Executes during object creation, after setting all properties.
function denominator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to denominator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleRate as text
%        str2double(get(hObject,'String')) returns contents of sampleRate as a double


% --- Executes during object creation, after setting all properties.
function sampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bufferSize_Callback(hObject, eventdata, handles)
% hObject    handle to bufferSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bufferSize as text
%        str2double(get(hObject,'String')) returns contents of bufferSize as a double


% --- Executes during object creation, after setting all properties.
function bufferSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bufferSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
