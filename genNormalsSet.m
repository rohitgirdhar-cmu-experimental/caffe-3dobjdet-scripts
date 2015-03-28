addpath(genpath('./depthCompress'));
addpath(genpath('./normalCompress'));
nDict = load('normalCompress/vq_dict.mat');
dDict = load('depthCompress/vq_dict.mat');
n2Src = '/nfs/hn46/dfouhey/deepProcessed/dataTVDenoise/';
src = '/nfs/hn46/dfouhey/deepProcessed/data/';
cvxccSrc = '/nfs/hn46/dfouhey/deepProcessed/cvxcc2/';
gravitySrc ='/nfs/hn46/dfouhey/deepProcessed/gravity/'; 
vpSrc = '/nfs/hn46/dfouhey/deepProcessed/vps/';

%this controls which source is loaded
srcNum = 160;
matSize = 20;

filesDir = dir(src);
sequences = {};
for i=1:numel(filesDir)
    name = filesDir(i).name;
    if name(1) ~= '.', sequences{end+1} = filesDir(i).name; end
end


parfor srcNum = 1 : 599

sequence = sequences{srcNum};

sequenceDir = [src '/' sequence '/'];
tvSequenceDir = [n2Src '/' sequence '/' ];

fpath = ['labels_normal/' sequence '_label.txt'];
if exist(fpath, 'file') || exist([fpath '.lock'], 'dir')
  continue;
end
unix(['mkdir -p ' fpath '.lock']);

fid = fopen(fpath, 'w'); 

depths = dir([sequenceDir '/*depth.mat']);
for di=1:numel(depths)
    
    name = depths(di).name;
    imname = strrep(name,'depth.mat','rgb.jpg');
    nname = strrep(name,'depth.mat','norm.mat');
    bname = strrep(name,'depth.mat','boundary.png');
    vpname = strrep(name,'depth.mat','vp.mat');
    gname = strrep(name,'depth.mat','g.mat');
	  fileName = [sequence '/'  imname ];

    if exist(fileName, 'file')
      continue
    end

    fprintf('%d / %d\n',di,numel(depths));

    
    %Load all the data
    a = load('vocab.mat');
    nd2 = load([tvSequenceDir '/' nname]); [N2,NM2] = reconstructNormals(nd2.N,nDict.dict);
%    keyboard;
    reIm = imresize(N2, [matSize, matSize]);
    [idx, qloss] = assignToCodebook(reIm, a.vocabs{1}.normals);
	
	fprintf(fid, '%s ', fileName);  
	for i = 1 : numel(idx) 
		fprintf(fid, '%d ', idx(i)); 
	end
	fprintf(fid, '\n');

end
fclose(fid); 

unix(['rmdir ' fpath '.lock']);
end
