## Build in Docker

```bash
docker build -t ascii-video-generator .
docker run -it --rm -v $(pwd):/app ascii-video-generator
./build.sh
