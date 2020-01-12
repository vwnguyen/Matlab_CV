clear all;
clc;
cam = webcam;
cam.Resolution = '640x480';
for  i = 1:10000
    img = snapshot(cam);
    imshow(img);
end 
clear cam;
    