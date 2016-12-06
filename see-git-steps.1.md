see-git-steps(1) -- See git commits step by step
=================================

## SYNOPSIS

`see-git-steps` [-hVtvis] [-c `commit`]

## OPTIONS

  `-h, --help`              display this message

  `-V, --version`           output version

  `-t, --test`              display the result of the basic test

  `-v, --verbose`           enable verbose output

  `-c, --commit`            number of `commit` where to start

  `-i, --interaction`       display one commit at a time and expect enter or [yY] to display the next commit

  `-s, --skip-question`     no display the question between each commit

## USAGE

  This script works if you have installed on your device the git program

    $ see-git-steps -t

  display OK if you have installed on your device git program
  display KO if you don't have installed on your device git program

    $ see-git-steps -c 9680dc4

  display only description of the commits from old to new until the `commit`,
  then if the description starts with `step [0-9]*`, display also the file of the commit

    $ see-git-steps -c 9680dc4 -v

  display only description of the commits from old to new until the `commit`,
  then display the file of the commit and if the description starts with `step [0-9]*`, display also the diff

    $ see-git-steps -v -i -s

  display one commit at a time and expect enter or [yY] to display the next commit
  display the file of the commit and if the description starts with `step [0-9]*`, display also the diff

## AUTHOR

  Alessandra Bilardi <alessandra.bilardi@gmail.com>

## REPORTING BUGS

  https://github.com/bilardi/see-git-steps/issues

## SEE ALSO

  `git`(1), `git-log`(1)

## LICENSE

  MIT (C) Copyright Alessandra Bilardi 2016

