require 'rexml/document'
require 'singleton'
require 'lib/manager'
require 'lib/playlist'
require 'lib/library'
require 'lib/song'

RBQ::Manager.set_path('~/.gnome2/rhythmbox')
RBQ::Manager.build_new_queue