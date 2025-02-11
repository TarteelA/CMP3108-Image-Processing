%This is an edited version of [7]
%Task 5: Robust method
%Import Picture
RealPicture = imread('IMG_07.jpg');
mean = mean2(RealPicture);
s = std2(RealPicture);
figure(12), imshow(RealPicture);
title('Import Picture');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Change picture to grayscale
GrayPicture = rgb2gray(RealPicture);
mean = mean2(GrayPicture);
s = std2(GrayPicture);
figure(13), imshow(GrayPicture);
title('Greyscale Picture Change');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Rescale picture
RescalePicture = myPicture_Resize(GrayPicture, 0.5, 0.5);
mean = mean2(RescalePicture);
s = std2(RescalePicture);
figure(14), imshow(RescalePicture);
title('Picture Greyscale Rescale');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Histogram before enhancing
HistogramPicture = RescalePicture(:,:,1);
figure(15), imhist(HistogramPicture);
title('Figure Histogram Plot');

%Picture enhancing before binarisation
EnhancementPicture = imadjust(RescalePicture);
mean = mean2(EnhancementPicture);
s = std2(EnhancementPicture);
figure(16), imshow(EnhancementPicture);
title('Picture Enhancement');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Histogram after enhancing
HistogramEnhancementPicture = EnhancementPicture(:,:,1);
figure(17), imhist(HistogramEnhancementPicture);
title('Enhancement Histogram');

%Picture Binarisation
BinaryPicture = imbinarize(EnhancementPicture, 0.26);
mean = mean2(BinaryPicture);
s = std2(BinaryPicture);
figure(18), imshow(BinaryPicture);
title('Picture In Black & White');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Border detection
BorderPicture = edge(EnhancementPicture, 'canny', [0.03, 0.17], 0.9);
mean = mean2(BorderPicture);
s = std2(BorderPicture);
figure(19), imshow(BorderPicture);
title('Edge Picture Detection');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Segmentation
se = strel('disk', 4');
ClosedPicture = imclose(BorderPicture, se);
mean = mean2(ClosedPicture);
s = std2(ClosedPicture);
figure(20), imshow(ClosedPicture), title('Picture Closed');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

FillPicture = imfill(ClosedPicture,'holes');
mean = mean2(FillPicture);
s = std2(FillPicture);
figure(21), imshow(FillPicture), title('Picture Fill');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

se = strel('disk', 2');
OpenedPicture = imopen(FillPicture, se);
SegmentPicture = OpenedPicture;
mean = mean2(SegmentPicture);
s = std2(SegmentPicture);
figure(22), imshow(SegmentPicture);
title('Picture Segment');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Recognition Object
[B, L] = bwboundaries(SegmentPicture, 'noholes');
for i = 1 : length(B)
    temp = L;
    temp(temp ~= i) = 0;
    temp(temp == i) = 1;
    [r, c] = find(temp == 1);
    [Arectangle, Brectangle, area, circumference] = minimumboundryrectangle(c, r, 'a');
    line(Arectangle(:),Brectangle(:),'color','r');
    ratio = l_w_ratio(Arectangle, Brectangle);
    
    if ratio < 1.5
        L(L == i) = 30;
    
    elseif ratio < 3
        L(L == i) = 50;
    
    else
        L(L == i) = 70;
    end
end
mean = mean2(L);
s = std2(L);
figure(23), imshow(label2rgb(L, @jet, 'k'));
title('Recognise Object')
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Task 6: Performance evaluation
%Load ground truth data
GT = imread("C:\Users\tutia\OneDrive\Desktop\Y3 Computer Science\Semester A\CMP3108M Image Processing\Assessment\Assignment_GT\IMG_07_GT.png");
L_GT = label2rgb(GT, 'prism', 'k', 'shuffle');
mean = mean2(L_GT);
s = std2(L_GT);
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Change coloured picture to grayscale
Grey_L_GT = im2gray(L_GT);
%Ground truth data picture process binarisation
Binary_L_GT = imbinarize(Grey_L_GT);
%figure, imshow(L_GT)

m = im2gray(L);
mask = false(size(m));
mask(25:end-25, 25:end-25) = true;
BW = activecontour(m, mask, 2500);
mean = mean2(BW);
s = std2(BW);
figure(24), imshow(BW);
title('Segment Picture Activecontour');
title(['Mean is : ' num2str(mean),'   Standard Deviation is : ' num2str(s)]);

%Calculate Dice score, precision, and recall [10,11]
similarity = dice(BW, Binary_L_GT);
figure(25), imshowpair(BW, Binary_L_GT);
title(['Dice Index : ' num2str(similarity)]);
 
precision = bfscore(BW, Binary_L_GT);
figure(26), imshowpair(BW, Binary_L_GT);
title(['Precision : ' num2str(precision)]);

recall = bfscore(BW, Binary_L_GT);
figure(27), imshowpair(BW, Binary_L_GT);
title(['Recall : ' num2str(recall)]);