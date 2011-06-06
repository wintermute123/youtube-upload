#!/bin/bash
# Upload videos to youtube using youtube-upload and curl.
#
#   $ youtube-upload --get-upload-form-info ... | upload_with_curl.sh [CURL_EXTRA_OPTIONS]
#
set -e

debug() { 
  echo "$@" >&2 
}

get_video_id_from_headers() {
  grep -m1 "^Location: " | grep -o "id=[^&]\+" | cut -d"=" -f2-
}

### Main

while { read FILE; read TOKEN; read POST_URL; }; do
  debug "start upload: $FILE -> $POST_URL (token: $TOKEN)"
  REDIRECT_URL="http://code.google.com/p/youtube-upload"
  VIDEO_ID=$(curl --include -F "token=$TOKEN" -F "file=@$FILE" "$@" \
             "$POST_URL?nexturl=$REDIRECT_URL" | get_video_id_from_headers)
  echo "http://www.youtube.com/watch?v=$VIDEO_ID"
done