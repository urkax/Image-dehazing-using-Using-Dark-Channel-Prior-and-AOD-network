close all;
imgDir = dir('testbench/*.*');
%����testbench�ļ����µ�ͼƬ
for i=3:length(imgDir)
    path = [imgDir(i).folder '\'];
    name = imgDir(i).name
    img_path = [path name];
    I = im2double(imread(img_path));
    [J,J_hist] = dehaze(I);

    J_gamma = 1; %���ȵ���
    J = J.*(J_gamma);
    
    split = strsplit(name, '.');
    result_name = [split{1} '_result.' split{2}];
    imwrite(J, ['results/' result_name]);

end


