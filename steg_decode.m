function [ output ] = steg_decode( stego, key )
% stego 이미지를 decode합니다.
% stego 이미지의 휘도에서 2진수를 추출합니다.
% 선형 블록 코드를 사용하여 오류를 수정합니다.
% 그리고 텍스트를 2진수로 표현합니다.

n = 7; % Block code bits
k = 3; % Block code parity bits
capacity = 1026; % 숨겨질 수 있는 허용 비트
addpath('./lib');

% 이미지를 HSL로 변환 시키기
hsl_img = stego;
for col = 1:size(hsl_img, 2)
    for row = 1:size(hsl_img, 1)
        pixel = double(hsl_img(row, col, :)) / 255;
        hsl_img(row, col, :) = rgb2hsl(pixel) * 255;
    end
end

% 휘도에서 데이터 추출
lum = hsl_img(:, :, 3);
bits = bitget(lum, 1);
rng(key);
perm = randperm(numel(bits));
data = zeros(1, numel(bits));
for index = 1:numel(bits)
    data(perm(index)) = bits(index);
end

% 추출된 데이터 decode
pol = cyclpoly(n,k);
parmat = cyclgen(n,pol);
genmat = gen2par(parmat);
output = zeros(capacity / k, k);
for block = 1:(capacity / k)
    for index = (7 * (block - 1) + 1):(capacity * n / k):numel(data)
        [decoded, error] = decode(data(index:(index + 6)), n, k, 'linear/binary', genmat);
        if ~error(1)
            output(block, :) = decoded;
            break;
        end
    end
end

% 디코딩된 데이터를 2진 텍스트로 해석
output = transpose(output);
output = reshape(output, 1, numel(output));
output = output(1:capacity - mod(capacity, 8));
output = reshape(output, 8, numel(output) / 8);
output = transpose(output);
output = fliplr(output);
output = bi2de(output);
output = char(output);
output = transpose(output);
end
