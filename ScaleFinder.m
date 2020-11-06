function [Scale] =  ScaleFinder(BigCoin)
%This function allows for us to find the scale since we will know the area
%of the biggest coin and what kind of coin it is
%This allows for the script to work no matter how far the camera is from
%the coins

if BigCoin == 1
     Scale = .72; %A quarter's area is .72 square inches
elseif BigCoin == 2
     Scale = .55; %A nickel's area is .55 square inches
elseif BigCoin == 3
     Scale = .44; %A penny's area is .44 square inches
elseif BigCoin == 4
     Scale = .39; %A dime's area is .39 square inches
else
    BigCoin = input('Please follow directions \n');
    pause(1)
    [Scale] =  ScaleFinder(BigCoin);
end
