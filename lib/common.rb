module RBQ
  class XmlFileNotFoundError < RuntimeError; end

  module SharedLibraryPlaylistMethods

    def backup_xml_file
      File.copy(expanded_path_to_file, expanded_path_to_file+".#{Time.now.to_i.to_s}.bkp")
    end

    def xml_file_exists?
      File.exists?(expanded_path_to_file)
    end

    def xml_doc
      raise XmlFileNotFoundError unless @xml_doc or xml_file_exists?
      @xml_doc ||= REXML::Document.new(File.new(expanded_path_to_file))
    end

    #######
    private
    #######

    def expanded_path_to_file
      @expanded_path_to_file ||= File.expand_path("#{path}/#{filename}")
    end

  end
end