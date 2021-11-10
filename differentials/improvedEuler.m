clear all; clc;

a = 0,
b = 0.5;
h = 5;
dx = (b - a) / h;

xin = a;
yin = 0.5;
slope1 = 0;
slope2 = 0;
slopeuse = 0;

y = yin;
x = xin;

xp = 0;
yp = 3;

yinc = 0;

xv = [x];
yv = [y];

for i = a:dx:b;
    slope1 = (x - y)^2;
    inc1 = slope1 * dx;
    xp = x + dx;
    yp = y + inc1;
    slope2 = ((xp - yp)^2);
    slopeuse = ((slope1 + slope2) / 2);
    yinc = slopeuse * dx;
    x = x + dx;
    y = y +yinc;
    xv = [xv x];
    yv = [yv y];

end

plot(xv, yv);
