function [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name,...
    gt_label, methods_name, method_label)

imgname_path = [data_root_path,dataset_name,'\imagenames.txt'];

fid = fopen(imgname_path,'r');
imgnum = 0;
imgname = [];
while feof(fid) == 0
    imgnum = imgnum + 1;
    imgname{imgnum} = fgetl(fid);
end
fclose(fid);


dirpath = [data_root_path,dataset_name,'\'];
if strcmp(gt_label,'occluded') || strcmp(gt_label,'overlap') || ...
        strcmp(gt_label,'concentric') || strcmp(gt_label,'concurrent') % �������ݼ�
    [gt_elps, ~] = Read_Ellipse_GT([dirpath,'gt\'], ...
        [dirpath,'images\'], imgname, gt_label);
    T_overlap = 0.95;
else
    [gt_elps, ~] = Read_Ellipse_GT([dirpath,'gt\gt_'], ...
        [dirpath,'images\'], imgname, gt_label);
    T_overlap = 0.8;
end


[dt_elps, ~] = Read_Ellipse_Results([dirpath,methods_name,'\'], ...
    imgname, method_label);

pos_num = zeros(1,imgnum); % ��Ч��Բ����
pos_elp = cell(1, imgnum); % ��Ч��Բ���������һ���ǽǱ�

det_num = zeros(1,imgnum); % ��������Բ����
det_elp = cell(1,imgnum); % �洢��Ч��Բ���������һ���ǽǱ�

gt_num = zeros(1,imgnum);  % ��ʵ��Բ����
gt_elp = cell(1, imgnum);  % �洢δ���
parfor i = 1:imgnum
    detected_ellipses = dt_elps{i};
    gt_ellipses = gt_elps{i};
    
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
    
    num_true_elp = sum(gt_match > 0);
    num_det_true_elp = sum(det_match > 0);
    
    
    
    % ͳ����Ч��Բ������������������ʵ����
    pos_num(i) = num_true_elp;
    det_num(i) = num_true_elp + num_false_elp + max([num_det_true_elp - num_true_elp, 0]);
    gt_num(i) = num_true_elp + num_loss_elp;
    
    
end

pos_all = sum(pos_num);
det_all = sum(det_num);
gt_all = sum(gt_num);

if det_all == 0
    P = 0;
    R = 0;
    F = 0;
else
    P = pos_all / det_all;
    R = pos_all / gt_all;
    F = 2 * P * R / (P + R);
end




end