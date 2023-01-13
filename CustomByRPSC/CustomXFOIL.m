classdef CustomXFOIL < PROBLEM
% <single> <binary> <large/none> <constrained>

%--------------------------------------------------------------------------

    properties(Access = private)
        P;	% Profit of each item
        W;  % Weight of each item
    end
    methods
        %% Default settings of the problem
        function Setting(obj)
            % Parameter setting
            obj.M = 1;
            % definição do numero de variaveis de controle, 4*numero de
            % pontos de controle de bezier (xUp, yUp, xLow, yLow)
            if isempty(obj.D); obj.D = 16; end
            obj.encoding = ones(1,obj.D); %Enconding 1 é acodificacao numeros REAIS - olhar o arquivo PROBLEM.m do platemo para verificar outras codificacoes
            thickness = 0.2;
            obj.lower = zeros(1, obj.D);
            obj.upper = zeros(1, obj.D);
            
            %travamento dos X
            obj.lower(1,1) = 0;
            obj.lower(1,1+obj.D/2)=0;
            obj.upper(1,1) = 0.02;
            obj.upper(1,1+obj.D/2)=0.02;
            obj.lower(1,2) = 0.02;
            obj.lower(1,2+obj.D/2) = 0.02;
            obj.upper(1,2) = 0.3;
            obj.upper(1,2+obj.D/2)=0.5;
            obj.lower(1,3) = 0.3;
            obj.lower(1,3+obj.D/2) = 0.5;
            obj.upper(1,3) = 0.6;
            obj.upper(1,3+obj.D/2)=0.7;
            obj.lower(1,4) = 0.6;
            obj.lower(1,4+obj.D/2) = 0.7;
            obj.upper(1,4) = 0.6;
            obj.upper(1,4+obj.D/2)=0.8;
            
            %travamento de Y
            obj.upper(1,5) = thickness;
            obj.upper(1,5+obj.D/2) = thickness;
            obj.upper(1,6) = thickness*3/4;
            obj.upper(1,6+obj.D/2)= thickness*3/4;
            obj.lower(1,6) = thickness/4;
            obj.lower(1,6+obj.D/2)= -thickness/4; %admite valores positivos no dorso inferior
            obj.upper(1,7) = thickness*3/4;
            obj.upper(1,7+obj.D/2)= thickness*3/4;
            obj.lower(1,7+obj.D/2)= -thickness/4; %admite valores positivos no dorso inferior
            obj.upper(1,8) = thickness/2;
            obj.upper(1,8+obj.D/2)= thickness/2;
            obj.lower(1,8+obj.D/2)= -thickness/2;  %admite valores positivos no dorso inferior
           
            
            
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            alfa = 3;
            Re = 1.5e5;
            M = 0.00;
            cont = 0;
            PopObj = CalculaPolarPlatEmo(PopDec, alfa, Re, M, cont);
            PopObj = -PopObj;
        end
        %% Calculate constraint violations
        function PopCon = CalCon(obj,PopDec)
            
            PopCon(:,1) = PopDec(:,5+obj.D/2)- PopDec(:,5) ;
            PopCon(:,2) = PopDec(:,6+obj.D/2)- PopDec(:,6) ;
            PopCon(:,3) = PopDec(:,7+obj.D/2)- PopDec(:,7) ;
            PopCon(:,4) = PopDec(:,8+obj.D/2)- PopDec(:,8) ;
        end
    end
end
