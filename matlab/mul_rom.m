clear all
%generates the twiddle factor for the multipliers in PEB
%16
x(28,1) = cos(2*pi/16);
x(28,2) = -sin(2*pi/16);
x(29,1) = cos(2*pi/8);
x(29,2) = -sin(2*pi/8);
x(30,1) = cos(6*pi/16);
x(30,2) = -sin(6*pi/16);
x(31,1) = cos(2*pi/8);
x(31,2) = -sin(2*pi/8);
x(32,1) = 0;
x(32,2) = -1;
x(33,1) = cos(2*pi*6/16);
x(33,2) = -sin(2*pi*6/16);
x(34,1) = cos(2*pi*3/16);
x(34,2) =- sin(2*pi*3/16);
x(35,1) = cos(2*pi*6/16);
x(35,2) = -sin(2*pi*6/16);
x(36,1) = cos(2*pi*9/16);
x(36,2) = -sin(2*pi*9/16);

%8
x(19,1) = 1;
x(19,2) = 1;
x(20,1) = 1;
x(20,2) = 1;
x(21,1) = 1;
x(21,2) = 1;
x(22,1) = cos(2*pi/8);
x(22,2) = -sin(2*pi/8);
x(23,1) = 0;
x(23,2) = -1;
x(24,1) = cos(2*pi*3/8);
x(24,2) = -sin(2*pi*3/8);
x(25,1) = cos(2*pi/8);
x(25,2) = -sin(2*pi/8);
x(26,1) = 0;
x(26,2) = -1;
x(27,1) = cos(2*pi*3/8);
x(27,2) = -sin(2*pi*3/8);

%5

x(10,1) = 0;
x(10,2) = sin(4*pi/5)+sin(2*pi/5);
x(11,1) = cos(4*pi/5);
x(11,2) = 0;
x(12,1) = 0;
x(12,2) = sin(4*pi/5)+sin(2*pi/5);
x(13,1) = 0;
x(13,2) = -sin(4*pi/5);
x(14,1) = 1;
x(14,2) = 0;
x(15,1) = 0;
x(15,2) = sin(4*pi/5)-sin(2*pi/5);
x(16,1) = 0;
x(16,2) = -sin(4*pi/5);
x(17,1) = cos(4*pi/5);
x(17,2) = 0;
x(18,1) = 0;
x(18,2) = sin(4*pi/5)-sin(2*pi/5);


%3

x(1,1) = 0;
x(1,2) = -sin(2*pi/3);
x(2,1) = 1;
x(2,2) = 0;
x(3,1) = 0;
x(3,2) = -sin(2*pi/3);
x(4,1) = 1;
x(4,2) = 0;
x(5,1) = 1;
x(5,2) = 0;
x(6,1) = 0;
x(6,2) = -sin(2*pi/3);
x(7,1) = 1;
x(7,2) = 0;
x(8,1) = 1;
x(8,2) = 0;
x(9,1) = 0;
x(9,2) = -sin(2*pi/3);

dlmwrite('xr_rom.txt', x(:,1),'\n');
dlmwrite('xi_rom.txt', x(:,2),'\n');   
