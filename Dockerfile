FROM alpine:3.4

MAINTAINER Tomas Basham <me@tomasbasham.co.uk>

ENV DEPOT_TOOLS /depot_tools
ENV RPI_TOOLS /rpi_tools
ENV ROOTFS /rootfs
ENV PATH $RPI_TOOLS/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:$PATH:$DEPOT_TOOLS

# Build flags
ENV GYP_CROSSCOMPILE 1
ENV GYP_DEFINES "target_arch=arm arm_float_abi=hard clang=0 include_tests=0 sysroot=${ROOTFS} werror="
ENV GYP_GENERATOR_OUTPUT arm

# Install webrtc
RUN apk add --no-cache bash curl debootstrap g++ git perl python \
  && git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git ${DEPOT_TOOLS} \
  && git clone --depth 1 https://github.com/raspberrypi/tools.git ${RPI_TOOLS} \
  && debootstrap --arch armhf --foreign --include=g++,libasound2-dev,libpulse-dev,libudev-dev,libexpat1-dev,libnss3-dev,libgtk2.0-dev wheezy ${ROOTFS} \
  && curl -sSL https://github.com/multiarch/qemu-user-static/releases/download/v2.5.0/x86_64_qemu-arm-static.tar.gz | tar -C /rootfs/usr/bin -zxf -

  # This will not run because the image needs certain privileges to mount volumes
  # && chroot ${ROOTFS} /debootstrap/debootstrap --second-stage \

  # && find ${ROOTFS}/usr/lib/arm-linux-gnueabihf -type l -print | while read target; do \
  #   ln -snfv "../../../$(basename $target)" "${target}"; \
  # done \
  # && find ${ROOTFS}/usr/lib/arm-linux-gnueabihf/pkgconfig -print | while read target; do \
  #   ln -snfv "../../lib/arm-linux-gnueabihf/pkgconfig/$(basename $target)" ${ROOTFS}/usr/share/pkgconfig/$(basename $target); \
  # done \

  # && fetch --no-history --nohooks webrtc \
  # && gclient sync --verbose \
  # && ninja -C $(PWD)/src/arm/out/Release \
  # && apk del curl debootstrap g++ git perl python \
  # && rm -rf $DEPOT_TOOLS $RPI_TOOLS $ROOTFS /var/cache/apk/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
