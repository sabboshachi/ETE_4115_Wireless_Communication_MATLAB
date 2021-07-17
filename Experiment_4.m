clc
clear all

sampleTime=1/500000;
maxDopplerShift = 200;

delayVector = 1.0e-004*[0 0.0400 0.0800 0.1200];
gainVector = [0 -3 -6 -9];
specDopplerShift = 100;
KFactor = 10;

rayChanObj = rayleighchan(sampleTime, maxDopplerShift, delayVector, gainVector );
rayChanObj.Storehistory = 1; 
ricChanObj= ricianchan(sampleTime, maxDopplerShift, KFactor, delayVector, gainVector, specDopplerShift);
ricChanObj.StoreHistory = 1

hMod = comm.QPSKModulator('BitInput',true,'PhaseOffset',pi/4);

bitsPerFrame = 1000;

mag = randi([0 1],bitsPerFrame, 1);

modSignal = step(hMod, mag);
filter(rayChanObj, modSignal);
filter(ricChanObj, modSignal);

channel_vis(rayChanObj, 'Visualization', 'ir');
channel_vis(rayChanObj, 'Animation','medium');
channel_vis(rayChanObj, 'SampleIndex',1);

delayVector = (0:3)*(4e-6);
gainVector = (0:3)*(-3);


maxDopplerShift = 5
channel_vis(ricChanObj,'Close');
h = scatterplot(0);
title('Received Signal after Rayleigh Fading');
xlabel('In-Phase Amplitude');
ylabel('Quadrature Amplitude');
xlim([-2 2]);
ylim([-2 2]);
grid on

rayChanObj = rayleighchan(sampleTime, maxDopplerShift, delayVector,gainVector );
rayChanObj.Storehistory = 1;
rayChanObj.ResetBeforeFiltering = 0;
numFrame = 100;
bitsPerFrame = 200;

for n=1:numFrame
    mag = randi([0 1],bitsPerFrame, 1);
    modSignal = step(hMod, mag);
    rayFiltSig = filter(rayChanObj, modSignal);
    set(get(get(h,'Children'),'Children'),'XData',real(rayFiltSig(6:end)),'YData',imag(rayFiltSig(6:end)));
    pause(0.05);
    drawnow;
end

close(h);
reset(rayChanObj);

rayChanObj.InputSamplePeriod = 1/500000;
h=scatterplot(0);
title('Received Sifnal after Rayleigh Fading');
xlabel('In-Phase Amplitude');
ylabel('Quadrature Amplitude')
xlim([-2 2]);
ylim([-2 2]);
grid on;

close(h);
reset(rayChanObj);
bitsPerFrame = 1000;
rayChanObj,MaxDopplerShift = 200;
numFrames = 13;
for n=1:numFrames
     mag = randi([0 1],bitsPerFrame, 1);
     modSignal = step(hMod, mag);
     filter(rayChanObj, modSignal);
end
channel_vis(rayChanObj,'Visualization','irw');
channel_vis(rayChanObj,'Animation', 'interframe');
channel_vis(rayChanObj,'Visualization','ir');
channel_vis(rayChanObj,'Animation','medium');
channel_vis(rayChanObj,'SampleIndex',1);
displayEndOfDemoMessage(mfilename)