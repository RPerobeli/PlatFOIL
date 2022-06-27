function [ glide ] = CalculaPolar( PopDec, alfa, Re, M, cont)
%CalculaPolar função que calculará a eficiencia do perfil para um dado alfa
%  Essa funcao recebe parametros do aerofolio
glide = [];
% PopDec = [0 0.23 0.61 0.75 0.055 0.12 0.1 0.03 0 0.23 0.61 0.75 0.055 0.12 0.1 0.03];
% alfa = 10;
% Re = 1e5;
% M = 0.01;
[a,b] = size(PopDec);
for p = 1:a
    cont = cont +1;
    
    polar.cl = [];
    polar.cd= [];
    polar.cm= [];
    polar.glide = [];
    %malha:
    NumNos = 100;
    %Armazenamento
    savePolar = 'Polar.txt';

    alpha0=alfa-5;
    dalpha=1;
    alphaf=alfa+5;
    alfas = alpha0:dalpha:alphaf;
    %n_alpha=4;
    ALFA_INTERESSE = alfa;

    
    %CRIAR AEROFOLIOS A PARTIR DE POPDEC
    AF = CreateFoilByBezier(PopDec,p,NumNos);
    if(isAirfoilValid(AF))
        %parte de definição do xfoil:
        xf=XFOIL;
        pplot = false;
        xf.KeepFiles = false; % Set it to true to keep all intermediate files created (Airfoil, Polars, ...)
        xf.Visible = false;    % Set it to false to hide XFOIL plotting window

        xf.Airfoil = AF;
        %xf.addFiltering(20);
        xf.addOperation(Re, M);
        xf.addIter(100);
        xf.addAlpha(alpha0,true);
        xf.addPolarFile(savePolar);
        xf.addAlpha(alfas);
        xf.addClosePolarFile;
        xf.addQuit;
        xf.run;
        disp('Running XFOIL, please wait...');
        disp(cont);
        %Wait up to 100 seconds for it to finish... 
        %It is possible to run more than one XFOIL instance at the same time
        finished = xf.wait(20);

        if finished
            disp('XFOIL analysis finished.');
            xf.readPolars;
            if size(xf.Polars,1) == 0
                disp('UATARRÉU');
                glide = [glide; -1000];
            else
                if size(xf.Polars,1)~=0
                    nacaMatrix=[xf.Polars{1,1}.Alpha,xf.Polars{1,1}.CL,xf.Polars{1,1}.CD,xf.Polars{1,1}.CM];
                    polar.cl(:,1)= nacaMatrix(:,1);
                    polar.cd(:,1)= nacaMatrix(:,1);
                    polar.cm(:,1)= nacaMatrix(:,1);
                    polar.glide(:,1) = nacaMatrix(:,1);
                    polar.cl(:,2) = nacaMatrix(:,2);
                    polar.cd(:,2) = nacaMatrix(:,3);
                    polar.cm(:,2) = nacaMatrix(:,4);
                    polar.glide(:,2) = polar.cl(:,2)./polar.cd(:,2);

                    % plot
                    % figure(1);
                    % plot(polar.cl(:,1), polar.cl(:,2),'b');
                    % title('Lift coef');
                    % figure(2);
                    % plot(polar.cd(:,1), polar.cd(:,2),'r');
                    % title('Drag coef');
                    % figure(3);
                    % plot(polar.glide(:,1), polar.glide(:,2),'g');
                    % title('Glide Ratio');
                    
                    xf.kill;
                    xf.killExecute;
                    for(i =1:length(polar.glide(:,1)))
                        if(ALFA_INTERESSE == polar.glide(i,1))
                            glide = [glide; polar.glide(i,2)];
                            break;
                        end
                    end
                end
            end
        else
            disp("Comando para matar");
            xf.kill;
            xf.killExecute;
        end

        
    end
    if length(glide) < p
        disp('Taí');
        glide = [glide; -1000];
    end
    
    %disp("killing XFOIL");

        cmd = "taskkill /im xfoil.exe";
        [status,result]= system(cmd);
        delete *.dat;
        delete *.txt;
    
end

end


