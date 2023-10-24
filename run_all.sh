#!/usr/bin/env bash

# Paths of python interpreters
vid2e_path="/home/agirbau/work/event_cameras/rpg_vid2e"
evVision_path="/home/agirbau/work/event_cameras/eventVision"
python_vid2e="$vid2e_path/venv/bin/python"
python_evVision="$evVision_path/venv/bin/python"
# Path for saving data and results
vid2e_data_path="/home/agirbau/work/event_cameras/data/rpg_vid2e"

# Video data to convert to events
vids_orig_path="$vid2e_data_path"/example/vids_original
# Path of original frames
seqs_orig_path="$vid2e_data_path"/example/original
# Path of upsampled frames
seqs_ups_path="$vid2e_data_path"/example/upsampled
# Path of events
seqs_evs_path="$vid2e_data_path"/example/events
# Path of event representation
ev_repr_path="$vid2e_data_path"/example/ev_representation

# Extract frames from video
"$python_vid2e" "$vid2e_path"/utils_scripts/script_extract_frames_from_seqs.py --seqs_path="$vids_orig_path" --dest_path="$seqs_orig_path"

# Generate slow motion gray-scale frames
"$python_vid2e" "$vid2e_path"/upsampling/upsample.py --input_dir="$seqs_orig_path" --output_dir="$seqs_ups_path"

# Generate events from slow motion video
# Vars
contrast_threshold_neg=0.2
contrast_threshold_pos=0.2
refractory_period_ns=0

"$python_vid2e" "$vid2e_path"/esim_torch/scripts/generate_events.py --input_dir="$seqs_ups_path" --output_dir="$seqs_evs_path" --contrast_threshold_neg="$contrast_threshold_neg" --contrast_threshold_pos="$contrast_threshold_pos" --refractory_period_ns="$refractory_period_ns"

# Render video of event data
readarray -d '' seqs_path < <(find "$seqs_orig_path" -mindepth 1 -maxdepth 1 -type d -print0)
mapfile -t seqs_path_sorted < <(printf "%s\n" "${seqs_path[@]}" | sort)

for seq_path in "${seqs_path_sorted[@]}"; do
  seq_name=$(basename "$seq_path")
  echo "$seq_name"
  # --ev_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/events/vidseq
  # --img_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/original/vidseq/imgs
  # --tstmp_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/upsampled/vidseq
  # --save_path /home/agirbau/work/event_cameras/data/rpg_vid2e/example/ev_representation

  ev_path="$seqs_evs_path"/"$seq_name"
  img_path="$seqs_ups_path"/"$seq_name"/imgs
  tstmp_path="$seqs_ups_path"/"$seq_name"
  save_path="$ev_repr_path"/"$seq_name"

  "$python_evVision" "$evVision_path"/src/generate_event_frames.py --ev_path "$ev_path" --img_path "$img_path" --tstmp_path "$tstmp_path" --save_path "$save_path" --render_orig

done
