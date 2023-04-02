clc; clear; close all; warning off all;

%membaca citra rgb
Img = imread('objek.jpg');
figure, imshow(Img)

% mengkonversi citra rgb ke dalam citra grayscale
grayImage = double (rgb2gray(Img));
figure, imshow(grayImage,[])

% melakukan segmentasi citra menggunakan algoritma k-means
numberOfClasses = 2;
indexes = kmeans(grayImage(:),numberOfClasses);
classImage = reshape(indexes,size(grayImage));

figure, imshow(classImage, [])
colormap(gcf, parula)

% melakukan seleksi untuk mendapatkan region objek
class = zeros(size(grayImage));
area = zeros(numberOfClasses,1);

for n = 1:numberOfClasses
    class(:,:,n) = classImage==n;
    area(n) = sum(sum(class(:,:,n)));
end

[~, min_area] = min(area);

% melakukan pemilihan objek berdasarkan luas region yang terkecil
object = classImage==min_area;
figure, imshow(object)

% melakukan operasi morfologi untuk menyempurnakan hasil segmentasi
bw = medfilt2(object, [5 5]);
figure, imshow(bw)

bw = bwareaopen(bw, 5000);
figure, imshow(bw)

%melakukan ekstraksi bounding box terhadap object
s = regionprops(bw, 'BoundingBox');
bbox = cat(1,s.BoundingBox);

% menampilkan bounding box hasil segmentasi
RGB = insertShape(Img,'FilledRectangle',bbox,'Color','yellow','Opacity',0.3);
RGB = insertObjectAnnotation(RGB,'rectangle',bbox,'Objek','TextBoxOpacity',0.9,'FontSize',18);
figure, imshow(RGB)
title('Objek Yang Terdeteksi')

