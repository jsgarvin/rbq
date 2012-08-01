module RBQ
  class Song
    attr_accessor :element, :weight
    INTEGERIZE_FIELDS = ['duration', 'rating', 'play-count']
    TIMEIFY_FIELDS = ['last-played', 'first-seen']

    def initialize(element)
      @element = element
      ['title', 'artist', 'duration', 'location', 'rating', 'play-count', 'last-played', 'first-seen'].each do |field_name|
        @element.add_element REXML::Element.new(field_name).add_text('0') unless element.elements[field_name]
      end
    end

    def method_missing(method_name, *args)
      seeking_raw_element = false; doing_assignment = false
      if method_name.to_s.match(/(.+)_element$/)
        ivar = $1; seeking_raw_element = true
      elsif method_name.to_s.match(/(.+)=$/)
        ivar = $1; doing_assignment = true
      else
        ivar = method_name.to_s;
      end
      key = ivar.gsub(/\_/,'-')
      return element.elements[key.to_s] if seeking_raw_element
      return instance_variable_get("@#{ivar}") if instance_variable_defined?("@#{ivar}")
      if element.elements[key.to_s]
        if doing_assignment
          instance_variable_set("@#{ivar}", case
            when TIMEIFY_FIELDS.include?(key) then element.elements[key.to_s].text= args[0].to_i
            else element.elements[key.to_s].text= args[0]
          end)
        else
          instance_variable_set("@#{ivar}", case
            when INTEGERIZE_FIELDS.include?(key) then element.elements[key.to_s].text.to_i
            when TIMEIFY_FIELDS.include?(key) then Time.at(element.elements[key.to_s].text.to_i)
            else element.elements[key.to_s].text
          end)
        end
      else
        super
      end
    end

    def weight
      @weight ||= ((seconds_since_seen/(play_count+1)) * rating) + (play_count > 0 ? seconds_since_played : seconds_since_seen)
    end

    def seconds_since_seen
      (Time.now - first_seen).to_i
    end

    def seconds_since_played
      play_count > 0 ? (Time.now - last_played).to_i : 0
    end
  end
end