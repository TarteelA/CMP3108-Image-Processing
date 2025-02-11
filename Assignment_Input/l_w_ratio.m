%This is an edited version of [7]
function ratio = l_w_ratio(Arectangle, Brectangle)
FirstPoint = [Arectangle(1), Brectangle(1)];
SecondPoint = [Arectangle(2), Brectangle(2)];
ThirdPoint = [Arectangle(3), Brectangle(3)];

FirstLength = sqrt(sum((FirstPoint - SecondPoint) .^ 2));
SecondLength = sqrt(sum((SecondPoint - ThirdPoint) .^ 2));

if FirstLength >= SecondLength
    ratio = FirstLength / SecondLength;
else
    ratio = SecondLength / FirstLength;
end
end