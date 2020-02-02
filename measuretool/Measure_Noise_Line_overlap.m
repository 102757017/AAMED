clc;clear;close all;
% ��Բ��֤���򣬸��£�2018-12-16
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

%  FLED   Prasad  ELSD  YAED  CNED  TPED  Wang  Wu
%  aamed  prasad  elsd  yaed  cned  tped  rtded wu
methods_name = 'Liu';
method_label = 'liu';


dsi = 2;




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
    %     patch_gt_elps = cell(1, patch_imgnum);
    
    prefix = 'synth_overlap_24ellipses_img';
    [dt_elps, dt_time, patch_gt_elps] = Read_Ellipse_Noise_Results(filepath, prefix, imgname,...
        method_label, L_nums(i), patch_imgnum, gt_elps);
    
    
    
    
    
    % synth_overlap_24ellipses_img1_line0
    %     for k = 1:patch_imgnum
    %         fid_dt = fopen([filepath, 'synth_overlap_24ellipses_img', num2str(k),'_line',num2str(L_nums(i)),'.png.fled.txt']);
    %         if fid_dt == -1
    %             error([dataset_name, ': wrong file path']);
    %         end
    %         elps_data = [];
    %         dt_time(k) = str2num(fgetl(fid_dt));
    %         while feof(fid_dt) == 0
    %             elp_datat = str2num(fgetl(fid_dt));
    %             if elp_datat(1) == 2
    %                 continue;
    %             end
    %             elp_datat(1) = [];
    %             temp = elp_datat(1);
    %             elp_datat(1) = elp_datat(2);
    %             elp_datat(2) = temp;
    %             elp_datat(1:2) = elp_datat(1:2)+1;
    %             elp_datat(3:4) = elp_datat(3:4)/2;
    %             elp_datat(5) = -elp_datat(5)/180*pi;
    %
    %             elps_data = [elps_data; elp_datat];
    %         end
    %         dt_elps{k} = elps_data;
    %         fclose(fid_dt);
    %
    %         % ���Ҷ�Ӧ��patch
    %         idx = find(strcmp(imgname, ['synth_overlap_24ellipses_img', num2str(k),'_line',num2str(L_nums(i)),'.png']));
    %         patch_gt_elps{k} = gt_elps{idx};
    %     end
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

save([method_label,'_PRF_lines_overlap.mat'], 'P_val', 'R_val', 'F_val');
% save PRF_lines_overlap.mat P_val R_val F_val;