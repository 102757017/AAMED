clc;clear;close all;
% �����������ݼ�

src_path = 'F:\Arcs-Adjacency-Matrix-Based-Fast-Ellipse-Detection\ellipse_dataset\ellipse\Scn8-2_Video1-���ϽǺ���237X317\';
dst_path = 'F:\Arcs-Adjacency-Matrix-Based-Fast-Ellipse-Detection\ellipse_dataset\Satellite Images - Dataset Meng #2\images\';


imgnum = 461;
prefix = 'scn8-2-a-';
for i = 1:imgnum
    disp(num2str(i));
    filename = [src_path,num2str(i),'.jpg'];
    outfile_name = [dst_path, prefix,num2str(i),'.jpg'];
    copyfile(filename, outfile_name);
end
