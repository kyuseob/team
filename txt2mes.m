function message = txt2mes(txt_name)
fid = fopen(txt_name, 'r');

if fid == -1
    error('txt파일 이름이 잘못 입력되었습니다.')
end

fid2 = fopen('zxc.txt', 'w');
b=0;
while 1
    a = fgetl(fid);
    if a == -1
        break
    end
    c = [a, '\n'];
    fprintf(fid2, '%s', c);
end
fid2 = fopen('zxc.txt', 'r');
message = fscanf(fid2, '%s');
fclose(fid);
fclose(fid2);