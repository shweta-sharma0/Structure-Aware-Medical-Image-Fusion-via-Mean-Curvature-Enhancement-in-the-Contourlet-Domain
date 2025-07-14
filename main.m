clc; clear; close all;

%% Load MRI and CT Images
img1 = im2double(imread('5(A).png'));  % MRI Image
img2 = im2double(imread('5(B).png'));  % CT Image

% Resize to the same size
img1 = imresize(img1, [256, 256]);
img2 = imresize(img2, [256, 256]);

%% Display Input Images
figure;
subplot(1,2,1); imshow(img1); title('MRI Image');
subplot(1,2,2); imshow(img2); title('CT Image');

%% Step 1: Contourlet Transform Decomposition
pyr_levels = 3;
[low1, high1] = contourlet_decompose(img1, pyr_levels);
[low2, high2] = contourlet_decompose(img2, pyr_levels);

%% Step 2: Fusion

% Low-frequency fusion (Weighted average)
weight1 = 0.5;
weight2 = 0.5;
fused_low = weight1 * low1 + weight2 * low2;


% Apply curvature filter only at Level 3
fused_high = cell(size(high1));
fused_high{3} = curvature_filter(fused_high{3}, 15, 0.0005);  % Apply filter to highest level only

% High-frequency fusion (Max-abs rule)

for i = 1:pyr_levels
    mask = abs(high1{i}) > abs(high2{i});
    fused_high{i} = mask .* high1{i} + (~mask) .* high2{i};
end


%% Step 3: Reconstruct the Fused Image
fused_image = contourlet_reconstruct(fused_low, fused_high);

%% Step 4: Display Results
figure;
subplot(1,3,1); imshow(img1); title('MRI Image');
subplot(1,3,2); imshow(img2); title('CT Image');
subplot(1,3,3); imshow(fused_image); title('Fused Image');

imwrite(fused_image, "C:\Users\Shweta Sharma\Desktop\Objective Metrics\02\05.png");

%% ------------ Supporting Functions ------------

% Contourlet Decomposition
function [low, high] = contourlet_decompose(img, levels)
    low = img;
    high = cell(1, levels);
    for i = 1:levels
        blurred = imgaussfilt(low, 20);  % Low-pass filter
        high{i} = low - blurred;
        low = imresize(blurred, 0.5);
    end
end

% Contourlet Reconstruction
function img = contourlet_reconstruct(low, high)
    img = low;
    for i = length(high):-1:1
        img = imresize(img, 2) + high{i};
    end
end

% Curvature Filter (PDE-based)
function output = curvature_filter(img, iterations, dt)
    img = double(img);
    for k = 1:iterations
        [Ix, Iy] = gradient(img);
        grad_mag = sqrt(Ix.^2 + Iy.^2 + eps);

        Nx = Ix ./ grad_mag;
        Ny = Iy ./ grad_mag;

        [Nxx, ~] = gradient(Nx);
        [~, Nyy] = gradient(Ny);

        curvature = Nxx + Nyy;
        img = img + dt * curvature;
    end
    output = max(min(img, 1), 0);  % Clip to [0,1]
end
