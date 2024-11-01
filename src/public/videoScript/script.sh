mkdir ../h264_hls
cd ../h264_hls

ffmpeg -i ../videoScript/bbb_sunflower_2160p_60fps_normal.mp4 \
  -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1]scale=w=1920:h=1080[v1out]; \
     [v2]scale=w=1280:h=720[v2out]; \
     [v3]scale=w=854:h=480[v3out]" \
  -map "[v1out]" -c:v:0 libx264 -b:v:0 6000k -bufsize:v:0 6000k \
  -map "[v2out]" -c:v:1 libx264 -b:v:1 2500k -bufsize:v:1 2500k \
  -map "[v3out]" -c:v:2 libx264 -b:v:2 750k -bufsize:v:2 750k \
  -map a:0 -c:a aac \
  -map a:0 -c:a aac \
  -map a:0 -c:a aac \
  -f hls \
  -hls_time 5 \
  -hls_playlist_type vod \
  -hls_flags independent_segments \
  -hls_segment_type mpegts \
  -hls_segment_filename stream_%v/data%03d.ts \
  -master_pl_name master.m3u8 \
  -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2" \
  stream_%v/bbb_h264.m3u8

mkdir ../h265_hls
cd ../h265_hls

ffmpeg -i ../videoScript/bbb_sunflower_2160p_60fps_normal.mp4 \
  -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1]scale=w=1920:h=1080[v1out]; \
     [v2]scale=w=1280:h=720[v2out]; \
     [v3]scale=w=854:h=480[v3out]" \
  -map "[v1out]" -c:v:0 libx265 -b:v:0 6000k -bufsize:v:0 6000k \
  -map "[v2out]" -c:v:1 libx265 -b:v:1 2500k -bufsize:v:1 2500k \
  -map "[v3out]" -c:v:2 libx265 -b:v:2 750k -bufsize:v:2 750k \
  -map a:0 -c:a aac \
  -map a:0 -c:a aac \
  -map a:0 -c:a aac \
  -f hls \
  -hls_time 5 \
  -hls_playlist_type vod \
  -hls_flags independent_segments \
  -hls_segment_type mpegts \
  -hls_segment_filename stream_%v/data%03d.ts \
  -master_pl_name master.m3u8 \
  -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2" \
  stream_%v/bbb_h265.m3u8

mkdir ../h264_mpd
cd ../h264_mpd

ffmpeg -re -i ../videoScript/bbb_sunflower_2160p_60fps_normal.mp4 -map 0 -map 0 -map 0 -map -0:2 -c:a aac -c:v libx264 \
-b:v:0 2500k -s:v:0 1280x720 -profile:v:0 main \
-b:v:1 750k -s:v:1  854x480 -profile:v:1 main \
-b:v:2 6000k -s:v:2  1920x1080 -profile:v:2 main \
-sc_threshold 0 -b_strategy 0 \
-use_timeline 1 -use_template 1 \
-adaptation_sets "id=0,streams=v id=1,streams=a" \
-f dash ./bbb_h264.mpd

mkdir ../h265_mpd
cd ../h265_mpd

ffmpeg -re -i ../videoScript/bbb_sunflower_2160p_60fps_normal.mp4 -map 0 -map 0 -map 0 -map -0:2 -c:a aac -c:v libx265 \
-b:v:0 2500k -s:v:0 1280x720 -profile:v:0 main \
-b:v:1 750k -s:v:1  854x480 -profile:v:1 main \
-b:v:2 6000k -s:v:2  1920x1080 -profile:v:2 main \
-sc_threshold 0 -b_strategy 0 \
-use_timeline 1 -use_template 1 \
-adaptation_sets "id=0,streams=v id=1,streams=a" \
-f dash ./bbb_h265.mpd