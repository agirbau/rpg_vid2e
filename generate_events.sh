#!/usr/bin/env bash


# Usage: ./generate_events.sh /path/to/video.mp4

set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 /path/to/video.mp4"
	exit 1
fi

vid_path="$1"
vid2e_path="$(dirname "$0")"

# Get root directory from video path (remove extension)
root_dir="$(dirname "$vid_path")"
base_name="$(basename "$vid_path" | sed 's/\.[^.]*$//')"

# Output directories
frames_dir="$root_dir/${base_name}_frames"
upsampled_dir="$root_dir/${base_name}_upsampled"
events_dir="$root_dir/${base_name}_events"

#mkdir -p "$frames_dir" "$upsampled_dir" "$events_dir"

# Extract frames from video
python "$vid2e_path/utils_scripts/extract_frames_from_video.py" --vid_path="$vid_path" --dest_path="$frames_dir"

# Generate slow motion gray-scale frames
python "$vid2e_path/upsampling/upsample.py" --input_dir="$frames_dir" --output_dir="$upsampled_dir"

# Generate events from slow motion video
contrast_threshold_neg=0.2
contrast_threshold_pos=0.2
refractory_period_ns=0

python "$vid2e_path/esim_torch/scripts/generate_events.py" --input_dir="$upsampled_dir" --output_dir="$events_dir" --contrast_threshold_neg="$contrast_threshold_neg" --contrast_threshold_pos="$contrast_threshold_pos" --refractory_period_ns="$refractory_period_ns"

# Render video of event data
# TODO
