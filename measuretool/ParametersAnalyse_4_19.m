clc;clear;close all;
% �£��Բ����������жȷ���

%% ���ò�����ֵ
theta_arc_init = 1.0472;
lambda_arc_init = 3.4;
T_val_init = 0.77;


%% ���ò���������Χ
theta_arc = 5:1:90; theta_arc = theta_arc/180*pi;
lambda_arc = 1.1:0.1:6;
T_val = 0.5:0.02:0.99;



%% �������ݼ���Ϣ

data_root_path = 'F:\Arcs-Adjacency-Matrix-Based-Fast-Ellipse-Detection\ellipse_dataset\';

dataset_name = [{'Synthetic Images - Occluded Ellipses'},...
    {'Synthetic Images - Overlap Ellipses'},...
    {'Prasad Images - Dataset Prasad'},...
    {'Random Images - Dataset #1'},...
    {'Smartphone Images - Dataset #2'},...
    {'Concentric Ellipses - Dataset Synthetic'},...
    {'Concurrent Ellipses - Dataset Synthetic'},...
    {'Satellite Images - Dataset Meng #1'},...
    {'Satellite Images - Dataset Meng #2'}];

gt_label = [{'occluded'},{'overlap'},{'prasad'},{'random'},{'smartphone'},...
    {'concentric'},{'concurrent'},{'satellite1'}, {'satellite2'}];

methods_name = 'FLED';
method_label = 'fled';

%% �������жȽ����Ϣ

PA = cell(1,3);
PA{1} = zeros(length(theta_arc), 3, length(dataset_name));
PA{2} = zeros(length(lambda_arc), 3, length(dataset_name));
PA{3} = zeros(length(T_val), 3, length(dataset_name));


%% Step 1: ����theta_arc���ж�
disp('Step 1: ���ڽ��з���theta_arc�����ж�.');
idx_parm = 1;

for dsi = 1:length(dataset_name)
    
    fprintf(['-->���ڲ������ݼ���',dataset_name{dsi}]);
    
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    for tp_i = 1:length(theta_arc)
        fprintf('.');
        cmd=['AAMEDForAdjustParms.exe',' ',...
            data_root_path,' ',... % ���ݼ���ַ
            gt_label{dsi}, ' ',...  % ���ݼ�����
            num2str(theta_arc(tp_i)),' ',...
            num2str(lambda_arc_init),' ',...
            num2str(T_val_init),' ',...
            num2str(isCanny)];
        [status, result]=system(cmd);
        if status == -1024
            error('exe����ʧ��');
        end
        
        [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
            gt_label{dsi}, methods_name, method_label);
        
        PA{idx_parm}(tp_i,1,dsi) = P;
        PA{idx_parm}(tp_i,2,dsi) = R;
        PA{idx_parm}(tp_i,3,dsi) = F;
    end
    fprintf('\n');
end

%% Step 2: ����lambda_arc���ж�
disp('Step 2: ���ڽ��з���lambda_arc�����ж�.');
idx_parm = 2;

for dsi = 1:length(dataset_name)
    fprintf('-->���ڲ������ݼ���%s',dataset_name{dsi});
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    for tp_i = 1:length(lambda_arc)
        fprintf('.');
        cmd=['AAMEDForAdjustParms.exe',' ',...
            data_root_path,' ',... % ���ݼ���ַ
            gt_label{dsi}, ' ',...  % ���ݼ�����
            num2str(theta_arc_init),' ',...
            num2str(lambda_arc(tp_i)),' ',...
            num2str(T_val_init),' ',...
            num2str(isCanny)];
        [status, result]=system(cmd);
        if status == -1024
            error('exe����ʧ��');
        end
        
        [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
            gt_label{dsi}, methods_name, method_label);
        
        PA{idx_parm}(tp_i,1,dsi) = P;
        PA{idx_parm}(tp_i,2,dsi) = R;
        PA{idx_parm}(tp_i,3,dsi) = F;
    end
    fprintf('\n');
end


%% Step 3: ����T_val���ж�
disp('Step 3: ���ڽ��з���T_val�����ж�.');
idx_parm = 3;

for dsi = 1:length(dataset_name)
    
    fprintf('-->���ڲ������ݼ���%s',dataset_name{dsi});
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    for tp_i = 1:length(T_val)
        fprintf('.');
        cmd=['AAMEDForAdjustParms.exe',' ',...
            data_root_path,' ',... % ���ݼ���ַ
            gt_label{dsi}, ' ',...  % ���ݼ�����
            num2str(theta_arc_init),' ',...
            num2str(lambda_arc_init),' ',...
            num2str(T_val(tp_i)),' ',...
            num2str(isCanny)];
        [status, result]=system(cmd);
        if status == -1024
            error('exe����ʧ��');
        end
        
        [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
            gt_label{dsi}, methods_name, method_label);
        
        PA{idx_parm}(tp_i,1,dsi) = P;
        PA{idx_parm}(tp_i,2,dsi) = R;
        PA{idx_parm}(tp_i,3,dsi) = F;
    end
    fprintf('\n');
end


%% ��������
save ParmsAnalyse.mat PA