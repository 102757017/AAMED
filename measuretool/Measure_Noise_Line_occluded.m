clc;clear;close all;
% ��Բ��֤����
%

addpath MeasureTools;

% try
%     parpool('local', 4);
% catch
%     warning('���п����ѿ���');
% end

data_root_path = 'F:\Arcs-Adjacency-Matrix-Based-Fast-Ellipse-Detection\ellipse_dataset\';

dataset_name = [{'OccludedWithMultiLines'},{'OverlapWithMultiLines'}];

gt_label = [{'occludedwithmultilines'},{'overlapwithmultilines'}];

%  FLED   Prasad  ELSD  YAED  CNED  TPED  Wang  Wu Lu
%  aamed  prasad  elsd  yaed  cned  tped  rtded wu lu
methods_name = 'Liu';  %  FLED   Prasad
method_label = 'liu'; %  aamed  prasad


dsi = 1;

imgname_path = [data_root_path,dataset_name{dsi},'\imagenames.txt'];
fid = fopen(imgname_path,'r');
imgnum = 0;
imgname = [];
while feof(fid) == 0
    imgnum = imgnum + 1;
    imgname{imgnum} = fgetl(fid);
end
fclose(fid);


dirpath = [data_root_path,dataset_name{dsi},'\'];

%% ��ȡ��Բground truth
if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap') || ...
        strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent') || ...
        strcmp(gt_label{dsi},'occludedwithmultilines') || strcmp(gt_label{dsi},'overlapwithmultilines')% �������ݼ�
    [gt_elps, gt_size] = Read_Ellipse_GT([dirpath,'gt\'], ...
        [dirpath,'images\'], imgname, gt_label{dsi});
    T_overlap = 0.95;
else
    [gt_elps, gt_size] = Read_Ellipse_GT([dirpath,'gt\gt_'], ...
        [dirpath,'images\'], imgname, gt_label{dsi});
    T_overlap = 0.8;
end
elp_num = 0;
for k = 1:length(gt_elps)
    elp_num = elp_num + size(gt_elps{k},1);
end
%     disp(['��ʵ��Բ����Ϊ��', num2str(elp_num)]);


L_nums = -1:20;
P_val = zeros(1, length(L_nums));
R_val = zeros(1, length(L_nums));
F_val = zeros(1, length(L_nums));


for i = 1:length(L_nums)
    disp(['Processing', num2str(L_nums(i)), ' L_nums']);
    %% ��ȡ�����
    patch_imgnum = 100;
    dt_elps = cell(1, patch_imgnum);
    dt_time = zeros(1,patch_imgnum);
    filepath = [dirpath,methods_name,'\'];
    
    prefix = 'synth_overlap_24ellipses_img';
    [dt_elps, dt_time, patch_gt_elps] = Read_Ellipse_Noise_Results(filepath, prefix, imgname,...
        method_label, L_nums(i), patch_imgnum, gt_elps);
    

    %% ���ݼ���������Ӧ��PRF
    pos_num = zeros(1,patch_imgnum); % ��Ч��Բ����
    pos_elp = cell(1, patch_imgnum); % ��Ч��Բ���������һ���ǽǱ�
    
    det_num = zeros(1,patch_imgnum); % ��������Բ����
    det_elp = cell(1,patch_imgnum); % �洢��Ч��Բ���������һ���ǽǱ�
    
    gt_num = zeros(1,patch_imgnum);  % ��ʵ��Բ����
    gt_elp = cell(1, patch_imgnum);  % �洢δ���
    for k = 1:patch_imgnum
        detected_ellipses = dt_elps{k};
        gt_ellipses = patch_gt_elps{k};
        
        elpnum_det = size(detected_ellipses, 1);
        elpnum_gt = size(gt_ellipses, 1);
        
        elps_overlap = zeros(elpnum_det, elpnum_gt);
        for p = 1:elpnum_det
            for q = 1:elpnum_gt
                [ration, ~] = mexCalculateOverlap(detected_ellipses(p,:),gt_ellipses(q,:));
                elps_overlap(p,q) = ration;
            end
        end
        
        res = elps_overlap > T_overlap;
        
        gt_match = sum(res, 1);
        det_match = sum(res, 2);
        
        num_loss_elp = sum(gt_match == 0);
        num_false_elp = sum(det_match == 0);
        
        % ע�����ǵ�Ŀ��������ԣ�һ������������Բ���ܻ��Ӧ����gt��Բ����ô���������
        % ����Բ������Ϊ��2�����Զ�����Ŀ������չ���෴�����det���ܻ��Ӧһ��gt���������
        % ���Ա���Ϊ��û����Ƴ�һ���õ���Բ�����㷨
        num_true_elp = sum(gt_match > 0);
        num_det_true_elp = sum(det_match > 0);
        
        % ͳ����Ч��Բ������������������ʵ����
        pos_num(k) = num_true_elp;
        det_num(k) = num_true_elp + num_false_elp + max([num_det_true_elp - num_true_elp, 0]);
        gt_num(k) = num_true_elp + num_loss_elp;
    end
    
    pos_all = sum(pos_num);
    det_all = sum(det_num);
    gt_all = sum(gt_num);
    
    
    if det_all == 0 || pos_all == 0
        P = 0;
        R = 0;
        F = 0;
    else
        P = pos_all / det_all;
        R = pos_all / gt_all;
        F = 2 * P * R / (P + R);
    end
    
    
    P_val(i) = P;
    R_val(i) = R;
    F_val(i) = F;
    
    
end

save([method_label,'_PRF_lines_occluded.mat'], 'P_val', 'R_val', 'F_val');
% save PRF_lines_occluded.mat P_val R_val F_val;