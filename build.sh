#!/bin/bash

# Check if the C++ file exists
if [ ! -f "ascii_video_generator.cpp" ]; then
    echo "Error: ascii_video_generator.cpp not found in the current directory."
    exit 1
fi

# Check if video.mp4 files exist
if ! ls video*.mp4 1> /dev/null 2>&1; then
    echo "Error: video*mp4 not found in the current directory."
    exit 1
fi

# Compile
g++ -std=c++11 ascii_video_generator.cpp -o ascii_video_generator $(pkg-config --cflags --libs opencv4) -pthread

# Check if compilation was successful
if [ $? -ne 0 ]; then
    echo "Compilation failed. Please check the error messages above."
    exit 1
fi

# Run the program
./ascii_video_generator
