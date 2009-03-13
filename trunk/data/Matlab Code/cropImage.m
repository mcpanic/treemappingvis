function cropImage(im, label, x, y, w, h)

imH = size(im, 1);
imW = size(im, 2);

xx = x+1
yy = y+1

if xx < 1
    xx = 1;
end

if yy < 1
    yy = 1;
end

yh = min(yy+h, imH)
xw = min(xx+w, imW)

if xx < xw & yy < yh
    imCrop = im(yy:yh, xx:xw, :);
    figure; imshow(imCrop);

    imwrite(imCrop, [num2str(label) '.png'], 'png');
end
