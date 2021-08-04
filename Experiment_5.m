% Simulation for HATA model
clc;
clear all;
hte=50; %height of transmitting base station antenna in meters
(200/150/100)
hre=3; %height of receiving antenna of mobile station in meters
sdA=3; %standard deviation of noise for Base station A
sdB=5; %standard deviation of noise for Base station B
noiseA=sdA*randn(1,500);
noiseB=sdB*randn(1,500);
disp('uplink freq=635/835/1235 MHz')
disp('downlink freq=680/880/1280 MHz')
fc=input('Put the uplink/downlink frequency (MHz): ')
for d=1:50
     % path loss calculation Between Mobile & Base station A
     LA(d)=(69.55+26.6*log10(fc))-(13.82*log10(hte))-((1.11*log10(fc)- 0.7)*(10)+(1.56*log10(fc)-0.8))+((44.9-6.55*log10(hte))*log10(d));
     %path loss calculation Between Mobile & Base station B
     LB(d)=(69.55+26.6*log10(fc))-(13.82*log10(hte))-((1.11*log10(fc)- 0.7)*(10)+(1.56*log10(fc)-0.8))+((44.9-6.55*log10(hte))*log10(51-(d)));
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