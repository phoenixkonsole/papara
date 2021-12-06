
Debian
====================
This directory contains files used to package paparad/papara-qt
for Debian-based Linux systems. If you compile paparad/papara-qt yourself, there are some useful files here.

## papara: URI support ##


papara-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install papara-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your paparaqt binary to `/usr/bin`
and the `../../share/pixmaps/papara128.png` to `/usr/share/pixmaps`

papara-qt.protocol (KDE)

