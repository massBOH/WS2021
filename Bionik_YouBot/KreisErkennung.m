% Kamera Kreiserkennung
% input : ROS, 'weiss'/'schwarz', 'einzel'/'doppel', ...
%           Durchmesser, Abstand, 'Dtol', wert, 'Sens', wert, ...
%           'Bild'
% input : ROS, 'w'/'s', '1'/'2', Durchmesser, Abstand
function [Ausgabe]=KreisErkennung(ROS,varargin)
%##################################################
% Default Werte
DurchmesserToleranz=3;
Sensitivity=0.8;%85;
ColorCode=[];
Modus=[];
Durchmesser=[];
Abstand=[];
AbstandToleranz=3;
Bildlich=0;
%##################################################
% Input Verarbeitung
% Zusuchende Farbe
inds = find(strcmpi('w',varargin), 1);
if ~isempty(inds)
    ColorCode='bright';
end
inds = find(strcmpi('s',varargin), 1);
if ~isempty(inds)
    ColorCode='dark';
end
% Modus
inds = find(strcmpi('1',varargin), 1);
if ~isempty(inds)
    Modus='einzel';
    Durchmesser=cell2mat(varargin(inds+1));
end
inds = find(strcmpi('2',varargin), 1);
if ~isempty(inds)
    Modus='doppel';
    Durchmesser=cell2mat(varargin(inds+1));
    Abstand=cell2mat(varargin(inds+2));
end
% Durchmessertoleranz
inds = find(strcmpi('Dtol',varargin), 1);
if ~isempty(inds)
    DurchmesserToleranz=cell2mat(varargin(inds+1));
end
% Abstandtoleranz1
inds = find(strcmpi('Atol',varargin), 1);
if ~isempty(inds)
    AbstandToleranz=cell2mat(varargin(inds+1));
end
% Sensibilitaet der Kreiserkennung
inds = find(strcmpi('Sens',varargin), 1);
if ~isempty(inds)
    Sensitivity=cell2mat(varargin(inds+1));
end
% Bildliche Ausgabe
inds = find(strcmpi('Bild',varargin), 1);
if ~isempty(inds)
    Bildlich=1;
end
%##################################################
% Struktur Bearbeitende Werte und Ausgabe
Data=struct('KameraX',[],'KameraY',[],'KameraZ',[],'KameraR',[],...
    'DepthX',[],'DepthY',[],...
    'RealX',[],'RealY',[],'RealZ',[],'RealR',[],'RealD',[],...
    'Marker',[],'MValue',[]);
tempData=struct('X',[],'Y',[],'Z',[],'D',[],...
    'KX',[],'KY',[],'KR',[],'DX',[],'DY',[],'Dis',[]);
tempData2=tempData;
Ausgabe=struct('X',[],'Y',[],'Z',[],'D',[],'Dis',[]);
%##################################################
% holen der Bilder, RGB und Depth, und umwandeln des RGB in Gray
imgDepth=readImage(ROS.Kamera.SubDepth.LatestMessage);
imgRGB=readImage(ROS.Kamera.SubRGB.LatestMessage);
imgGray=rgb2gray(imgRGB);
%##################################################
% Kreiserkennung und Markerkontrolle
Rmin=6;  % Durchmesser Einstellung,
Rmax=18; % der zur suchenden [px] einheitlichen Kreise
% nur die Kreise suchen die gefragt sind, farblich
% aussortieren der Kreise ohne Marker
[centers, radii] = imfindcircles(imgGray,[Rmin Rmax],...
    'ObjectPolarity',ColorCode,'Sensitivity',...
    Sensitivity,'Method','twostage');
