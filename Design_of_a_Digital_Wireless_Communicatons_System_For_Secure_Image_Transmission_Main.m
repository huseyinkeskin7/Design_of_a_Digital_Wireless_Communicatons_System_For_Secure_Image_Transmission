%% Hüseyin Berk Keskin HBK
%% 20201706019
%% EEE409 Communication Project - FINAL PROJECT Task 3

clc, clear, close all

%% ***************** System Parameters ************************
%% Communications Unit parameters
M = 2; % modulation order: M=2 binary;
K0 = 10; % Carrier frequency multiplier
Tb = 1; % bit interval(sec)
ts = 0.01; % sampling time of the pulse (for Matlab realization)
symbol_dur = Tb*ts;
N_samp = Tb/ts; 
Ac = 10; % Carrier amplitude
br = 1/Tb; % Bit rate
Fc = br *K0; % Carrier frequency

%%%%%%%%%%%%%%%%%%%%%%%%Input Image and Convert to Bin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Im = imread('hbk.jpg');

img_gray = rgb2gray(Im); % Convert to RGB grayscale 
bIm = reshape(de2bi(img_gray(:), 8, 'left-msb')', [], 1)'; % Convert image to binary stream
Nbits = length(bIm); % Number of bits in the binary stream
sig_dur = Nbits * Tb;
t = (0:ts:sig_dur - ts);

%%%%%%%%%%%%%%%%%%%%%%%%SCRAMBLE OPERATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s_key = randi([0, 1], 1, Nbits);
s_dat = xor(bIm, s_key);

%% **************************** Binary PSK Modulation *****************************
t4b=(0:ts:Tb-ts);% sampling times of a single bit pulse
psk_mod = zeros(1, Nbits * length(t4b));
for i = 1:Nbits
    first = (i - 1) * length(t4b) + 1; 
    last = i * length(t4b); 
    if s_dat(i) == 1
        psk_mod(first:last) = Ac * cos(2 * pi * Fc * t4b); % Modulate bit 1
    else
        psk_mod(first:last) = -Ac * cos(2 * pi * Fc * t4b); % Modulate bit 0
    end
end

% ********************* Received signal r_RX *******************
r_RX=psk_mod; %Noiseless

%%%%%%%%%%%%%%%%%DEMODULATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y_demod=Ac*r_RX.*cos(2*pi*Fc*t);

%%%%%%%%%%% Design matched filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_matched = pulse(t4b, Tb, Ac); 

%%%%%%%% Compute the output of the Matched filter%%%%%%%%%%%%%%
yRX = conv(y_demod,h_matched,'same') * ts;

%%%%%%%%%%%%%%Sample the matched filter output%%%%%%%%%%%%%%%%%%
t0=(N_samp/2)+1;
t_samp=(t0:N_samp:Nbits*N_samp);
y_samp=yRX(t_samp);

%=============Normalized amatched filter output=======
yn_samp = y_samp/max(y_samp);
y_samp_norm = y_samp / max(y_samp);

%%%%%%%%%%%%%%%%%%%%%%% Data detection%%%%%%%%%%%%%%%%%%
det_data=unitstep(y_samp_norm);


%%%%%%%%%%%%%%%%%%%%%%%%%ConstructionImage%%%%%%%%%%%%%%
bbIm = xor(det_data, s_key);
recover_byt= reshape(bbIm, 8, []).';
recover_pix= bi2de(recover_byt, 'left-msb');
Im_out= reshape(recover_pix, size(img_gray));
beIm = det_data;
be = reshape(beIm, 8, []).';
pix_eve = bi2de(be, 'left-msb');
eIm = reshape(pix_eve, size(img_gray));

%%%%%%%%%%%%%%%%%%%%%%%%%%% Output Image %%%%%%%%%%%%%%%%
figure;
subplot(131); 
imshow(Im); 
title('Original Image');
subplot(132); imshow(uint8(eIm)); 
title('Eve Image');
subplot(133); imshow(uint8(Im_out)); 
title('Bob Image');


