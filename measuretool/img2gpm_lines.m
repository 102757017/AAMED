clc;clear all;close all;
% ŦԼֱ�����ݼ�תpgm

dirpath = 'E:\Ѹ������\YorkUrbanDB\';
%% Read the ground-truth line segment data
[gt_lines, gt_size, imgname] = Read_GT_Lines_YorkUrbanDB(dirpath);

imgnum = length(imgname);

fid = fopen('YorkUrbanDBpath_pgm.txt','w');
for i = 1:imgnum
    disp(['���ڱ����',num2str(i),'��ͼƬ']);
    pathimg = [dirpath, imgname{i}(1:end-4),'\',imgname{i}];
    img = imread(pathimg);
%    imwrite(img, ['E:\Ѹ������\YorkUrbanDB_Linux\images_pgm\', imgname{i}, '.pgm'],'pgm');
    respath = ['../YorkUrbanDB_Linux/images_pgm/', imgname{i}, '.pgm'];
    fprintf(fid, '%s\n', respath);
end
fclose(fid);


fid = fopen('YorkUrbanDBpath_pbm.txt','w');
for i = 1:imgnum
    disp(['���ڱ����',num2str(i),'��ͼƬ']);
    pathimg = [dirpath, imgname{i}(1:end-4),'\',imgname{i}];
    img = imread(pathimg);
    if length(size(img)) > 2
        img = rgb2gray(img);
    end
    h = edge(img,'canny');
    B=[1,1
        1 0];
    A2=imdilate(h,B);
    img = 1-A2;
%    imwrite(img, ['E:\Ѹ������\YorkUrbanDB_Linux\images_pbm\', imgname{i}, '.pbm'],'pbm');
    respath = ['../../YorkUrbanDB_Linux/images_pbm/', imgname{i}, '.pbm'];
    fprintf(fid, '%s\n', respath);
end
fclose(fid);