FROM gentoo/stage3 AS deps

RUN emerge-webrsync

RUN emerge -v \
	sys-devel/crossdev \
	app-eselect/eselect-repository

RUN eselect repository create crossdev
RUN crossdev --target aarch64-unknown-linux-gnu

FROM deps AS prod

CMD [ "/bin/bash" ]
