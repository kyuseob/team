% �̹��� ������Ű��
cover = imread('C:\Users\BOOK 4\Desktop\team\original.jpg');%imread�� �̹����� �ҷ����� �Լ�
[ stego ] = steg_encode(cover, 123, 'This is sweet guy');
imwrite(stego,'C:\Users\BOOK 4\Desktop\team\output.png');%inwrite�� �̹����� �ؽ�Ʈ�� �����ϴ� �Լ�

% ������ �ؽ�Ʈ�� �����ϴ� ��
stego = imread('C:\Users\BOOK 4\Desktop\team\output.png');
[ message1 ] = steg_decode(stego, 123);

% ������ �̹����κ��� ������ �ؽ�Ʈ�� �����ϴ� ��
stego = imread('examples/stego_modified.png');
[ message2 ] = steg_decode(stego, 123);
