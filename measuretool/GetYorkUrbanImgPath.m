clc;clear all;close all;
% ���ɳ������ݼ�·��

dirpath = 'E:\Ѹ������\YorkUrbanDB\'; % Data set path

%% ��ȡͼƬ����Ϣ
load([dirpath, 'Manhattan_Image_DB_Names.mat']);

%% ��ȡÿ��ֱ�ߵ�������Ϣ
data = Manhattan_Image_DB_Names; % ��ȡ�ļ�����

imgnum = size(data,1);


fid = fopen('lsdpath.txt','w');
fprintf(fid, '%s\n', dirpath);
for i = 1:imgnum
    str = data{i};
    single_img = str(1:end-1);
    fprintf(fid, '%s\n', single_img);
end
fclose(fid);