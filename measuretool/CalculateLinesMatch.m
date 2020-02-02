function isMatch = CalculateLinesMatch(gt_line, det_line)

st_1 = gt_line(1:2);  ed_1 = gt_line(3:4);
st_2 = det_line(1:2); ed_2 = det_line(3:4);

n1 = st_2-st_1; n2 = ed_2 - st_1; nt = ed_1-st_1; ndet = ed_2 - st_2;
h1 = abs(n1(1)*nt(2)-n1(2)*nt(1))/norm(nt); h2 = abs(n2(1)*nt(2)-n2(2)*nt(1))/norm(nt);

if max([h1,h2]) > 3 % ���ƽ�����볬��3��������ƥ��
    isMatch = 0;
    return;
end

h1 = (n1(1)*nt(1)+n1(2)*nt(2))/(nt*nt'); h2 = (n2(1)*nt(1)+n2(2)*nt(2))/(nt*nt');
% [h1,h2]
% if (h1 < 0 || h1 >1) && (h2 < 0 || h2>1)% ���ֱ���ڱ�׼ֱ���ⲿ����ƥ��
%     isMatch = 0;
%     return;
% end
if (h1 < 0 && h2 < 0) || (h1 > 1 && h2 > 1)% ���ֱ���ڱ�׼ֱ���ⲿ����ƥ��
    isMatch = 0;
    return;
end



if abs(h2-h1)<0.05% ���ֱ�߳��Ⱥ�С����ƥ��
    isMatch = 0;
    return;
end

h1 = abs(nt*ndet')/norm(ndet)/norm(nt);
if h1 < cos(pi/6)
    isMatch = 0;
    return;
end

isMatch = 1;


end