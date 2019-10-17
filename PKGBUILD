# Maintainer: Tom Meyers tom@odex.be
pkgname=tos-tools
pkgver=r283.0792d31
pkgrel=1
pkgdesc="A lot of tools used to make life easier on tos"
arch=(any)
url="https://github.com/ODEX-TOS/tools"
_reponame="tools"
license=('GPL')

source=(
"git+https://github.com/ODEX-TOS/tools.git")
md5sums=('SKIP')
depends=('git' 'bash' 'python' 'rofi' 'feh' 'bluez-utils' 'gnupg' 'networkmanager' 'python-pywal')
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
        install -Dm755 import-gsettings "$pkgdir"/usr/bin/import-gsettings
        install -Dm755 keepalive.sh "$pkgdir"/usr/bin/keepalive.sh
        install -Dm755 open "$pkgdir"/usr/bin/open
        install -Dm755 rankmirror "$pkgdir"/usr/bin/rankmirror
        install -Dm755 rofiquestion "$pkgdir"/usr/bin/rofiquestion
        install -Dm755 rofiselect "$pkgdir"/usr/bin/rofiselect
        install -Dm755 spotify.py "$pkgdir"/usr/bin/spotify.py
        install -Dm755 swayfig.sh "$pkgdir"/usr/bin/swayfig.sh
        install -Dm755 tos "$pkgdir"/usr/bin/tos
        install -Dm755 touchpad.sh "$pkgdir"/usr/bin/touchpad.sh
        install -Dm755 cleanup.sh "$pkgdir"/usr/bin/cleanup.sh
        
        # copy subdir from rofi
        mkdir -p "$pkgdir"/usr/share/tos-rofi
        mv rofi tos-rofi
        for file in tos-rofi/* ; do
            install -Dm755 "$file" "$pkgdir"/usr/share/"$file"
        done

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
}
