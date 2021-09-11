close all;
clearvars;
clc;

[file,path] = uigetfile({'*.jpg'; '*.png'}, 'PILIH GAMBAR');

I=imread([path, file]);
 [X,Y]=size(I(:,:,1));

  cX = floor(X/2);
  cY = floor(Y/2);
%   Xbaru=400;
%   Ybaru=400;
 
  crop = I(cX-floor(X/4):cX+floor(X/4), cY-floor(Y/4) : cY+floor(Y/4),:);
  crop_hsv=rgb2hsv(crop);
 
 figure(1),imshow(I);
figure(2),imshow(crop);
% xlswrite('TabelCrop.xls', crop_hsv, 'Sheet 1', 'A2');
% figure(3), imshow(crop_hsv);
[N,M,L]=size(crop);
Hk = 12; Ck = 5; Lk = 5;
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
HCL_Histo_1D=reshape(HCL_Histo,[1,360]);
% BukaFile = fopen('TabelBinWarna1.txt','W')
% fprintf(BukaFile,HCL_Histo_1D);
%  fileName = fopen('TabelBinWarna1.dat',HCL_Histo_1D);
%  fprintf(fileName, '%f %f\n',);
% B = sprint('TabelBinWarna1.dat',HCL_Histo_1D)
 %B = csvread('Data1.csv');
 %B(end+1,:)= HCL_Histo_1D;
%csvwrite('Data1.csv',HCL_Histo);
%B = csvread('Data1.csv');
 B = HCL_Histo_1D;
 csvwrite('Vektor1.csv',B)
figure(3), %plot(HCL_Histo_1D);

%HCL_Histo(:,:,4)
%out=[HCL_Histo(8,:),HCL_Histo(9,:),HCL_Histo(10,:),HCL_Histo(11,:),HCL_Histo(12,:),HCL_Histo(1,:),HCL_Histo(2,:),HCL_Histo(7,:),HCL_Histo(6,:)] 
% opts.SelectedVariableNames = [1:30];
% opts.DataRange = '1:12';
% K = readtable('MatriksNila103.csv')
% rotationVector = rotationMatrixToVector('MatriksNila133.csv');



% A=reshape(,1,[])  %matrics to vector (in row )
%  AB= A>0;                    %condition values>0
% ABC=A(AB);                  %storing values>0 to new variable





      
           
       
           
