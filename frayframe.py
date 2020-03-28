import cv2
import os

class frayframe:
    def __init__(self, video_path):
        self.file_name = os.path.split(video_path)[1].split('.')[0]
        self.video = cv2.VideoCapture(video_path)
        self.frame_count = int(self.video.get(cv2.CAP_PROP_FRAME_COUNT))
        self.save_out = os.path.join('/pfs/out', self.file_name + '-{:04}.png')

    def save_frame(self, frame_number:int):
        assert frame_number >= 0
        assert frame_number < self.frame_count

        self.video.set(cv2.CAP_PROP_POS_FRAMES, frame_number)
        success, frame = self.video.read()
        if success:
            cv2.imwrite(self.save_out.format(frame_number), frame)
    
    def save_all_frames(self):
        for frame_number in range(self.frame_count):
            self.save_frame(frame_number)

for dirpath, dirs, files in os.walk("/pfs/videos"):
    for file in files:
        ff = frayframe(os.path.join(dirpath, file))
        ff.save_all_frames()