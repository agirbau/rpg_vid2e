import argparse
from pathlib import Path

from extract_frames_from_video import FrameExtractor


def main():
    assert SEQS_PATH.is_dir()

    for vid_path in SEQS_PATH.iterdir():
        if vid_path.is_file():
            # Extract per video sequence
            seq_name = vid_path.stem
            dest_seq_path = DEST_PATH / seq_name

            frame_extractor = FrameExtractor(vid_path, dest_seq_path)
            print(f"Extracting frames for: {seq_name}")
            frame_extractor()


if __name__ == "__main__":
    # Custom parser for this script
    parser = argparse.ArgumentParser(description='Event vision arguments')
    parser.add_argument("--seqs_path", type=str)  # Path where all sequences are located (e.g. /home/agirbau/work/event_cameras/data/rpg_vid2e/example/vids_original)
    parser.add_argument("--dest_path", type=str)  # Path where all sequences frames will be generated (e.g. /home/agirbau/work/event_cameras/data/rpg_vid2e/example/original)

    args = parser.parse_args()

    SEQS_PATH = Path(args.seqs_path)
    DEST_PATH = Path(args.dest_path)

    main()
