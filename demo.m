% 이미지 변형시키기
cover = imread('examples/emma.jpg');%imread는 이미지를 불러오는 함수
[ stego ] = steg_encode(cover, 123, 'Hello World!');
imwrite(stego, 'examples/stego.png');%inwrite는 이미지에 텍스트를 삽입하는 함수

% 숨겨진 텍스트를 추출하는 것
stego = imread('examples/stego.png');
[ message1 ] = steg_decode(stego, 123);

% 변형된 이미지로부터 숨겨진 텍스트를 추출하는 것
stego = imread('examples/stego_modified.png');
[ message2 ] = steg_decode(stego, 123);
