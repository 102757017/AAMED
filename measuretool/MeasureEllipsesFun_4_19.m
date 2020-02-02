function [P,R,F] = MeasureEllipsesFun_4_19(dirpath, dataset, T_overlap)

%% Read the image name list 'imagenames.txt', the list is got by 'getImagesName.bat'
fid = fopen([dirpath,'imagenames.txt'],'r');
imgnum = 0;
while feof(fid) == 0
    imgnum = imgnum + 1;
    imgname{imgnum} = fgetl(fid);
end
fclose(fid);

%% Read the ground-truth ellipse data
[gt_elps] = Read_Ellipse_GT([dirpath,'gt\gt_'], [dirpath,'images\'], imgname, dataset);

%% Read the detected ellipse by FLED methods
[dt_elps, dt_time] = Read_Ellipse_Results([dirpath,'AMED\'], imgname, 'aamed');


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
    
    % ע�����ǵ�Ŀ��������ԣ�һ������������Բ���ܻ��Ӧ����gt��Բ����ô���������
    % ����Բ������Ϊ��2�����Զ�����Ŀ������չ���෴�����det���ܻ��Ӧһ��gt���������
    % ���Ա���Ϊ��û����Ƴ�һ���õ���Բ�����㷨
    num_true_elp = sum(gt_match > 0);
    num_det_true_elp = sum(det_match > 0);
    
    % ����detƥ���������gt�������⣬ѡ������ƥ�䣬ʣ�µ���Ϊfalse ellipse
    
    %         if num_det_true_elp > num_true_elp
    %             idx_gt = find(gt_match > 0);
    %             idx_det = find(det_match > 0);
    %
    %             gt_select = cell(1, length(idx_gt));
    %             for gidx = 1:length(gt_select)
    %                 idx_tmp = find(res(:, idx_gt(gidx)) > 0);
    %                 gt_select{gidx} = [elps_overlap(idx_tmp,idx_gt(gidx)), idx_tmp(:)];
    %                 gt_select{gidx} = sortrows(gt_select{gidx},1);
    %             end
    %
    %             % ѡ�����overlap����Ϊ������ֵ������ȫ����Ϊfalse ellipse
    %
    %         end
    
    
    % ͳ����Ч��Բ������������������ʵ����
    pos_num(i) = num_true_elp;
    det_num(i) = num_true_elp + num_false_elp + max([num_det_true_elp - num_true_elp, 0]);
    gt_num(i) = num_true_elp + num_loss_elp;
    
    %         % ͳ�Ƽ�����
    %         idx_pos_match = find(det_match > 0);
    %         if ~isempty(idx_pos_match)
    %             pos_elp{i} = [detected_ellipses(idx_pos_match, :), idx_pos_match(:)];
    %         end
    %         idx_false_elp = find(det_match == 0);
    %         if ~isempty(idx_false_elp)
    %             det_elp{i} = [detected_ellipses(idx_false_elp,:), idx_false_elp(:)];
    %         end
    %         idx_loss_elp = find(gt_match == 0);
    %         if ~isempty(idx_loss_elp)
    %             gt_elp{i} = [gt_ellipses(idx_loss_elp,:), idx_loss_elp(:)];
    %         end
    
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