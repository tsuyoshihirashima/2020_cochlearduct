function lut=BR_Lut()

% blue to magenta LUT
for i=1:128
    b_lut(i,1:2)=(i-1)/127;
    b_lut(i,3)=1;
end
for i=1:128
    r_lut(i,1)=1;
    r_lut(i,2:3)=1-(i-1)/127;
end

lut(1:128,1:3)=b_lut;
lut(129:256,1:3)=r_lut;