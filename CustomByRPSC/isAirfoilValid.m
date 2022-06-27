function [booleanResult] = isAirfoilValid(AF)
booleanResult = true;
var = (AF.UpperY - AF.LowerY);
for i = 2:length(var)-1
    if(var(i) < 0.002)
        booleanResult = false;
        break;
    end
end

end

