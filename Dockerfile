FROM gentoo/stage3:latest AS deps

ENV TARGET=x86_64-pc-linux-gnu
ENV CROSSROOT="/usr/${TARGET}"

RUN echo 'MAKEOPTS="-j2"' >> /etc/portage/make.conf && echo 'ACCEPT_KEYWORDS="amd64 ~amd64"' >> /etc/portage/make.conf

RUN emerge-webrsync
RUN emerge -vq --deep --newuse @world

RUN emerge -vq \
	sys-devel/crossdev \
	app-eselect/eselect-repository

RUN eselect repository create crossdev
RUN crossdev --target "$TARGET"

WORKDIR "$CROSSROOT"

RUN wget https://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64-openrc/stage3-amd64-openrc-20260322T154603Z.tar.xz -O stage3-amd64-latest.tar.xz
RUN tar -xJpf stage3-amd64-latest.tar.xz -C "$CROSSROOT" --exclude=dev --skip-old-files

RUN echo 'MAKEOPTS="-j2"' >> "${CROSSROOT}/etc/portage/make.conf" && echo 'FEATURES="buildpkg"' >> "${CROSSROOT}/etc/portage/make.conf"

RUN PORTAGE_CONFIGROOT="${CROSSROOT}" eselect profile set default/linux/amd64/23.0
RUN emerge-"${TARGET}" -vq --deep --newuse @world

CMD [ "/bin/bash" ]
