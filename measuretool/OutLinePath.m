clc; clear all; close all;
% ���ֱ�����ݼ�·����ַ

dataset_name = 'yorkurban';

if strcmp(dataset_name, 'yorkurban')
    gt_path = 'E:\Ѹ������\YorkUrbanDB\'; % Data set path
    
    %% ��ȡͼƬ����Ϣ
    load([gt_path, 'Manhattan_Image_DB_Names.mat']);
    
    %% ��ȡͼ������������׺
    data = Manhattan_Image_DB_Names; % ��ȡ�ļ�����
    imgnum = size(data,1);
    
    %% �����ļ�·���ļ�
    fid = fopen('lsdpath.txt', 'w');
    %% ��ʼ���·��
    for i = 1:imgnum
        str = data{i};
        single_img = str(1:end-1);
        imgname = [single_img,'.jpg'];
        allpath = [gt_path, str, imgname];
        fprintf(fid, '%s\n', allpath);
    end
    fclose(fid);
    return;
end


if strcmp(dataset_name, 'prasad')
    gt_path = 'G:\ellipse_dataset\Prasad Images - Dataset Prasad\'; % Data set path
    fid_in = fopen([gt_path, 'imagenames.txt'],'r');
    fid_out = fopen('parasadpath.txt','w');
    while feof(fid_in) == 0
        imgname = fgetl(fid_in);
        fprintf(fid_out, '%s\n', [gt_path, 'images\', imgname]);
    end
    fclose(fid_in);
    fclose(fid_out);
    return;
end



error([dataset_name, ': Error dataset name']);

