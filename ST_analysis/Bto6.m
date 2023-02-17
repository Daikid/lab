function dir_IR = Bto6(B_format)
%%
%B_formatはcell(1,4)の形で受け取る
%dir_IRはcell(1,6)の形で返す

%%
dir_IR = cell(1,7);

Omni = B_format{1,1};
FB = B_format{1,2};
LR = B_format{1,3};
UD = B_format{1,4};

F = 0.5 * (Omni + FB);
B = 0.5 * (Omni - FB);
L = 0.5 * (Omni + LR);
R = 0.5 * (Omni - LR);
U = 0.5 * (Omni + UD);
D = 0.5 * (Omni - UD);

dir_IR{1,1} = Omni;
dir_IR{1,2} = F;
dir_IR{1,3} = B;
dir_IR{1,4} = L;
dir_IR{1,5} = R;
dir_IR{1,6} = U;
dir_IR{1,7} = D;

end
