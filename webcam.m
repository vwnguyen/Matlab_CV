cam = webcam(1);
img = snapshot(cam);

% Display the frame in a figure window.
image(img);

while 1
    img = snapshot(cam);
    image(img);
end

clear cam