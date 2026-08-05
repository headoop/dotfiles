Install packages with

$ ya pkg add owner/my-plugin

To install all my favorite packages, do:
bash: for file in $(cat packages.txt); do ya pkg add "$file"; done

fish: for file in (cat packages.txt); ya pkg add "$file"; end

To upgrade all the plugins to the latest version:
$ ya pkg upgrade

List of plugins

You can list the content of package.toml with

$ ya pkg list | cut -f1 -d " "

wich will output:

Plugins:
	yazi-rs/plugins:chmod
	yazi-rs/plugins:smart-filter
	yazi-rs/plugins:diff
	KKV9/compress
	Sonico98/exifaudio
	Reledia/glow
	kirasok/epub-preview
	macydnah/office
	XYenon/clipboard
	AnirudhG07/rich-preview
	yazi-rs/plugins:mount
	ndtoan96/ouch
Flavors:
	BennyOe/tokyo-night
