#!/usr/bin/env bash

# Paths of python interpreters
vid2e_path="/home/agirbau/work/event_cameras/rpg_vid2e"
evVision_path="/home/agirbau/work/event_cameras/eventVision"
python_vid2e="$vid2e_path/venv/bin/python"
python_evVision="$evVision_path/venv/bin/python"
# Path for saving data and results
vid2e_data_path="/home/agirbau/work/event_cameras/data/rpg_vid2e"

# Video data to convert to events
data_path=""

# Extract frames from video

# Generate slow motion gray-scale frames
"$python_vid2e" "$vid2e_path"/upsampling/upsample.py --input_dir="$vid2e_data_path"/example/original --output_dir="$vid2e_data_path"/example/upsampled

# Generate events from slow motion video
# Vars
contrast_threshold_neg=0.2
contrast_threshold_pos=0.2
refractory_period_ns=0

"$python_vid2e" "$vid2e_path"/esim_torch/scripts/generate_events.py --input_dir="$vid2e_data_path"/example/upsampled --output_dir="$vid2e_data_path"/example/events --contrast_threshold_neg="$contrast_threshold_neg" --contrast_threshold_pos="$contrast_threshold_pos" --refractory_period_ns="$refractory_period_ns"

# Render video of event data
"$python_evVision" "$evVision_path"/src/generate_event_frames.py --ev_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/events/seq0 --img_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/original/seq0/imgs --tstmp_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/upsampled/seq0 --save_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/ev_representation
