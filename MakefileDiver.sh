#!/bin/bash

# Function to check if the C++ file exists
check_cpp_file() {
    if [ ! -f "AsciiVideoGenerator.cpp" ]; then
        echo "Error: AsciiVideoGenerator.cpp not found in the current directory."
        exit 1
    fi
}

# Function to check if video.mp4 files exist
check_video_files() {
    if ! ls video*.mp4 1> /dev/null 2>&1; then
        echo "Error: video*.mp4 not found in the current directory."
        exit 1
    fi
}

# Function to compile the program
compile() {
    g++ -std=c++20 AsciiVideoGenerator.cpp -o AsciiVideoGenerator $(pkg-config --cflags --libs opencv4) -pthread
    if [ $? -ne 0 ]; then
        echo "Compilation failed. Please check the error messages above."
        exit 1
    fi
}

# Function to run the program
run() {
    ./AsciiVideoGenerator
}

# Main script logic
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
        ;;
    "run")
        check_cpp_file
        check_video_files
        compile
        run
        ;;
    "test")
        echo "No tests defined yet."
        ;;
    "install")
        echo "Installation not implemented yet."
        ;;
    "open")
        echo "Open functionality not implemented yet."
        ;;
    *)
        echo "Unknown command: $1"
        echo "Usage: $0 [clean|run|test|install|open]"
        exit 1
        ;;
esac
