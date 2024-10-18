#!/bin/bash

check_cpp_file() {
    if [ ! -f "AsciiVideoGenerator.cpp" ]; then
        echo "Error: AsciiVideoGenerator.cpp not found in the current directory."
        exit 1
    fi
}

check_video_files() {
    if ! ls video*.mp4 1> /dev/null 2>&1; then
        echo "Error: video.mp4 not found in the current directory."
        exit 1
    fi
}

compile() {
    g++ -std=c++20 AsciiVideoGenerator.cpp -o AsciiVideoGenerator $(pkg-config --cflags --libs opencv4) -pthread
    if [ $? -ne 0 ]; then
        echo "Compilation failed. Please check the error messages above."
        exit 1
    fi
}

run() {
    ./AsciiVideoGenerator
}

case "$1" in
    "")
        check_cpp_file
        check_video_files
        compile
        run
        ;;
    "clean")
        rm -f AsciiVideoGenerator
        echo "Cleaned up compiled files."
        ;;`
    *)
        echo "Unknown command: $1"
        exit 1
        ;;
esac
