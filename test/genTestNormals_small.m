rootFile = '.';
testResult = [rootFile '/3dNormalResult.txt'];
I = imread('../data/bathroom_0048/00000253_rgb.jpg');
%testResult = [rootFile '/temp.txt'];


fid = fopen(testResult,'r');

N = zeros(8000,1);
a = load('vocab.mat');


cnt = 0;
while (~feof(fid))
    %str = '';
    str = fscanf(fid,'%s', 1 );
    subdir = '';
    imageFile = str;
    flag = 0;
    newDir = [rootFile '/' subdir];
    imageSaveFile = [newDir '/' imageFile];
    
    if ~isdir(newDir) 
        mkdir(newDir);
    end
    
    for i = 1 : 8000
        N(i) = fscanf(fid, '%f', 1);
    end
    %keyboard;
    N2 = assignToNormals(N, a.vocabs{1}.normals);
    N3 = reshape(N2, [20,20,3]);
    N3 = permute(N3, [2,1,3]);
    N3 = uint8(N3 * 128 + 128);
    N4 = imresize(N3, [size(I, 1) size(I, 2)]);
    N5 = uint8(I * 0.7 + N4 * 0.3);
    %matSaveFile = strrep(imageSaveFile,'jpg','mat');
    %save(matSaveFile, 'N3');
    imwrite(N5, imageSaveFile); 
    fprintf('%d\n',cnt);
    cnt = cnt + 1;
    %keyboard;
end

fclose(fid);
