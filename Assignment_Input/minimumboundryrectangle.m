%This is an edited version of [7]
function [Arectangle, Brectangle, area, circumference] = minimumboundryrectangle(a, b, metrix)
%Minimumboundaryrectangle calculate minimal bounding rectangle points in plane
if (nargin < 3) || isempty(metrix)
    metrix = 'a';

elseif ~ischar(metrix)
    error 'Metrix must be a character flag'

else
    % Check for area and perimeter
    metrix = lower(metrix(:)');
    indicator = validatestring(metrix, {'area','perimeter'});
    
    if isempty(indicator)
        %error 'Metrix Doesn't match area or perimeter''
    end

    %Keep first letter
    metrix = metrix(1);
end

%Information preprocessing
a = a( : );
b = b( : );
c = length(a);

if c ~= length(b)
    error 'x and y has to be exactly same size'
end

if c > 3
    borders = convhull(a, b);
    a = a(borders);
    b = b(borders);
    num_borders = length(a) - 1;

elseif c > 1
    %W has to be 3 or 2
    num_borders = c;
    a(end + 1) = a(1);
    b(end + 1) = b(1);

else
    %W has to be 1 or 0
    num_borders = c;
end

%Look for bounding rectangle
switch num_borders
    case 0
        %Null
        Arectangle = [];
        Brectangle = [];
        area = [];
        circumference = [];
        return
     
    case 1
        %Filled with single point
        Arectangle = repmat(a, 1, 5);
        Brectangle = repmat(b, 1, 5);
        area = 0;
        circumference = 0;
        return

    case 2
        %Fiiled with two points
        Arectangle = a([1 2 2 1 1]);
        Brectangle = b([1 2 2 1 1]);
        area = 0;
        circumference = 2 * sqrt(diff(a).^2 + diff(b).^2);
        return
end

%Three or extra points
%Will require 2x2 matrix
Rotation_matrix = @(theta) [cos(theta) sin(theta); -sin(theta) cos(theta)];
%Get angle border of hull polygon
indicator = 1:(length(a)-1);
angle_borders = atan2(b(indicator+1) - b(indicator), a(indicator+1) - a(indicator));
%Shift angle into first quadrant
angle_borders = unique(mod(angle_borders,pi/2));
%Check every border of hull
num_angles = length(angle_borders);
area = inf;
circumference = inf;
met = inf;
ab = [a, b];

for i = 1 : num_angles
    %Rotate information
    rotation = Rotation_matrix(-angle_borders(i));
    abr = ab * rotation;
    abminimum = min(abr, [], 1);
    abmaximum = max(abr, [], 1);

    %Area and Perimeter
    i_Area = prod(abmaximum - abminimum);
    i_Circumference = 2 * sum(abmaximum - abminimum);

    if metrix == 'a'
        i_M = i_Area;

    else
        i_M = i_Circumference;
    end

    %New metrix value for existing interval
    if i_M < met
        %Keep
        met = i_M;
        area = i_Area;
        circumference = i_Circumference;
        rectangle = [abminimum; [abmaximum(1), abminimum(2)]; abmaximum; [abminimum(1), abmaximum(2)]; abminimum];
        rectangle = rectangle * rotation';
        Arectangle = rectangle( : , 1);
        Brectangle = rectangle( : , 2);
    end
end
end
