require 'rexml/document'
require 'singleton'
require 'ftools'
require 'lib/song'
require 'lib/common'

module RBQ
  class Library
    include Singleton
    
    class << self
      include SharedLibraryPlaylistMethods
      attr_reader :songs
      attr_writer :path, :filename
      
      def path; @path ||= '~/.gnome2/rhythmbox'; end
      def filename; @filename ||= 'rhythmdb.xml'; end
      
      def load
        @songs = []
        $stdout.sync = true
        counter = 0
        total = xml_doc.root.get_elements("entry[@type='song']").size
        xml_doc.root.each_element_with_attribute('type', 'song') do |el|
          @songs << Song.new(el)
          counter += 1
          print "\rLoading Library: #{((counter.to_f/total)*100).to_i}%"
        end
        puts
      end
    
      def total_weight
        songs.inject(0) {|total,song| total + song.weight }
      end
      
      def pick_a_song
        target = rand(total_weight)
        counter = 0
        songs.each do |song|
          counter += song.weight
          return song if counter >= target
        end
      end
      
    end
  end
end