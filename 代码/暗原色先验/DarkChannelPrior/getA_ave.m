function [A] = getA_ave(I, I_darkChannel, ratio)
    % ���ȫ�ֱ����⣬ʹ��ƽ��ֵ�ķ�ʽ
    % I������ͼ��
    % I_darkChannel������ͼ��İ�ͨ��
    % ratio���Ӱ�ͨ����ѡ����ı���

    [~, darkC_sort_index] = sort(I_darkChannel(:), 'descend');
    num_topDarkC = floor(length(darkC_sort_index)*ratio);
    Light_all = zeros(num_topDarkC,3);
    for k=1:num_topDarkC
        darkC_index = darkC_sort_index(k);
        [i, j] = getIJ_index(darkC_index, size(I,1));
        I_light = I(i, j, :);
        Light_all(k,:)=I_light;
    end
    A=mean(Light_all);
    A=reshape(A,[1,1,3]);
    A = repmat(A, size(I_darkChannel));
end

function [i, j] = getIJ_index(index, rowNum)
    j = floor((index-1)/rowNum)+1;
    i = rem(index-1,rowNum)+1;
end