# Script to extract frames with given parameters
import argparse
import cv2
import numpy as np
import os
from pathlib import Path


class FrameExtractor:
    def __init__(self, vid_path: Path, dest_path: Path):
        # Path vars
        self.orig_vid_path = vid_path
        self.dest_root_path = dest_path
        self.dest_img_path = self.dest_root_path / "imgs"
        # Vars
        self.frame_idx = 1
        # Init vars
        self._init_vars()

    def __call__(self, *args, **kwargs):
        vid_obj = cv2.VideoCapture(str(self.orig_vid_path))
        fps = vid_obj.get(cv2.CAP_PROP_FPS)
        fps_file_path = self.dest_root_path / 'fps.txt'
        self._write_fps_file_(fps_file_path, fps)

        while vid_obj.isOpened():
            # Capture frame-by-frame
            ret, frame = vid_obj.read()
            if ret is True:
                # Save frames
                self._write_img_(frame, self.frame_idx, str(self.dest_img_path))
                self.frame_idx += 1
            else:
                break

    def _init_vars(self):
        self._make_paths_()

    def _make_paths_(self):
        self.dest_img_path.mkdir(parents=True, exist_ok=True)

    @staticmethod
    def _write_fps_file_(fps_file_path, fps):
        with open(fps_file_path, 'w') as w_file:
            w_file.write(str(fps))

    @staticmethod
    def _write_img_(img: np.ndarray, idx: int, imgs_dir: str):
        assert os.path.isdir(imgs_dir)
        img = np.clip(img, 0, 255).astype("uint8")
        path = os.path.join(imgs_dir, "img_%08d.png" % idx)
        cv2.imwrite(path, img)


def main():
    frame_extractor = FrameExtractor(VID_PATH, DEST_PATH)
    frame_extractor()


if __name__ == "__main__":
    # Custom parser for this script
    parser = argparse.ArgumentParser(description='Event vision arguments')
    parser.add_argument("--vid_path", type=str)
    parser.add_argument("--dest_path", type=str)

    args = parser.parse_args()

    VID_PATH = Path(args.vid_path)
    DEST_PATH = Path(args.dest_path)

    main()
