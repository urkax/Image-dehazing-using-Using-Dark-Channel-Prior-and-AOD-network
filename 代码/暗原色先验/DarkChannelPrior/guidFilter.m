function [q] = guidFilter(I, p, r_small, s, epsilon)
    %���������˲��㷨
    %I������ͼ��Ϊrgbͼ��
    %p������ͼ��t_
    %r�Ǿֲ����ڰ뾶
    %s�ǽ�������
    
    I_small = imresize(I, s, 'nearest');
    p_small = imresize(p, s, 'nearest');
    
    pixel_num=boxfilter(ones([size(I_small,1) size(I_small,2)]), r_small);%�˲������ڵ�ĸ���
    
    I_mean_r = boxfilter(I_small(:,:,1), r_small)./pixel_num;
    I_mean_g = boxfilter(I_small(:,:,2), r_small)./pixel_num;
    I_mean_b = boxfilter(I_small(:,:,3), r_small)./pixel_num;
    
    Ip_mean_r = boxfilter(I_small(:,:,1).*p_small, r_small)./pixel_num;
    Ip_mean_g = boxfilter(I_small(:,:,2).*p_small, r_small)./pixel_num;
    Ip_mean_b = boxfilter(I_small(:,:,3).*p_small, r_small)./pixel_num;
    
    p_mean = boxfilter(p_small, r_small)./pixel_num;
    
    conv_Ip_r = Ip_mean_r-p_mean.*I_mean_r;
    conv_Ip_g = Ip_mean_g-p_mean.*I_mean_g;
    conv_Ip_b = Ip_mean_b-p_mean.*I_mean_b;
    
    %����I�ķ���
    conv_I_rr = boxfilter(I_small(:,:,1).*I_small(:,:,1), r_small)./pixel_num-I_mean_r.*I_mean_r;
    conv_I_rg = boxfilter(I_small(:,:,1).*I_small(:,:,2), r_small)./pixel_num-I_mean_r.*I_mean_g;
    conv_I_rb = boxfilter(I_small(:,:,1).*I_small(:,:,3), r_small)./pixel_num-I_mean_r.*I_mean_b;
    conv_I_gg = boxfilter(I_small(:,:,2).*I_small(:,:,2), r_small)./pixel_num-I_mean_g.*I_mean_g;
    conv_I_gb = boxfilter(I_small(:,:,2).*I_small(:,:,3), r_small)./pixel_num-I_mean_g.*I_mean_b;
    conv_I_bb = boxfilter(I_small(:,:,3).*I_small(:,:,3), r_small)./pixel_num-I_mean_b.*I_mean_b;
    
    a = zeros(size(I_small));
    for i=1:size(I_small,1)
        for j=1:size(I_small,2)
            Sigma = [conv_I_rr(i, j), conv_I_rg(i, j), conv_I_rb(i, j);
                conv_I_rg(i, j), conv_I_gg(i, j), conv_I_gb(i, j);
                conv_I_rb(i, j), conv_I_gb(i, j), conv_I_bb(i, j)];

            conv_Ip = [conv_Ip_r(i, j), conv_Ip_g(i, j), conv_Ip_b(i, j)];        

            a(i, j, :) = conv_Ip / (Sigma + epsilon * eye(3));
        end
    end
    
    b = p_mean - a(:,:,1).*I_mean_r - a(:,:,2).*I_mean_g - a(:,:,3).*I_mean_b;
    
    a_mean(:,:,1) = boxfilter(a(:,:,1), r_small)./pixel_num;
    a_mean(:,:,2) = boxfilter(a(:,:,2), r_small)./pixel_num;
    a_mean(:,:,3) = boxfilter(a(:,:,3), r_small)./pixel_num;
    b_mean = boxfilter(b, r_small)./pixel_num;
    
    a_mean_big = imresize(a_mean, [size(I,1) size(I,2)], 'bilinear');
    b_mean_big = imresize(b_mean, [size(I,1) size(I,2)], 'bilinear');
    q = sum(a_mean_big.*I,3)+b_mean_big;
end