% Simulation for COST231 model (Extension of HATA model)
clc;
clear all;
hte=100; %height of transmitting base station antenna in meters
hre=10; %height of receiving antenna of mobile station in meters
sdA=3; %standard deviation of noise for Base station A
sdB=5; %standard deviation of noise for Base station B
noiseA=sdA*randn(1,2000);
noiseB=sdB*randn(1,2000);
cm=3; % for urban=0 dB and metro=3 dB
disp('Frequency Range for COST231 model : 1500 to 2000 MHz')
fc=input('Put the frequency value (MHz) : ')
for d=1:2000
     % path loss calculation Between Mobile & Base station A
     LA(d)=46.3+(33.9*log10(fc))-(13.82*log10(hte))-((1.11*log10(fc)-0.7)*(10)+(1.56*log10(fc)-0.8))+((44.9-6.55*log10(hte))*log10(d))+cm;
     %path loss calculation Between Mobile & Base station B
     LB(d)=46.3+(33.9*log10(fc))-(13.82*log10(hte))-((1.11*log10(fc)-0.7)*(10)+(1.56*log10(fc)-0.8))+((44.9-6.55*log10(hte))*log10(2001-d))+cm;
     % path loss calculation for free space model
     LF(d)=32.4+20*log10(fc)+20*log10(d);

     % Received power at A without noise
     SrA(d)=60-LA(d);
     % Received power at B without noise
     SrB(d)=60-LB(d);
     % Received power at A with Gaussian noise sd=3
     PrA(d)=60-LA(d)+noiseA(d) ;
     % Received power at B with Gaussian noise sd=5
     PrB(d)=60-LB(d)+noiseB(d);
end
figure(1)
grid on
xlabel('Distance(m)');
ylabel('Received Power (dBm)');
hold on;
plot (PrA);
hold on
plot (PrB,'m');
hold on
legend('From Base Station A','From Base Station B');