function [glide] = GerarPolarFile(airfoil, Re, M )
%CalculaPolar função que calculará a eficiencia do perfil para um dado alfa
%  Essa funcao recebe parametros do aerofolio
glide = [];
addpath('D:\platemo\PlatEMO\PlatEMO','-frozen');
a = 1;

cont = 0;
for p = 1:a
    cont = cont +1;
    
    polar.cl = [];
    polar.cd= [];
    polar.cm= [];
    polar.glide = [];
    %malha:
    NumNos = 190;
    %Armazenamento
    savePolar = 'RodrigoFoilPolar.txt';

    alpha0=-15;
%     alpha0 = 5;
    dalpha=2.5;
    alphaf=15;
%     alphaf = 15;
    alfas = alpha0:dalpha:alphaf;


    %parte de definição do xfoil:
    xf=XFOIL;
    pplot = true;
    xf.KeepFiles = true; % Set it to true to keep all intermediate files created (Airfoil, Polars, ...)
    xf.Visible = true;    % Set it to false to hide XFOIL plotting window
    
    %CRIAR AEROFOLIOS A PARTIR DE .DAT FILE
    AF = Airfoil.createNACA4('0012', NumNos);
    AF.UpperY = input.Up(:,2);
    AF.UpperX = input.Up(:,1);
    AF.LowerY = input.Low(:,2);
    AF.LowerX = input.Low(:,1);
    
    xf.Airfoil = AF;
    
    
    %xf.addFiltering(20);
    xf.addOperation(Re, M);
    xf.addIter(200);
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
    finished = xf.wait(100);
    if finished
        disp('XFOIL analysis finished.');
        xf.readPolars;
        if size(xf.Polars,1) == 0
            disp('UATARRÉU');
            glide = [glide; -100];
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
    %             figure(1);
    %             plot(polar.cl(:,1), polar.cl(:,2),'b');
    %             title('Lift coef');
    %             figure(2);
    %             plot(polar.cd(:,1), polar.cd(:,2),'r');
    %             title('Drag coef');
                figure(3);
                plot(polar.glide(:,1), polar.glide(:,2),'g');
                title('Glide Ratio');
    %             figure(4);
    %             plot(polar.cd(:,2), polar.cl(:,2),'k');
    %             title('Cl x Cd');
            end
            
        end
    else
        xf.kill;
    end
    if length(glide) < p
        disp('Taí');
        glide = [glide; -100];
    end
    
    %disp("killing XFOIL");
    cmd = "taskkill /F /im xfoil.exe";
    [status,result]= system(cmd);

    
end

end

