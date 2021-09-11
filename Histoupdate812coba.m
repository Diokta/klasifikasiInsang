clear all;
I=imread('mujair501.jpg');
[X,Y]=size(I(:,:,1));

cX = floor(X/2);
cY = floor(Y/2);
%Xbaru=600;
%Ybaru=600;

%crop = imcrop(I,[cX-floor(Xbaru/2) cX-floor(Ybaru/2) Xbaru-1 Ybaru-1]);

crop = I(cX-floor(X/4):cX+floor(X/4), cY-floor(Y/4) : cY+floor(Y/4),:);
crop_hsv=rgb2hsv(crop);

figure(1),imshow(I);
figure(2),imshow(crop);
figure(3), imshow(crop_hsv);

[N,M,L]=size(crop);
HSV_Edge(1:350,1:400,1:3)=128;
for n=1:N
    for m=1:M
        b=double(crop(n,m,3)); g=double(crop(n,m,2)); r=double(crop(n,m,1));
        
        Max = max(r,max(g,b));
        Min = min(r,min(g,b));
        if Max
            C = Max-Min;
            V = Max;            % hitung Value atau Luninance
            
            if (Max == Min) S = 0;         % hitung Saturation
            else  S = C;
            end;
            
            if (Max==Min) H=0;                   % hitung Hue
            elseif (r == Max)   H = ((g - b))/C;
            elseif (g == Max) H = 2 + (b - r)/C;
            elseif (b == Max)   H = 4 + (r - g)/C;
            end;
            H=H*pi/3;
            
            
            
            j=285 + floor(S*cos(H));              % koordinat silinder 3-D
            i=350 - floor(S*sin(H)/4.0 + V);     % ke tampilan 2-D
            
            
            
            HSV_Edge(i,j,1)=r;
            HSV_Edge(i,j,2)=g;
            HSV_Edge(i,j,3)=b;
            
            R = double(r) / 255;
            G = double(g) / 255;
            B = double(b) / 255;
            
            maxrgb = max(R,max(G,B));
            minrgb = min(R,min(G,B));
            V = maxrgb;
            delta = maxrgb - minrgb;
            
            if maxrgb == 0
                S = 0;
                H = 0;
            else
                S = delta / maxrgb;
            end;
            if R == maxrgb
                % Di antara kuning dan magenta
                H = mod(((G-B) / delta),6);
            elseif G == maxrgb
                %    Di antara cyan dan kuning
                H = 2 + (B-R) / delta;
            else
                % Di antara magenta dan cyan
                H = 4 + (R-G) / delta;
            end
            
            H = H * 60;
            
            if H < 0
                H = H+360;
            end
            
            dataHSV(1,j) = H;
            dataHSV(2,j) = S;
            dataHSV(3,j) = V;
        end;
    end;
end;


%model hexacone
for b=0:255
    for g=0:255
        for r=0:255
            
            Max = max(r,max(g,b));
            Min = min(r,min(g,b));
            C = Max-Min;
            V = Max;            % hitung Value atau Luninance
            
            if (Max == Min) S = 0;         % hitung Saturation
            else  S = C;
            end;
            
            if (Max==Min) H=0;                   % hitung Hue
            elseif (r == Max)   H = ((g - b))/C;
            elseif (g == Max) H = 2 + (b - r)/C;
            elseif (b == Max)   H = 4 + (r - g)/C;
            end;
            H=H*pi/3;
            
            j=285 + floor(S*cos(H));              % koordinat silinder 3-D
            i=350 - floor(S*sin(H)/4.0 + V);     % ke tampilan 2-D
            
            if ((r==b&&g==255) || (r==g&&b==255) || (b==g&&r==255) ...
                    || (r==255&&g==255) || (g==255&&b==255) || (b==255&&r==255)...
                    || (b==0&&g==0)|| (r==0&&g==0)|| (b==0&&r==0) || (b==r&&g==0)...
                    || (r==g&&b==0)|| (b==g&&r==0) || (b==255&&r==0)...
                    || (b==255&&g==0) || (g==255&&r==0) || (g==255&&b==0) || ...
                    (r==255&&b==0)|| (r==255&&g==0) || (r==g&&g==b))
                HSV_Edge(i,j,1)=r;
                HSV_Edge(i,j,2)=g;
                HSV_Edge(i,j,3)=b;
                
                
                
            end;
        end;
    end;
end;
figure(4), imshow(uint8(HSV_Edge));

