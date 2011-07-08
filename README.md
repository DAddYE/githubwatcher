## Github Watcher

Github watcher is a simple and useful gem that help you to constantly monitor your repositories to get updates when:

* Number of watchers change
* Number of forks change
* Number of issues change
* Repo was updated

It uses [ruby forever](https://github.com/DAddYE/forever) to demonize the process.

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

``` yml
---
- daddye/all
- padrino/all
```

So if for example you want to watch [sinatra](https://github.com/sinatra/sinatra) add it, the result should look like:

``` yml
---
- daddye/all
- padrino/all
- sinatra/sinatra
```

If you want to watch **all** repositories of a given user you simply provide **/all** so will look like:

``` yml
---
- daddye/all
- padrino/all
- sinatra/all
```

Restart the deamon

```
githubwatcher start
```

Your are done!