## Github Watcher

Github watcher is a simple and useful gem that help you to constantly monitor your repositories to get updates when:

* Number of watchers change
* Number of forks change
* Number of issues change
* Repo was updated

It uses [foreverb](https://github.com/DAddYE/foreverb) to demonize the process.

A [demonstration video is here](http://www.daddye.it/post/7275490125/github-growl)

## Prerequisites

You need to have **growlnotify** installed. To do that you can install it through official [site](http://growl.info) or
if you have the awesome [brew](https://github.com/mxcl/homebrew) simply with:

``` sh
$ brew install growlnotify
```

## Installation

``` sh
$ sudo gem install githubwatcher
$ githubwatcher start
$ githubwatcher stop
```

## Configuration

You need to tell to our program which repositories you want to watch, to do that simply edit ```~/.githubwatcher/repos.yaml```
with your favorite editor.

Should look like this (if you have ran ```githubwatcher start```)

We provide a `config` command to easily edit it.

``` sh
$ githubwatcher config
```

It will open in texmate or vim this:

``` yaml
---
- daddye/all
- padrino/all
```

So if for example you want to watch [sinatra](https://github.com/sinatra/sinatra) add it, the result should look like:

``` yaml
---
- daddye/all
- padrino/all
- sinatra/sinatra
```

If you want to watch **all** repositories of a given user you simply provide **/all** so will look like:

``` yaml
---
- daddye/all
- padrino/all
- sinatra/all
```

Restart the deamon

``` sh
$ githubwatcher restart
```

## Using a different API

Simply edit `~/.githubwatcher/api.yaml` and set a custom url and api version. If you are using GitHub:FI the
version has to be v2 for now.

## Working with Ruby Forever

``` sh
$ foreverb list
PID    RSS    CPU  CMD
12494  27132  0.2  Forever: /usr/bin/githubwatcher

$ foreverb stop github
Do you want really stop Forever: /usr/bin/githubwatcher  with pid 12494? y
Killing process Forever: /usr/bin/githubwatcher  with pid 12494...
```

Your are done!

## Hacks

In some env you use `sudo gem install`, so in this case the first time you launch the app use `sudo`,
in this way will be generated the `Gemfile.lock`, in future you will be able to run it without `sudo`.

## Author

DAddYE, you can follow me on twitter [@daddye](http://twitter.com/daddye)
