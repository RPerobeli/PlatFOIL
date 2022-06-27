function [glide2] = PolarValidator(res, alfa, Re, M)
    addpath('D:\platemo\Tutorial','-frozen');
    airfoil = CreateFoilByBezier(res, 1, 50);
    AF = CriarDATdeAirfoil(airfoil);
    input.Up(:,1) = airfoil.UpperX;
    input.Up(:,2) = airfoil.UpperY;
    input.Low(:,1) = airfoil.LowerX;
    input.Low(:,2) = airfoil.LowerY;
    glide2 = CalculaPolarDAT(alfa, Re, M, 0, input);
end

