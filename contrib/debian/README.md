
Debian
====================
This directory contains files used to package Pararad/Parara-qt
for Debian-based Linux systems. If you compile Pararad/Parara-qt yourself, there are some useful files here.

## Parara: URI support ##


Parara-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install Parara-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your Pararaqt binary to `/usr/bin`
and the `../../share/pixmaps/Parara128.png` to `/usr/share/pixmaps`

Parara-qt.protocol (KDE)

