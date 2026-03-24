FROM gentoo/portage:latest AS portage_tree
FROM gentoo/stage3:latest AS deps

COPY --from=portage_tree /var/db/repos/gentoo /var/db/repos/gentoo

ENV CHOST=x86_64-unknown-linux-gnu
ENV CROSSROOT=/usr/x86_64-unknown-linux-gnu

RUN echo 'MAKEOPTS="-j2"' >> /etc/portage/make.conf

RUN emerge -vq \
	sys-devel/crossdev \
	app-eselect/eselect-repository

RUN eselect repository create crossdev
RUN crossdev --target "$CHOST"

RUN USE=build "$CHOST"-emerge -v1 baselayout
RUN "$CHOST"-emerge -v1 sys-libs/glibc
RUN "$CHOST"-emerge -v1 @system

RUN PORTAGE_CONFIGROOT="$CROSSROOT" eselect profile set default/linux/amd64/23.0

CMD [ "/bin/bash" ]
