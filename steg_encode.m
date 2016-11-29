function [ output ] = steg_encode( cover, key, message )
% STEG_ENCODE 표지 이미지에 메시지를 삽입합니다.
% 사용자 지정 스테 가노 그래피 솔루션을 사용하여 메시지를 표지에 포함시킵니다.
% 이미지. 메시지는 2 진으로 변환되고 휘도에서 숨겨집니다.
% 표지 이미지의  값. 데이터는 선형 블록을 사용하여 인코딩됩니다.
% 코드 전체가 이미지 전체에 반복적으로 흩어져 있습니다.

n = 7; % Block code bits
k = 3; % Block code parity bits
capacity = 1026; % 숨겨질 수 있는 최대 허용 비트 수 
addpath('./lib');

% 메세지를 2진수로 변환하기
data = dec2bin(message);
data = arrayfun(@(x) padarray((data(x, :) - '0'), [0, 8 - numel(data(x, :))], 0, 'pre'), 1:size(data, 1), 'UniformOutput', false);
data = cell2mat(data);
data = padarray(data, [0, capacity - numel(data)], 0, 'post');
data = transpose(data);
data = reshape(data, [k, numel(data) / k]);
data = transpose(data);

% 이미지를 HSL로 변환
hsl_img = cover;
for col = 1:size(hsl_img, 2)
    for row = 1:size(hsl_img, 1)
        pixel = double(hsl_img(row, col, :)) / 255;
        hsl_img(row, col, :) = rgb2hsl(pixel) * 255;
    end
end

% 선형 인코드 2진수 메세지
pol = cyclpoly(n,k);
parmat = cyclgen(n,pol);
genmat = gen2par(parmat);
data = arrayfun(@(x) encode(data(x, :), n, k, 'linear/binary', genmat), 1:size(data, 1), 'UniformOutput', false);
data = cell2mat(data);

% 휘도의 데이터 임베딩
lum = hsl_img(:, :, 3);
bits = padarray(data, [0, numel(lum) - numel(data)], 'circular', 'post');
rng(key);
perm = randperm(length(bits));
data = zeros(1, length(bits));
for index = 1:length(data)
    data(index) = bits(perm(index));
end
data = reshape(data, [size(lum, 1), size(lum, 2)]);
lum = bitset(lum, 1, data);

% 커버 이미지에 수정된 휘도를 설정하기
output = cover;
for col = 1:size(output, 2)
    for row = 1:size(output, 1)
        hsl = double(hsl_img(row, col, :)) / 255;
        hsl(3) = double(lum(row, col)) / 255;
        output(row, col, :) = hsl2rgb(hsl) * 255;
    end
end
end
