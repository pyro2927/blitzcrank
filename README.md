# Blitzcrank

[![Blitz](./img/BlitzcrankSquare.png)](http://leagueoflegends.wikia.com/wiki/Blitzcrank)

Copy down remote files and sort them into local directories with ease.

## Installation

Install it with:

    $ gem install blitzcrank

## Setup

Blitzcrank requires a small amount of setup.  First, it mainly does transfers via ssh of a remote host and your local machine.  In order to do so you'll have to have a yaml config file at `~/.blitzcrank`.

### Sample Config File

	$ cat ~/.blitzcrank
	---
	:base_tv_dir: "/Volumes/Public/TV Shows/"
	:remote_user: "root"
	:remote_host: "subdomain.domain.tld"
	:remote_base_dir: "~/torrents/"
	
This can be generated with [Mana Barrier](#mana-barrier)

### Sample Directory Structure

When transfering TV shows, they will be structured in the format of `/<TV_BASE_DIR>/<SHOW_NAME>/<SEASON NUMBER>/<EPISODE>.mkv`.

	/Volumes/Public/TV\ Shows/
	├── Pioneer One
	│   ├── Season\ 1
	├── SHOW2
	│   ├── Season\ 1
	│   ├── Season\ 2
	│   ├── Season\ 3
	│   └── Season\ 4
	└─── SHOW3
	    ├── Season\ 1
	    └── Season\ 2

Movies are all contained in a single directory, so a folder structure isn't required.

## Usage

### Mana Barrier
![Blitz](./img/Mana_Barrier.jpg)

	$ manabarrier
	
Mana Barrier will populate a sample config file if you do not have one already in place.  The location for this is in `~/.blitzcrank`.

### Rocket Grab

	$ rocketgrab
	$ rocketgrab "search1"
	$ rocketgrab "search1" "search 2" ...
	
Use `rocketgrab` to pull down remote files and sort them into local directories.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
