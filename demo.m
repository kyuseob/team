% 이미지 변형시키기
cover = imread('C:\Users\BOOK 4\Desktop\team\original.jpg');%imread는 이미지를 불러오는 함수
[ stego ] = steg_encode(cover, 123, 'He is a sweet guy');
imwrite(stego,'C:\Users\BOOK 4\Desktop\team\output.png');%inwrite는 이미지에 텍스트를 삽입하는 함수

% 숨겨진 텍스트를 추출하는 것
stego = imread('C:\Users\BOOK 4\Desktop\team\output.png');
[ message1 ] = steg_decode(stego, 123);

