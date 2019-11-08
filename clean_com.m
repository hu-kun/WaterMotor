function clean_com

comtoclean = instrfind;

if isempty(comtoclean)
    return;
end

fclose(comtoclean);
delete(comtoclean);
clear global ard
clear comtoclean;