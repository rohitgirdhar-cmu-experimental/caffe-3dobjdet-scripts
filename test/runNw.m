addpath('../caffe/matlab/caffe');
model_def_file = '../train/deploy.prototxt';
model_file = '../train/models/finetune_3d_iter_90000.caffemodel';
caffe('init', model_def_file, model_file, 'test');
I = imread('../data/bathroom_0048/00000253_rgb.jpg');
out = caffe('forward', {prepare_image(I)});
out = out{1};
feat = reshape(out(:,:,:,1), [], 1, 1)';
fid = fopen('3dNormalResult.txt', 'w');
fprintf(fid, '%s ', 'Im1.jpg');
for i = 1 : 8000
  fprintf(fid, '%f ', feat(i));
end
fclose(fid);


