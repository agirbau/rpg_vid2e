# Script to generate timestamps without having to go through upsampling
import argparse
import os
from pathlib import Path
from upsampling.utils.utils import fps_filename, fps_from_file


def write_timestamps(timestamps: list, timestamps_filename: str):
    # From upsampler
    with open(timestamps_filename, 'w') as t_file:
        t_file.writelines([str(t) + '\n' for t in timestamps])


def main(input_dir, output_dir):
    # Look for fps.txt, read it, generate linspace with frame timestamps
    seqs_path = (seq_path for seq_path in input_dir.iterdir() if seq_path.is_dir())

    for seq_path in seqs_path:
        img_path = seq_path / 'imgs'
        seq_len = len([ff for ff in img_path.iterdir() if ff.is_file()])
        fps_file = f'{seq_path}/{fps_filename}'
        fps = fps_from_file(fps_file)
        timestamps = [ii/fps for ii in range(seq_len)]
        timestamps_filename = output_dir / seq_path.stem / 'timestamps.txt'
        write_timestamps(timestamps, timestamps_filename)

    print('Success!')


if __name__ == "__main__":
    parser = argparse.ArgumentParser("""Generate events from a folder""")
    parser.add_argument("--input_dir", "-i", default="", required=True)
    parser.add_argument("--output_dir", "-o", default="", required=True)
    args = parser.parse_args()

    main(Path(args.input_dir), Path(args.output_dir))
