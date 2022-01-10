function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 21-Dec-2021 14:39:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Load Trained Network
handles.network = load('network.mat');
guidata(hObject, handles);

% Load Gunadarma logo
[logo, ~, alpha] = imread('Logo Gunadarma.png');
set(handles.logoImage,'Units','pixels');
axes(handles.logoImage);
plot = imshow(logo);
plot.AlphaData = alpha;    %set transparency

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browseBtn.
function browseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to browseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Browse image data
[file,path] = uigetfile({'*.jpg'; '*.png'}, 'PILIH GAMBAR');


fig = uifigure;
d = uiprogressdlg(fig,'Title','Processing...',...
    'Indeterminate','on');
drawnow

%read image data
I=imread([path, file]);

%crop image data
I=imread([path, file]);
[X,Y]=size(I(:,:,1));

%start timer
tStart = tic;

cX = floor(X/2);
cY = floor(Y/2);

crop = I(cX-floor(X/4):cX+floor(X/4), cY-floor(Y/4) : cY+floor(Y/4),:);
crop_hsv=rgb2hsv(crop);

%display original image in axes
set(handles.originalImage, 'Units', 'pixels');
axes(handles.originalImage);
imshow(I);

%display cropped image in axes
set(handles.croppedImage, 'Units', 'pixels');
axes(handles.croppedImage);
imshow(crop);

%preprocessing data
[N,M,L]=size(crop);
Hk = 12; Ck = 4; Lk = 4;
HCL_Histo(1:Hk, 1:Ck+1, 1:Lk) = 0;
gamma = 1;
Q = exp(gamma/100.0);
Ldiv = ceil((2*Q-1.0)*255/(2.0*Lk));
Cdiv = round(2*255*Q/(3.0*Ck));
Hdiv = 30;
for n=1:N
    for m=1:M
        b=double(crop(n,m,3)); g=double(crop(n,m,2)); r=double(crop(n,m,1));
        
        Max = max(r,max(g,b));
        Min = min(r,min(g,b));
        if Max==0 Q=1.0;
        else Q = exp((Min*gamma)/(Max*100.0));
        end
        L = floor((Q*Max+(Q-1.0)*Min)/(2.0*Ldiv));
        rg = (r-g); gb = (g-b);
        C = (abs(b-r) + abs(rg) + abs(gb))*Q/(3.0);
        if C<=5 C=0;
        else C = 1 + floor((C-5)/Cdiv);
        end
        H = atan(gb/rg);
        if (C==0) H=0.0;
        elseif (rg>=0&&gb>=0)H=2*H/3;
        elseif ((rg>=0)&&gb<0)H=4*H/3;
        elseif (rg<0&&gb>=0)H=pi+4*H/3;
        elseif ((rg<0)&&gb<0)H=2*H/3-pi;
        end
        H = H*(180/pi)+Hdiv/2;
        if H<0 H=floor((360+H)/(Hdiv));
        else H = floor(H/(Hdiv));
        end
        HCL_Histo(H+1,C+1,L+1) = HCL_Histo(H+1, C+1, L+1)+1;
    end
end
HCL_Histo = (100*HCL_Histo/(N*M));
HCL_Histo = HCL_Histo(:,1:3,:);
handles.HCL_Histo_1D=reshape(HCL_Histo,[1,144]);
guidata(hObject, handles);
close(fig);
%stop timer
tEnd = toc(tStart);
set(handles.cropTimeText, 'String', tEnd);



% --- Executes on button press in klasifikasiBtn.
function klasifikasiBtn_Callback(hObject, eventdata, handles)
% hObject    handle to klasifikasiBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%start timer
tStart = tic;

%classify the image data
YPred = classify(handles.network.network, handles.HCL_Histo_1D);
if(uint8(YPred) == 1)
    strPred = 'Segar';
elseif(uint8(YPred) == 2)
    strPred = 'Tidak Segar';
end

%stop timer
tEnd = toc(tStart);

%show prediction result
set(handles.predictionText, 'String', strPred);

%show prediction time
set(handles.timeText, 'String', tEnd);


% --- Executes on button press in exitBtn.
function exitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to exitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function predictionText_Callback(hObject, eventdata, handles)
% hObject    handle to predictionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of predictionText as text
%        str2double(get(hObject,'String')) returns contents of predictionText as a double


% --- Executes during object creation, after setting all properties.
function predictionText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to predictionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeText_Callback(hObject, eventdata, handles)
% hObject    handle to timeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeText as text
%        str2double(get(hObject,'String')) returns contents of timeText as a double


% --- Executes during object creation, after setting all properties.
function timeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
