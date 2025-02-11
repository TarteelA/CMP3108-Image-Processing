%This is an edited version of [7]
function ResizePicture = myPicture_Resize(Picture, A, B)
[Height, Width] = size(Picture);
ResizePicture = zeros(round(Height * A), round(Width * B));
rotation = [A 0 0; 0 B 0; 0 0 1];

for i = 1 : Height * A
    for j = 1 : Width * B
        pixel = [i j 1] / rotation;
        Bfloat = pixel(1) - floor(pixel(1));
        Afloat = pixel(2) - floor(pixel(2));
        if pixel(1) < 1
            pixel(1) = 1;
        end

        if pixel(1) > Height
            pixel(1) = Height;
        end

        if pixel(2) < 1
            pixel(2) = 1;
        end

        if pixel(2) > Width
            pixel(2) = Width;
        end

        left_top_pixel = [floor(pixel(1)) floor(pixel(2))];
        right_top_pixel = [floor(pixel(1)) ceil(pixel(2))];
        left_bottom_pixel = [ceil(pixel(1)) floor(pixel(2))];
        right_bottom_pixel = [ceil(pixel(1)) ceil(pixel(2))];

        left_top_int = (1 - Bfloat) * (1 - Afloat);
        right_top_int = Bfloat * (1 - Afloat);
        left_bottom_int = (1 - Bfloat) * Afloat;
        right_bottom_int = (Bfloat * Afloat);

        ResizePicture(i,j) = left_top_int * Picture(left_top_pixel(1), left_top_pixel(2)) + ...
            right_top_int * Picture(right_top_pixel(1), right_top_pixel(2)) + ...
            left_bottom_int * Picture(left_bottom_pixel(1), left_bottom_pixel(2)) + ...
            right_bottom_int * Picture(right_bottom_pixel(1), right_bottom_pixel(2));
    end
end

ResizePicture = uint8(ResizePicture);
