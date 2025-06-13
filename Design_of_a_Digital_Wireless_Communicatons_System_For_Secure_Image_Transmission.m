%% Hüseyin Berk Keskin HBK
%% 20201706019
%% EEE409 Communication Project - FINAL PROJECT Task 2

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

Es=(Ac^2/2)*Tb;
Eb=Es;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Eb_No_dB = 0:12; % Eb/No signal-to-noise ratio
Eb_No_lin = 10.^(0.1*Eb_No_dB);
theoretical_BER = qfunc(sqrt(2 * Eb_No_lin));

%%%%%%%%%%%%%%%%%%%%%%%%Input Image and Convert to Bin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Im = imread('hbk.jpg');

img_gray = rgb2gray(Im); % Convert to RGB grayscale 
bIm = reshape(de2bi(img_gray(:), 8, 'left-msb')', [], 1)'; % Convert image to binary stream
Nbits = length(bIm); % Number of bits in the binary stream
sig_dur = Nbits * Tb;
t = (0:ts:sig_dur - ts);

BER = zeros(1,length(Eb_No_dB));

for j = 1:length(BER)

    %% **************************** Binary PSK Modulation *****************************
    t4b=(0:ts:Tb-ts);% sampling times of a single bit pulse
    psk_mod = zeros(1, Nbits * length(t4b));
    for i = 1:Nbits
        first = (i - 1) * length(t4b) + 1; 
        last = i * length(t4b); 
        if bIm(i) == 1
            psk_mod(first:last) = Ac * cos(2 * pi * Fc * t4b); % Modulate bit 1
        else
            psk_mod(first:last) = -Ac * cos(2 * pi * Fc * t4b); % Modulate bit 0
        end
    end

    % ***********  Generate Gaussian noise samples *****************
    No = Eb/(Eb_No_lin(j));
    sigma=sqrt(Es*No);
    white_noise= sigma* randn(1,length(t));

    % ********************* Received signal r_RX *******************
    r_RX=psk_mod+white_noise;

    %%%%%%%%%%%%%%%%%DEMODULATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y_demod=Ac*r_RX.*cos(2*pi*Fc*t);
    
    %%%%%%%%%%% Design matched filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t4b=(0:ts:Tb-ts);
    h_matched = ones(1, N_samp) * ts; 

    %%%%%%%% Compute the output of the Matched filter%%%%%%%%%%%%%%
    yRX = conv(y_demod,h_matched,'same');

    %%%%%%%%%%%%%%Sample the matched filter output%%%%%%%%%%%%%%%%%%
    t0=(N_samp/2)+1;
    t_samp=(t0:N_samp:Nbits*N_samp);
    y_samp=yRX(t_samp);
    %=============Normalized amatched filter output=======
    yn_samp = y_samp/max(y_samp);

    %%%%%%%%%%%%%%%%%%%%%%% Data detection%%%%%%%%%%%%%%%%%%
    det_data=yn_samp > 0;

    %%%%%%%%%%%%%%%%Compute BER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    count=0;
    for k=1:Nbits
        if det_data(k) ~= bIm(k)
            count=count+1;
        end
    end

    
    BER(j) = count/Nbits;
    %%%%%%%%%%%%%%%%%%%%%%%%%ConstructionImage%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%Output Image %%%%%%%%%%%%%%%%
    recover_byt = reshape(det_data, 8, [])';
    recover_pix = bi2de(recover_byt, 'left-msb');
    Im_out = cell(1, length(Eb_No_dB));
    Im_out{j} = reshape(recover_pix, size(img_gray));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%% BER PLOT %%%%%%%%%%%%%%%%
figure;
semilogy(Eb_No_dB, BER, 'r--s', 'LineWidth', 1.5);
hold on;
semilogy(Eb_No_dB, theoretical_BER, 'b-o', 'LineWidth', 1.5);
grid on;
xlabel('Eb/N0');
ylabel('BER');
legend('Simulated', 'Theoretical');
title('BER Performance Comparison of BPSK System');

%%%%%%%%%%%%%%%%%%%%%%%%%%% Output Image %%%%%%%%%%%%%%%%
figure;
subplot(121);
imshow(img_gray);
title('Original Image')

subplot(122);
imshow(Im_out{end}, []);
title(sprintf('Recovere Image'))


% ************************** End of the program ***************************