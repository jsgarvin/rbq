require File.expand_path('../lib/common', __FILE__)
require File.expand_path('../lib/library', __FILE__)
require File.expand_path('../lib/manager', __FILE__)
require File.expand_path('../lib/playlist', __FILE__)
require File.expand_path('../lib/song', __FILE__)
require 'rexml/document'
require 'fileutils'

RBQ::Manager.build_new_queue