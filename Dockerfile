FROM gentoo/stage3 AS deps

ENV CROSSROOT=/usr/aarch64-unknown-linux-gnu

RUN emerge-webrsync

RUN emerge -v \
	sys-devel/crossdev \
	app-eselect/eselect-repository

RUN eselect repository create crossdev
RUN crossdev --target aarch64-unknown-linux-gnu

RUN mkdir -pv "$CROSSROOT/etc/portage/package.use"

COPY ./scripts/write_flags.sh /scripts/write_flags.sh
COPY ./package.use/system "$CROSSROOT/etc/portage/package.use/system"
RUN /scripts/write_flags.sh "$CROSSROOT/etc/portage/make.conf"
RUN PORTAGE_CONFIGROOT="$CROSSROOT" eselect profile set default/linux/arm64/23.0

RUN USE=build aarch64-unknown-linux-gnu-emerge -v baselayout
RUN aarch64-unknown-linux-gnu-emerge -v1 sys-libs/glibc
RUN aarch64-unknown-linux-gnu-emerge -v1 @system

RUN emerge-aarch64-unknown-linux-gnu -vq @system

FROM deps AS prod

CMD [ "/bin/bash" ]
