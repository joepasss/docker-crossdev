FROM gentoo/stage3 AS deps

ENV CROSSROOT=/usr/aarch64-unknown-linux-gnu

RUN emerge-webrsync

RUN emerge -v \
	sys-devel/crossdev \
	app-eselect/eselect-repository

RUN eselect repository create crossdev
RUN crossdev --target aarch64-unknown-linux-gnu

RUN mkdir -v /scripts
RUN mkdir -v /sources
RUN mkdir -pv "$CROSSROOT/etc/portage/package.use"
RUN rm -rv "$CROSSROOT/etc/portage/make.conf"

WORKDIR /sources
COPY ./cross-git.txt /sources/cross-git.txt
COPY ./cross-glib.txt /sources/cross-glib.txt

COPY ./scripts/get_stage3.sh /scripts/get_stage3.sh
COPY ./scripts/write_makeopts.sh /scripts/write_makeopts.sh
COPY ./scripts/glib_build.sh /scripts/glib_build.sh
COPY ./scripts/git_build.sh /scripts/git_build.sh

COPY ./portage/package.use/system "$CROSSROOT/etc/portage/package.use/system"
COPY ./portage/make.conf "$CROSSROOT/etc/portage/make.conf"

RUN /scripts/get_stage3.sh
RUN /scripts/write_makeopts.sh "$CROSSROOT/etc/portage/make.conf"
RUN PORTAGE_CONFIGROOT="$CROSSROOT" eselect profile set default/linux/arm64/23.0

RUN emerge -vq \
	dev-build/cmake \
	dev-libs/glib \
	dev-util/glib-utils

RUN emerge-aarch64-unknown-linux-gnu -vq @system
RUN emerge-aarch64-unknown-linux-gnu -vq \
	dev-build/meson \
	dev-build/ninja \
	dev-build/cmake

RUN /scripts/glib_build.sh
RUN /scripts/git_build.sh

# CLEANUP
WORKDIR /
RUN rm -rf /scripts
RUN rm -rf /sources

FROM deps AS prod

CMD [ "/bin/bash" ]
