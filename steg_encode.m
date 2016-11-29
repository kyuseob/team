function [ output ] = steg_encode( cover, key, message )
% STEG_ENCODE ǥ�� �̹����� �޽����� �����մϴ�.
% ����� ���� ���� ���� �׷��� �ַ���� ����Ͽ� �޽����� ǥ���� ���Խ�ŵ�ϴ�.
% �̹���. �޽����� 2 ������ ��ȯ�ǰ� �ֵ����� �������ϴ�.
% ǥ�� �̹�����  ��. �����ʹ� ���� ����� ����Ͽ� ���ڵ��˴ϴ�.
% �ڵ� ��ü�� �̹��� ��ü�� �ݺ������� ����� �ֽ��ϴ�.

n = 7; % Block code bits
k = 3; % Block code parity bits
capacity = 1026; % ������ �� �ִ� �ִ� ��� ��Ʈ �� 
addpath('./lib');

% �޼����� 2������ ��ȯ�ϱ�
data = dec2bin(message);
data = arrayfun(@(x) padarray((data(x, :) - '0'), [0, 8 - numel(data(x, :))], 0, 'pre'), 1:size(data, 1), 'UniformOutput', false);
data = cell2mat(data);
data = padarray(data, [0, capacity - numel(data)], 0, 'post');
data = transpose(data);
data = reshape(data, [k, numel(data) / k]);
data = transpose(data);

% �̹����� HSL�� ��ȯ
hsl_img = cover;
for col = 1:size(hsl_img, 2)
    for row = 1:size(hsl_img, 1)
        pixel = double(hsl_img(row, col, :)) / 255;
        hsl_img(row, col, :) = rgb2hsl(pixel) * 255;
    end
end

% ���� ���ڵ� 2���� �޼���
pol = cyclpoly(n,k);
parmat = cyclgen(n,pol);
genmat = gen2par(parmat);
data = arrayfun(@(x) encode(data(x, :), n, k, 'linear/binary', genmat), 1:size(data, 1), 'UniformOutput', false);
data = cell2mat(data);

% �ֵ��� ������ �Ӻ���
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

% Ŀ�� �̹����� ������ �ֵ��� �����ϱ�
output = cover;
for col = 1:size(output, 2)
    for row = 1:size(output, 1)
        hsl = double(hsl_img(row, col, :)) / 255;
        hsl(3) = double(lum(row, col)) / 255;
        output(row, col, :) = hsl2rgb(hsl) * 255;
    end
end
end
