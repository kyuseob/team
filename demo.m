% �̹��� ������Ű��
cover = imread('examples/emma.jpg');%imread�� �̹����� �ҷ����� �Լ�
[ stego ] = steg_encode(cover, 123, 'Hello World!');
imwrite(stego, 'examples/stego.png');%inwrite�� �̹����� �ؽ�Ʈ�� �����ϴ� �Լ�

% ������ �ؽ�Ʈ�� �����ϴ� ��
stego = imread('examples/stego.png');
[ message1 ] = steg_decode(stego, 123);

% ������ �̹����κ��� ������ �ؽ�Ʈ�� �����ϴ� ��
stego = imread('examples/stego_modified.png');
[ message2 ] = steg_decode(stego, 123);
