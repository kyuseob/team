function message = txt2mes(txt_name)
fid = fopen(txt_name, 'r');

if fid == -1
    error('txt���� �̸��� �߸� �ԷµǾ����ϴ�.')
end

message = fscanf(fid, '%s');
fclose(fid);
    

