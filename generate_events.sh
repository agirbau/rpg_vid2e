#!/usr/bin/env bash

# Paths of python interpreters
vid2e_path="/home/user/app"
data_path="/home/user/datasets"

# Video data to convert to events
vids_orig_path="$data_path"/event_camera_tests/simulated/blender/cube_1/cube_1_vid.mp4
# Path of original frames
seqs_orig_path="$data_path"/event_camera_tests/simulated/blender/cube_1/frames
# Path of upsampled frames
seqs_ups_path="$data_path"/event_camera_tests/simulated/blender/cube_1/upsampled
# Path of events
seqs_evs_path="$data_path"/event_camera_tests/simulated/blender/cube_1/events

# Extract frames from video
python "$vid2e_path"/utils_scripts/extract_frames_from_video.py --vid_path="$vids_orig_path" --dest_path="$seqs_orig_path"

# Generate slow motion gray-scale frames
python "$vid2e_path"/upsampling/upsample.py --input_dir="$seqs_orig_path" --output_dir="$seqs_ups_path"

# Generate events from slow motion video
# Vars
contrast_threshold_neg=0.2
contrast_threshold_pos=0.2
refractory_period_ns=0

python "$vid2e_path"/esim_torch/scripts/generate_events.py --input_dir="$seqs_ups_path" --output_dir="$seqs_evs_path" --contrast_threshold_neg="$contrast_threshold_neg" --contrast_threshold_pos="$contrast_threshold_pos" --refractory_period_ns="$refractory_period_ns"

# Render video of event data
# TODO
