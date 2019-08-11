
# home of ffmpeg executable
$ffmpeg = $env:FFMPEG_HOME
# home of youtube-dl executable
$youtubedl = $env:YOUTUBE_DL_HOME

function download {
    & $youtubedl --ffmpeg-location $ffmpeg -x --audio-format mp3 --audio-quality 192K $args
}

download $args