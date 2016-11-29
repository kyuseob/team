function [ output ] = steg_decode( stego, key )
% stego �̹����� decode�մϴ�.
% stego �̹����� �ֵ����� 2������ �����մϴ�.
% ���� ��� �ڵ带 ����Ͽ� ������ �����մϴ�.
% �׸��� �ؽ�Ʈ�� 2������ ǥ���մϴ�.

n = 7; % Block code bits
k = 3; % Block code parity bits
capacity = 1026; % ������ �� �ִ� ��� ��Ʈ
addpath('./lib');

% �̹����� HSL�� ��ȯ ��Ű��
hsl_img = stego;
for col = 1:size(hsl_img, 2)
    for row = 1:size(hsl_img, 1)
        pixel = double(hsl_img(row, col, :)) / 255;
        hsl_img(row, col, :) = rgb2hsl(pixel) * 255;
    end
end

% �ֵ����� ������ ����
lum = hsl_img(:, :, 3);
bits = bitget(lum, 1);
rng(key);
perm = randperm(numel(bits));
data = zeros(1, numel(bits));
for index = 1:numel(bits)
    data(perm(index)) = bits(index);
end

% ����� ������ decode
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

% ���ڵ��� �����͸� 2�� �ؽ�Ʈ�� �ؼ�
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
