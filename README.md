# TxtDevs - Docker custom images for Linux/ARM64 - AARCH64
- Based on latest aarch64 images
- Native build from ARM Machine
- Build with ❤️ Love and ✨ Magic
- Environment configuration support
- Well-documented (if I have time to write)

## Configurable Dockerfile
I'm not hardcoded any architecture on Dockerfile, instead use `TARGETPLATFORM`, `BUILDPLATFORM` and `TARGETARCH` augments.
So, if you want to build AMD64 (x86_64) or ARMv7,... just change --platform variable when build docker image

> Note: go-replace and gosu will match your selected architecture if you based on txtdevs/barebone:minimal image.

## Official Images
Currently, my PHP build based on the official PHP images - PHP 7.4 and PHP 8.1

## How to use
1. Clone the repository to local
2. Find the image you want to build on `Dockerfile` folder
3. Open `Dockerfile` file and change what you need
4. Run build command:
```bash
$ docker buildx --platform=linux/arm64 -t <username>/<image_name>:your_tag .
```
5. Done, be happy with your image.

## Resources
| Image | Version | Note |
| :--- | :----: | :----: |
| Barebone | Minimal | alpine:latest, go-replace 22.10.0, gosu 1.14|
| PHP | 7.4 | FPM - debian:bullseye|
| PHP | 8.1 | FPM - debian:bullseye|
| Apache - PHP| latest | PHP 7.4 FPM - debian:bullseye|
| Apache - PHP| latest | PHP 8.1 FPM - debian:bullseye|
| Nginx - PHP| latest | PHP 7.4 FPM - debian:bullseye|
| Nginx - PHP| latest | PHP 8.1 FPM - debian:bullseye|
