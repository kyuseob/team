function message = txt2mes(txt_name)
fid = fopen(txt_name, 'r');

if fid == -1
    error('txt파일 이름이 잘못 입력되었습니다.')
end

message = fscanf(fid, '%s');
fclose(fid);
    

