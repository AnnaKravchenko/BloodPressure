%  round values ??to 0-5-10-15-20
function roundNumber = round2(number)
%   MATLAB function rounds each element of X to the nearest integer
number = round(number);
%   round to nearest of the target points
for i = 0:5:20
    %   find the distance (less then 2) to the target points
    if abs(number-i)<=2
        roundNumber = i;
    end
end
end