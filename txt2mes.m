function message = txt2mes(txt_name)
fid = fopen(txt_name, 'r');
message = fscanf(fid, '%s');
fclose(fid)
    
