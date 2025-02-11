%This is an edited version of [7]
%Task 1: Pre-processing
%Import Picture
Picture = imread('IMG_01.jpg');
figure, imshow(Picture)
title('Picture Import')

%Convert picture to grayscale
GrayPicture = rgb2gray(Picture);
figure, imshow(GrayPicture)
title('Picture Grayscale Change')

%Resize picture
ResizePicture = myPicture_Resize(GrayPicture,0.5,0.5);
figure, imshow(ResizePicture)
title('Picture Rescale Grayscale')

%Produce histogram before enhancement
HistPicture = ResizePicture(:,:,1);
figure, imhist(HistPicture)
title('Histogram Figure Plot')

%Enhance picture before binarisation
EnhancePicture = imadjust(ResizePicture);
figure, imshow(EnhancePicture)
title('Picture Enhance')

%Histogram after enhancement
HistEnhancePicture = EnhancePicture(:,:,1);
figure, imhist(HistEnhancePicture)
title('Enhance Histogram')

%Picture Binarisation
BinarizationPicture = imbinarize(EnhancePicture,0.28);
figure, imshow(BinarizationPicture)
title('Picture In Binary')

%Task 2: Edge detection
EdgePicture = edge(EnhancePicture,'canny',[0.1, 0.2],1.4);
figure, imshow(EdgePicture)
title('Picture Detection Edge')

%Task 3: Simple segmentation
ss = strel('disk',3');
ClosePicture = imclose(EdgePicture,ss);
FillPicture = imfill(ClosePicture,'holes');

ss = strel('disk',1');
OpenPicture = imopen(FillPicture,ss);

SegmentationPicture = OpenPicture;
figure, imshow(SegmentationPicture)
title('Picture Segmentation')

%Task 4: Object Recognition
figure, imshow(OpenPicture)
title('Recognition Round')

hold on
% Detect round objects
[BrightMiddles,BrightRadi,BrightMetric] = imfindcircles(OpenPicture, ...
[20 25],'ObjectPolarity','bright','Sensitivity',0.95,'EdgeThreshold',0.1);
[Middels,Radi] = imfindcircles(OpenPicture,[20 25],'ObjectPolarity','dark');
BrightH = viscircles(BrightMiddles,BrightRadi,'Color',[0.8500 0.3250 0.0980]);
H = viscircles(Middels,Radi);
hold off

L = logical(SegmentationPicture);
B = regionprops(L,'Centroid');
title('Objects Label');
hold on

for C = 1:numel(B)
    D = B(C).Centroid;
    text(D(1),D(2),sprintf('%d',C),'HorizontalAlignment','center','VerticalAlignment','middle');
end
hold off

[B,L] = bwboundaries(SegmentationPicture,'noholes');
MatrixRound = [2 4 6 8 9 10];
MatrixNonRound = [1 3 5 7 11];
L(ismember(L,MatrixNonRound)) = 1;
L(ismember(L,MatrixRound)) = 5;
figure, imshow(label2rgb(L,@jet,'k'));
title('Recognition Object')