if ~isempty(centers)
    for i=1:size(centers,1)
        Data(i).KameraX=centers(i,1);
        Data(i).KameraY=centers(i,2);
        Data(i).KameraR=radii(i);
        Data(i).MValue=imgGray(round(Data(i).KameraY,0),round(Data(i).KameraX,0));
        % Marker ist bei weiss schwarz und vice versa
        if strcmp(ColorCode,'bright')
            if 0<=Data(i).MValue && Data(i).MValue<200
                Data(i).Marker=1;
            else
                Data(i).Marker=0;
            end
        elseif strcmp(ColorCode,'dark')
            if 201<Data(i).MValue && Data(i).MValue<=255
                Data(i).Marker=1;
            else
                Data(i).Marker=0;
            end
        end
    end
    %##################################################
    % Berechnung des Durchmessers mittels der Tiefe Z
    % nur bei denen die den Marker haben
    DepthPosX=zeros(size(Data,2),1);
    DepthPosY=zeros(size(Data,2),1);
    for j=1:size(Data,2)
        if Data(j).Marker==1
            DepthPosX(j)=round(Data(j).KameraX+(Data(j).KameraX+40)*0.1,0);
            DepthPosY(j)=round(Data(j).KameraY+(Data(j).KameraY-50)*0.1,0);
            Data(j).DepthX=DepthPosX(j);
            Data(j).DepthY=DepthPosY(j);
            % Achtung Bildrand, schauen ob wir uns nahe des Rands befinden
            area=5;
            if DepthPosX(j)<1+area || DepthPosX(j)>640-area
                %disp('x<0 || x>640');
            elseif DepthPosY(j)<1+area || DepthPosY(j)>480-area
                %disp('y<0 || y>480');
            else
                % mehrere Z werte zusammen rechnen und teilen
                % fals der mittlerste Werte mal 'nan' ist
                anzahl=0;
                Zsum=0;
                for u=-area:2:area
                    for v=-area:2:area
                        if ~isnan(imgDepth(DepthPosY(j)+u,DepthPosX(j)+v))
                            Zsum=Zsum+imgDepth(DepthPosY(j)+u,DepthPosX(j)+v);
                            anzahl=anzahl+1;
                        end
                    end
                end
                Data(j).KameraZ=Zsum/anzahl;
                Z0=1000*Data(j).KameraZ;%mm
                FaktorZ=(Z0/530);
                R0=round((Data(j).KameraR*FaktorZ),2);
                Data(j).RealZ=570-6-Z0;
                Data(j).RealR=R0;
                Data(j).RealD=R0*2;
                %##################################################
                % Berechnen der X Y Position
                % nur bei denen die den Richtigen Durchmesser haben
                if Data(j).RealR<(Durchmesser/2)+(DurchmesserToleranz/2) &&...
                        Data(j).RealR>(Durchmesser/2)-(DurchmesserToleranz/2)
                    Y0=round((240-Data(j).KameraY)*FaktorZ,2);% mm 240 == Bildhoehe/2
                    X0=round((320-Data(j).KameraX)*FaktorZ,2);% mm 320 == Bildbreite/2
                    Data(j).RealY=70+Y0;    % Nullpunktverschub
                    Data(j).RealX=-13-X0;   % Nullpunktverschub
                end
            end
        end
    end
    %##################################################
    % Nach Modus entscheiden was gemacht wird
    tempcnt=1;
    for l=1:size(Data,2)
        if ~isempty(Data(l).RealX)
            tempData(tempcnt).X=Data(l).RealX;
            tempData(tempcnt).Y=Data(l).RealY;
            tempData(tempcnt).Z=Data(l).RealZ;
            tempData(tempcnt).D=Data(l).RealR*2;
            tempData(tempcnt).KX=Data(l).KameraX;
            tempData(tempcnt).KY=Data(l).KameraY;
            tempData(tempcnt).KR=Data(l).KameraR;
            tempData(tempcnt).DX=Data(l).DepthX;
            tempData(tempcnt).DY=Data(l).DepthY;
            tempcnt=tempcnt+1;
        end
    end
    if strcmp(Modus,'einzel')
        % Kreise einzeln mit X Y Z D Werte ausgeben
        for o=1:size(tempData,2)
            Ausgabe(o).X=tempData(o).X;
            Ausgabe(o).Y=tempData(o).Y;
            Ausgabe(o).Z=tempData(o).Z;
            Ausgabe(o).D=tempData(o).D;
        end
    elseif strcmp(Modus,'doppel')
        % Kreise Abstand zueinander berechnen
        % bei dem wo der Abstand stimmt Mittelpunkt berechnen und ausgeben
        discnt=1;
        auscnt=1;
        Distanz=zeros(sum(1:size(tempData,2)-1),1);
        for m=1:size(tempData,2)
            for n=m+1:size(tempData,2)
                Distanz(discnt)=sqrt( (tempData(m).X-tempData(n).X)^2+...
                    (tempData(m).Y-tempData(n).Y)^2)+2;
                if Distanz(discnt)<Abstand+AbstandToleranz && ...
                        Distanz(discnt)>Abstand-AbstandToleranz
                    tempData2(auscnt).Dis=Distanz(discnt);
                    tempData2(auscnt).X=(tempData(m).X+tempData(n).X)/2;
                    tempData2(auscnt).Y=(tempData(m).Y+tempData(n).Y)/2;
                    tempData2(auscnt).D=(tempData(m).D+tempData(n).D)/2;
                    tempData2(auscnt).KX=(tempData(m).KX+tempData(n).KX)/2;
                    tempData2(auscnt).KY=(tempData(m).KY+tempData(n).KY)/2;
                    tempData2(auscnt).KR=(tempData(m).KR+tempData(n).KR)/2;
                    tempData2(auscnt).DX=round((tempData(m).DX+tempData(n).DX)/2,0);
                    tempData2(auscnt).DY=round((tempData(m).DY+tempData(n).DY)/2,0);
                    area=1;
                    anzahl=0;
                    Zsum=0;
                    for p=-area:1:area
                        for q=-area:1:area
                            if ~isnan(imgDepth(tempData2(auscnt).DY+p,tempData2(auscnt).DX+q))
                                Zsum=Zsum+imgDepth(tempData2(auscnt).DY+p,tempData2(auscnt).DX+q);
                                anzahl=anzahl+1;
                            end
                        end
                    end
                    tempData2(auscnt).Z=570-round(1000*(Zsum/anzahl),2);%mm
                    auscnt=auscnt+1;
                end
                discnt=discnt+1;
            end
        end
        for o=1:size(tempData2,2)
            Ausgabe(o).X=tempData2(o).X;
            Ausgabe(o).Y=tempData2(o).Y;
            Ausgabe(o).Z=tempData2(o).Z;
            Ausgabe(o).D=tempData2(o).D;
            Ausgabe(o).Dis=tempData2(o).Dis;
        end
    end
    %##################################################
    % Bildliche Ausgabe
    if Bildlich==1
        %imshow(imgRGB);
        imshowpair(imgRGB,imgDepth,'montage');
        % Einzeichnen der Kreise, '1' die echten, '2' die Mittelpunkte
        if strcmp(Modus,'einzel')
            for g=1:size(tempData,2)
                viscircles([tempData(g).KX tempData(g).KY], ...
                    tempData(g).KR,'LineStyle','-','EdgeColor','r');
                viscircles([tempData(g).DX+640 tempData(g).DY], ...
                    tempData(g).KR,'LineStyle','-','EdgeColor','b');
                txt=strcat('X:',num2str(round(Ausgabe(g).X,3)),...
                    ' Y:',num2str(round(Ausgabe(g).Y,3)),...
                    ' Z:',num2str(round(Ausgabe(g).Z,3)),...
                    ' D:',num2str(round(Ausgabe(g).D,3)));
                text(tempData(g).KX+10,tempData(g).KY,txt,'Color','green','FontSize',14)
            end
        elseif strcmp(Modus,'doppel')
            for h=1:size(tempData2,2)
                viscircles([tempData2(h).KX tempData2(h).KY], ...
                    tempData2(h).KR,'LineStyle','-','EdgeColor','r');
                txt=strcat('X:',num2str(round(Ausgabe(h).X,3)),...
                    ' Y:',num2str(round(Ausgabe(h).Y,3)),...
                    ' Z:',num2str(round(Ausgabe(h).Z,3)),...
                    ' D:',num2str(round(Ausgabe(h).D,3)),...
                    ' Dis:', num2str(round(Ausgabe(h).Dis,3)));
                text(tempData2(h).KX+10,tempData2(h).KY,txt,'Color','black','FontSize',14)
            end
        end
    end
end

end