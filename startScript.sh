#!/usr/bin/env bash

log() {
  echo "STARTSCRIPT: $1"
}

buildApp() {
  log "Building app binary"
  chmod +x /build/build.sh
  /build/build.sh
}

runApp() {
  log "Run app"

  log "Killing old app"
  killall dlv
  killall app
  log "Run in debug mode"
  dlv --log --listen=:40000 --headless=true --api-version=2 --accept-multiclient exec /app -- "$@" &
}

rerunApp() {
  log "Rerun app"
  buildApp
  runApp "$@"
}

liveReloading() {
  log "Run liveReloading"
  inotifywait -e "MODIFY,DELETE,MOVED_TO,MOVED_FROM" -m -r /build | (
    # read changes from inotify, batch results to a second (read -t 1)
    while true; do
      read path action file
      ext=${file: -3}
      if [[ "$ext" == ".go" ]]; then
        echo "$file"
      fi
    done
  ) | (
    WAITING=""
    while true; do
      file=""
      read -t 1 file
      if test -z "$file"; then
        if test ! -z "$WAITING"; then
          echo "CHANGED"
          WAITING=""
        fi
      else
        log "File ${file} changed" >>/tmp/filechanges.log
        WAITING=1
      fi
    done
  ) | (
    # read statement release when some file has been changed
    while true; do
      read TMP
      log "File Changed. Reloading..."
      rerunApp "$@"
    done
  )
}

initializeFileChangeLogger() {
  echo "" > /tmp/filechanges.log
  tail -f /tmp/filechanges.log &
}

main() {
  initializeFileChangeLogger
  buildApp
  runApp "$@"
  liveReloading "$@"
}

echo "$@"
main "$@"
