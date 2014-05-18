function [foreground] = getForeground( I )
%Initialize mask and foreground
mask = zeros(size(I));
foreground = zeros(size(I));
%number of pixels for initial mask
nrPx = size(I,1)*0.3;
nrPy = size(I,2)*0.3;
%Initial mask
mask(nrPx:end-nrPx, nrPy:end-nrPy) = 1;
%Segment image into foreground and background using active contour
bw = activecontour(I,mask);

[row, col] = find(bw);
foreground(min(row):max(row), min(col):max(col)) = 1;
end

