clc;clear;close all;
% ��֤���ǵ�ÿ����֤���ӵ���Ч��

%% ���ò�����ֵ
theta_arc_init = pi/3;
lambda_arc_init = 3.4;
T_val_init = 0.77;

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

%% ������֤���

PA = cell(1,6);
PA{1} = zeros(length(dataset_name), 3); % WithoutSI, ÿ�����ݼ���PRF
PA{2} = zeros(length(dataset_name), 3); % WithoutGI, ÿ�����ݼ���PRF
PA{3} = zeros(length(dataset_name), 3); % WithoutWI, ÿ�����ݼ���PRF
PA{4} = zeros(length(dataset_name), 3); % WithoutSIGI, ÿ�����ݼ���PRF
PA{5} = zeros(length(dataset_name), 3); % WithoutSIWI, ÿ�����ݼ���PRF
PA{6} = zeros(length(dataset_name), 3); % �������, ÿ�����ݼ���PRF

%% Step 1: ��֤��״��������Ч��
disp('Step 1: ���ڽ��з���Without SI.');
idx_parm = 1;

for dsi = 1:length(dataset_name)
    
    fprintf(['-->���ڲ������ݼ���',dataset_name{dsi}]);
    
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    fprintf('.');
    cmd=['AAMEDWithoutSI.exe',' ',...
        data_root_path,' ',... % ���ݼ���ַ
        gt_label{dsi}, ' ',...  % ���ݼ�����
        num2str(theta_arc_init),' ',...
        num2str(lambda_arc_init),' ',...
        num2str(T_val_init),' ',...
        num2str(isCanny)];
    [status, result]=system(cmd);
    if status == -1024
        error('exe����ʧ��');
    end
    
    [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
        gt_label{dsi}, methods_name, method_label);
    
    PA{idx_parm}(dsi,1) = P;
    PA{idx_parm}(dsi,2) = R;
    PA{idx_parm}(dsi,3) = F;
    fprintf('\n');
end


%% Step 2: ��֤�ݶȲ�������Ч��
disp('Step 2: ���ڽ��з���Without GI.');
idx_parm = 2;

for dsi = 1:length(dataset_name)
    
    fprintf(['-->���ڲ������ݼ���',dataset_name{dsi}]);
    
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    fprintf('.');
    cmd=['AAMEDWithoutGI.exe',' ',...
        data_root_path,' ',... % ���ݼ���ַ
        gt_label{dsi}, ' ',...  % ���ݼ�����
        num2str(theta_arc_init),' ',...
        num2str(lambda_arc_init),' ',...
        num2str(T_val_init),' ',...
        num2str(isCanny)];
    [status, result]=system(cmd);
    if status == -1024
        error('exe����ʧ��');
    end
    
    [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
        gt_label{dsi}, methods_name, method_label);
    
    PA{idx_parm}(dsi,1) = P;
    PA{idx_parm}(dsi,2) = R;
    PA{idx_parm}(dsi,3) = F;
    fprintf('\n');
end


%% Step 3: ��֤��״��������Ч��
disp('Step 3: ���ڽ��з���Without WI.');
idx_parm = 3;

for dsi = 1:length(dataset_name)
    
    fprintf(['-->���ڲ������ݼ���',dataset_name{dsi}]);
    
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    fprintf('.');
    cmd=['AAMEDWithoutWI.exe',' ',...
        data_root_path,' ',... % ���ݼ���ַ
        gt_label{dsi}, ' ',...  % ���ݼ�����
        num2str(theta_arc_init),' ',...
        num2str(lambda_arc_init),' ',...
        num2str(T_val_init),' ',...
        num2str(isCanny)];
    [status, result]=system(cmd);
    if status == -1024
        error('exe����ʧ��');
    end
    
    [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
        gt_label{dsi}, methods_name, method_label);
    
    PA{idx_parm}(dsi,1) = P;
    PA{idx_parm}(dsi,2) = R;
    PA{idx_parm}(dsi,3) = F;
    fprintf('\n');
end

%% Step 4: Without SI GI��֤��״��������Ч��
disp('Step 4: ���ڽ��з���Without SI GI.');
idx_parm = 4;

for dsi = 1:length(dataset_name)
    
    fprintf(['-->���ڲ������ݼ���',dataset_name{dsi}]);
    
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    fprintf('.');
    cmd=['AAMEDWithoutSIGI.exe',' ',...
        data_root_path,' ',... % ���ݼ���ַ
        gt_label{dsi}, ' ',...  % ���ݼ�����
        num2str(theta_arc_init),' ',...
        num2str(lambda_arc_init),' ',...
        num2str(T_val_init),' ',...
        num2str(isCanny)];
    [status, result]=system(cmd);
    if status == -1024
        error('exe����ʧ��');
    end
    
    [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
        gt_label{dsi}, methods_name, method_label);
    
    PA{idx_parm}(dsi,1) = P;
    PA{idx_parm}(dsi,2) = R;
    PA{idx_parm}(dsi,3) = F;
    fprintf('\n');
end

%% Step 5: Without SI WI
disp('Step 5: ���ڽ��з���Without SI WI.');
idx_parm = 5;

for dsi = 1:length(dataset_name)
    
    fprintf(['-->���ڲ������ݼ���',dataset_name{dsi}]);
    
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    fprintf('.');
    cmd=['AAMEDWithoutSIWI.exe',' ',...
        data_root_path,' ',... % ���ݼ���ַ
        gt_label{dsi}, ' ',...  % ���ݼ�����
        num2str(theta_arc_init),' ',...
        num2str(lambda_arc_init),' ',...
        num2str(T_val_init),' ',...
        num2str(isCanny)];
    [status, result]=system(cmd);
    if status == -1024
        error('exe����ʧ��');
    end
    
    [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
        gt_label{dsi}, methods_name, method_label);
    
    PA{idx_parm}(dsi,1) = P;
    PA{idx_parm}(dsi,2) = R;
    PA{idx_parm}(dsi,3) = F;
    fprintf('\n');
end

%% Step 6: ԭʼ���
disp('Step 6: ���ڽ��з���ԭʼ���.');
idx_parm = 6;

for dsi = 1:length(dataset_name)
    
    fprintf(['-->���ڲ������ݼ���',dataset_name{dsi}]);
    
    if strcmp(gt_label{dsi},'occluded') || strcmp(gt_label{dsi},'overlap')...
            || strcmp(gt_label{dsi},'concentric') || strcmp(gt_label{dsi},'concurrent')
        isCanny = 0;
    else
        isCanny = 1;
    end
    
    fprintf('.');
    cmd=['AAMEDWithAll.exe',' ',...
        data_root_path,' ',... % ���ݼ���ַ
        gt_label{dsi}, ' ',...  % ���ݼ�����
        num2str(theta_arc_init),' ',...
        num2str(lambda_arc_init),' ',...
        num2str(T_val_init),' ',...
        num2str(isCanny)];
    [status, result]=system(cmd);
    if status == -1024
        error('exe����ʧ��');
    end
    
    [P,R,F] = AAMEDMeasureEllipseFun_4_22(data_root_path, dataset_name{dsi},...
        gt_label{dsi}, methods_name, method_label);
    
    PA{idx_parm}(dsi,1) = P;
    PA{idx_parm}(dsi,2) = R;
    PA{idx_parm}(dsi,3) = F;
    fprintf('\n');
end

save ValidationIndex.mat PA
