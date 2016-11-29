function a = mes2txt(message);
fid = fopen('secret.txt', 'w');
fprintf(fid, message);
fclose(fid)