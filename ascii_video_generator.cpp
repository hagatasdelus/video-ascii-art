#include <iostream>
#include <string>
#include <vector>
#include <opencv2/opencv.hpp>
#include <thread>
#include <chrono>

const std::string ASCII_CHARS = "@%#*+=-:. ";

char getASCIIChar(int intensity) {
    return ASCII_CHARS[intensity * ASCII_CHARS.length() / 256];
}

void clearScreen() {
    std::cout << "\033[2J\033[H" << std::flush;
}

// ANSI escape code to set cursor position
void setCursorPosition(int row, int col) {
    std::cout << "\033[" << row << ";" << col << "H" << std::flush;
}

int main() {
    cv::VideoCapture cap("video2.mp4");
    if (!cap.isOpened()) {
        std::cout << "Error opening video file" << std::endl;
        return -1;
    }

    int frame_width = cap.get(cv::CAP_PROP_FRAME_WIDTH);
    int frame_height = cap.get(cv::CAP_PROP_FRAME_HEIGHT);

    int consoleWidth = 160;
    int consoleHeight = (int)((float)frame_height / frame_width * consoleWidth * 0.375f);

    cv::Mat frame, resized_frame, gray_frame;
    std::vector<std::string> ascii_frame(consoleHeight);
    std::vector<std::string> buffer1(consoleHeight, std::string(consoleWidth, ' '));
    std::vector<std::string> buffer2(consoleHeight, std::string(consoleWidth, ' '));
    std::vector<std::string> *front_buffer = &buffer1;
    std::vector<std::string> *back_buffer = &buffer2;

    clearScreen();

    while (true) {
        cap >> frame;
        if (frame.empty())
            break;

        cv::resize(frame, resized_frame, cv::Size(consoleWidth, consoleHeight));
        cv::cvtColor(resized_frame, gray_frame, cv::COLOR_BGR2GRAY);

        // Convert frame to ASCII in the back buffer
        for (int y = 0; y < consoleHeight; ++y) {
            for (int x = 0; x < consoleWidth; ++x) {
                int intensity = gray_frame.at<uchar>(y, x);
                (*back_buffer)[y][x] = getASCIIChar(intensity);
            }
        }

        // Swap buffers
        std::swap(front_buffer, back_buffer);

        // Print the front buffer
        setCursorPosition(1, 1);
        for (const auto& line : *front_buffer) {
            std::cout << line << "\n";
        }
        std::cout << std::flush;

        // Control frame rate(30 fps)
        std::this_thread::sleep_for(std::chrono::milliseconds(33));
    }

    cap.release();
    return 0;
}
