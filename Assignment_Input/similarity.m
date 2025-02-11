%This code is an edited version of [12]
function [precision, recall] = similarity(BW,Binary_L_GT)
    i = BW;
    j = Binary_L_GT;

addition = i + j;
TruePositive = length(find(addition == 2));

subtraction = i - j;
FalsePositive = length(find(subtraction == -1));
FalseNegative = length(find(subtraction == 1));

precision = TruePositive / (TruePositive + FalsePositive);
recall = TruePositive / (TruePositive + FalseNegative);

end