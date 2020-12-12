# Maintainer: Tom Meyers tom@odex.be
pkgname=tos-tools
pkgver=r294.9cfe489
pkgrel=1
pkgdesc="A lot of tools used to make life easier on tos"
arch=(any)
url="https://github.com/ODEX-TOS/tools"
_reponame="tools"
license=('GPL')

source=(
"git+https://github.com/ODEX-TOS/tools.git")
md5sums=('SKIP')
depends=('git' 'bash' 'bluez-utils' 'gnupg' 'networkmanager' 'pacman-contrib' 'checkupdates-aur-tos' 'imagemagick' 'light')
makedepends=('git')

pkgver() {
  cd "$srcdir/$_reponame"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}


build() {
    return 0;
}

package() {
        cd "$srcdir/$_reponame"
        # install common packages
        install -Dm755 open "$pkgdir"/usr/bin/open
        install -Dm755 rankmirror "$pkgdir"/usr/bin/rankmirror
        install -Dm755 tos "$pkgdir"/usr/bin/tos
        install -Dm755 cleanup.sh "$pkgdir"/usr/bin/cleanup.sh
        install -Dm755 brightness "$pkgdir"/usr/bin/brightness
        install -Dm755 checkupdates-tos "$pkgdir"/usr/bin/checkupdates-tos
        install -Dm755 09-timezone.NM "$pkgdir"/etc/NetworkManager/dispatcher.d/09-timezone

        # installer
        mkdir -p "$pkgdir"/usr/share/tos-installer
        mv installer tos-installer
        for file in tos-installer/* ; do
            install -Dm755 "$file" "$pkgdir"/usr/share/"$file"
        done

        # tos-helper
        mkdir -p "$pkgdir"/usr/share/tos-helper
        for file in tos-helper/* ; do
            install -Dm755 "$file" "$pkgdir"/usr/share/"$file"
        done

        # tos tutorial
        mkdir -p "$pkgdir/usr/share/tos-tutorial/tree"
        for file in tos-tutorial/tree/* ; do
            install -Dm755 "$file" "$pkgdir"/usr/share/"$file"
        done
        install -Dm755 "tos-tutorial/main.sh" "$pkgdir/usr/share/tos-tutorial/main.sh"

        # setup the tutorial application
        install -Dm644 "tos-tutorial.desktop" "$pkgdir/usr/share/applications/tos-tutorial.desktop"
}
