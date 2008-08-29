#!/bin/bash
# -*- mode: Sh -*-
# Time-stamp: "2008-08-27 11:47:37 c704271"

#  file       make_doc.sh
#  copyright  (c) Philipp Schindler 2008
#  url        http://pulse-sequencer.sf.net
# Creates the documentation and uploads it to SF.net
# create a tar archive and upload it to SF

SF_USERNAME=viellieb
SF_PATH=/home/groups/p/pu/pulse-sequencer/htdocs/innsbruck/AD9910

asciidoc README
scp README.html $SF_USERNAME@shell.sf.net:$SF_PATH/index.html
