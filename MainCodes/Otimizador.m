clear all;
close all;
clc

% addpath('G:\.shortcut-targets-by-id\1XDk6wQTx4foD_mU0sHXgVBABd1_sAZzc\Rodrigo Perobeli\PlatEMO\PlatEMO\PlatEMO','-frozen');
addpath('D:\platemo\PlatEMO\PlatEMO','-frozen');

% platemo('algorithm', @GA, 'problem', @SOP_F1,'N', 50);
% platemo('algorithm', @NSGAII, 'problem', @DTLZ2,'M',5, 'D', 40, 'maxFE', 20000);
historico = [];
historicoValidado = [];
minimos = [];

tamPop = 50;
%Lembrar de mudar no CustomXFOIL
alfa = 10;
Re = 1000000;
M = 0.0;

% for i = 1:5
%        res = platemo('algorithm', @GA, 'problem', @CustomWeld, 'N', 50, 'maxFE', 10000);
%     historico = [historico, res];
%     FE =  1.1047*res(:,1).^2.*res(:,2) + 0.04811*res(:,3).*res(:,4).*(14.0+res(:,2));
%     minimos = [minimos,min(FE)];
% end
% display(minimos);
% display(min(minimos))


% platemo('algorithm', @GA, 'problem', @CustomXFOIL, 'N', tamPop, 'maxFE', 5000);
for i = 1:1
    res = platemo('algorithm', @GA, 'problem', @CustomXFOIL, 'N', tamPop, 'maxFE', 5000);
    glide = CalculaPolarPlatEmo(res, alfa, Re, M, 0);
    glideValidado = PolarValidator(res, alfa, Re, M);
    
    historico = [historico, glide];
    historicoValidado = [historicoValidado, glideValidado];
    minimos = [minimos, max(historico(:,i))];
end
display(minimos);
display(max(minimos));
