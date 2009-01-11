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
          @songs << Song.new(
            :title => get_element_value(el,:title),
            :artist => get_element_value(el,:artist),
            :duration => get_element_value(el,:duration),
            :location => get_element_value(el,:location),
            :rating => get_element_value(el,:rating),
            :play_count => get_element_value(el,'play-count'),
            :last_played => get_element_value(el,'last-played'),
            :first_seen => get_element_value(el,'first-seen')
          )
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
      
      #######
      private
      #######
      
      def get_element_value(element,key)
        element.elements[key.to_s] ? element.elements[key.to_s].text : nil
      end
    end
  end
end