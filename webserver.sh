#!/bin/bash

port=5555
dir="."

while getopts ":p:d:" opt; do
  case $opt in
    p)
      port=$OPTARG
      ;;
    d)
      dir=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

cd static
echo "Serving static folder"

python3 -m http.server $port

#cd ..
