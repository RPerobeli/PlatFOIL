function [af] = CriarDATdeAirfoil(airfoil)
% % [[Writing iaf data into file------------------------------------------]]
    af.x = flipud(airfoil.UpperX);
    af.z = flipud(airfoil.UpperY);
    af.x = [af.x; airfoil.LowerX];
    af.z = [af.z; airfoil.LowerY];
    F1="RodrigoFoil";
    F2=num2str([af.x af.z]);
    F=strvcat(F1,F2);
    fileName=['RodrigoFoil' '.dat'];
    dlmwrite(fileName,F,'delimiter','')
end

