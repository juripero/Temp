# v0.34.0 compliant layout alignment
# Ensure cond_video_rows matches the target frame_rows after padding
if cond_video_rows.shape[0] != all_video_rows[~img_update].shape[0]:
    # Align rows based on the new PackedLayout padded frame dimensions
    # slicing or padding cond_video_rows to fit the active ~img_update mask space
    cond_video_rows = cond_video_rows[:all_video_rows[~img_update].shape[0]]

all_video_rows[~img_update] = cond_video_rows