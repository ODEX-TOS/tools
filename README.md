[![Build Status](https://jenkins.pbfp.xyz/buildStatus/icon?job=tos-iso&style=flat-square&subject=iso+build)](https://jenkins.pbfp.xyz/job/tos-iso/)
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL License][license-shield]][license-url]
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FODEX-TOS%2Ftools.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2FODEX-TOS%2Ftools?ref=badge_shield)



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/ODEX-TOS/tools">
    <img src="https://tos.pbfp.xyz/images/logo.svg" alt="Logo" width="150" height="200">
  </a>

  <h3 align="center">TOS scripts</h3>

  <p align="center">
    This repo contains helper scripts for the TOS project
    <br />
    <a href="https://github.com/ODEX-TOS/tools"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://tos.pbfp.xyz/download">View Demo</a>
    ·
    <a href="https://github.com/ODEX-TOS/tools/issues">Report Bug</a>
    ·
    <a href="https://github.com/ODEX-TOS/tools/issues">Request Feature</a>
    ·
    <a href="https://github.com/ODEX-TOS/tos-live">TOS</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project


<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

You need the following packages

* bash
* polybar
* pacman
* rofi
* xrandr


### Installation
 
1. Clone the helper-scripts
```sh
git clone https:://github.com/ODEX-TOS/tools.git ~/bin
```
2. Install packages
```sh
pacman -Syu bash polybar-git rofi xorg-xrandr
```
3. Get emoji file
```sh
curl https://raw.githubusercontent.com/ODEX-TOS/dotfiles/master/emoji -o ~/.config/emoji
```

Make sure this repo is inside your path evnironment variable
eg

```bash
export PATH=$HOME/bin:$PATH
```



<!-- USAGE EXAMPLES -->
## Usage

We have a few usefull script in this repo

#### open
A small wrapper around xdg-open to launch applications for you.
```bash
open . # open current directory in vscode
open index.html # opens html pages in the browser
open blabla.pdf # opens pdf in zatura (or other pdf viewers)
open README.md # opens in typora a readme editor
```

#### rankmirror
A simple utility that will scan the arch repo servers and will reorder them based on speed. This way your updates will happen faster
```
rankmirror
```

#### rofiquestion
Ask the user if they want to reboot. If the answer is yes then execute the second parameter as a command

```
rofiquestion "Do you want to reboot" "sudo -A systemctl reboot"
```

#### dialogarchinstall
A simple installer to install tos (an arch based distro)

#### tos

This is a very large tool that is not going to be explained here.
See below for more information

_For more examples, please refer to the [Documentation](https://github.com/ODEX-TOS/tools/wiki)_



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/ODEX-TOS/tools/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the GPL License. See `LICENSE` for more information.



<!-- CONTACT -->

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FF0xedb%2Fhelper-scripts.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FODEX-TOS%2Ftools?ref=badge_large)

## Contact

Tom Meyers - tom@pbfp.xyz

Project Link: [https://github.com/ODEX-TOS/tools](https://github.com/ODEX-TOS/tools)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [F0xedb](https://github.com/ODEX-TOS/tools)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/F0xedb/helper-scripts.svg?style=flat-square
[contributors-url]: https://github.com/F0xedb/helper-scripts/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/F0xedb/helper-scripts.svg?style=flat-square
[forks-url]: https://github.com/F0xedb/helper-scripts/network/members
[stars-shield]: https://img.shields.io/github/stars/F0xedb/helper-scripts.svg?style=flat-square
[stars-url]: https://github.com/F0xedb/helper-scripts/stargazers
[issues-shield]: https://img.shields.io/github/issues/F0xedb/helper-scripts.svg?style=flat-square
[issues-url]: https://github.com/F0xedb/helper-scripts/issues
[license-shield]: https://img.shields.io/github/license/F0xedb/helper-scripts.svg?style=flat-square
[license-url]: https://github.com/F0xedb/helper-scripts/blob/master/LICENSE.txt
[product-screenshot]: https://tos.pbfp.xyz/images/logo.svg
