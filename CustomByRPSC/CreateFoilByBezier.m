function [airfoil] = CreateFoilByBezier(PopDec,index,NumNos)
%Developed by Rodrigo Perobeli S. Costa
%Create a custom airfoil for each one of the population based on Bezier
%Curves
[r,c] = size(PopDec);

airfoil = Airfoil.createNACA4('0012', NumNos);

%Criação das Bezier superior e inferior:
BupperX = zeros(c/4 +2,1);
BupperX(c/4+2) =1;
BupperY = zeros(c/4 +2,1);
BlowerX = zeros(c/4 +2,1);
BlowerX(c/4+2) =1;
BlowerY = zeros(c/4 +2,1);

for i = 2: length(BupperX)-1
    BupperX(i) = PopDec(index, i-1);
    BupperY(i) = PopDec(index, i-1+c/4);
    BlowerX(i) = PopDec(index, i-1 + c/2);
    BlowerY(i) = PopDec(index, i-1 + 3*c/4);
end

dt = 1/(NumNos);
t = 0:dt:1;
x = zeros(length(t),1);
y = zeros(length(t),1);
x2 = zeros(length(t),1);
y2 = zeros(length(t),1);

n = length(BupperX)-1;
A = factorial(n);
for i = 1:length(t)
    for j = 1:length(BupperX)
        y(i) = y(i) + BupperY(j)*(A/(factorial(j-1)*factorial(n-j+1)))...
            *t(i)^(j-1)*(1-t(i))^(n-j+1);
        x(i) = x(i) + BupperX(j)*(A/(factorial(j-1)*factorial(n-j+1)))...
            *t(i)^(j-1)*(1-t(i))^(n-j+1);
        y2(i) = y2(i) + BlowerY(j)*(A/(factorial(j-1)*factorial(n-j+1)))...
            *t(i)^(j-1)*(1-t(i))^(n-j+1);
        x2(i) = x2(i) + BlowerX(j)*(A/(factorial(j-1)*factorial(n-j+1)))...
            *t(i)^(j-1)*(1-t(i))^(n-j+1);
    end
end
y2 = -y2;


plot(x,y, x2,y2, airfoil.UpperX, airfoil.UpperY, 'k', airfoil.LowerX, airfoil.LowerY, 'k');
drawnow;

airfoil.UpperY = y;
airfoil.UpperX = x;
airfoil.LowerY = y2;
airfoil.LowerX = x2;

end

