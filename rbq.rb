require 'rexml/document'
require 'lib/manager'
require 'lib/playlist'
require 'lib/library'
require 'lib/song'

manager = RBQ::Manager.new('~/.gnome2/rhythmbox')
manager.build_new_queue