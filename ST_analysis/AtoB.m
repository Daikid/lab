function B_format = AtoB(A_format)
%%
%A_formatはcell(1,4)で受け取る
%B_formatはcell(1,4)で返す
ch1 = A_format{1,1}; %FLU
ch2 = A_format{1,2}; %FRD
ch3 = A_format{1,3}; %BLD
ch4 = A_format{1,4}; %BRU

Omni = (ch1 + ch2 + ch3 + ch4);
FB = ch1 + ch2 - ch3 - ch4;%前が正
LR = ch1 - ch2 + ch3 - ch4;%左が正
UD = ch1 - ch2 - ch3 + ch4;%上が正

B_format = cell(1,4);

B_format{1,1} = 0.5 * Omni;
B_format{1,2} = sqrt(3) * 0.5 * FB;
B_format{1,3} = sqrt(3) * 0.5 * LR;
B_format{1,4} = sqrt(3) * 0.5 * UD;

end
