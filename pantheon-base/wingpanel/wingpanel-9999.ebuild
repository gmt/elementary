# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VALA_MIN_API_VERSION=0.16
VALA_MAX_API_VERSION=0.16

inherit fdo-mime gnome2-utils vala cmake-utils bzr

DESCRIPTION="Stylish top panel that holds indicators and spawns an application launcher"
HOMEPAGE="https://launchpad.net/wingpanel"
EBZR_REPO_URI="lp:wingpanel"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgee:0
	dev-libs/libindicator:3
	x11-libs/gtk+:3
	x11-libs/granite
	x11-libs/libX11"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	DOCS="AUTHORS COPYING COPYRIGHT"
}

src_prepare() {
	use nls || sed -i 's/add_subdirectory (po)//' CMakeLists.txt

	# Disable slide in animation since it is broken.
	#epatch "$FILESDIR/${P}-no-animation.patch"

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DINDICATORDIR="$(pkg-config --variable=indicatordir indicator3-0.4)"
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_schemas_update
}

