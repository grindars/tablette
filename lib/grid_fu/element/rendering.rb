module GridFu
  class Element
    # Translates element to html tag.
    def to_html(*args)
      tag, override_html_options, user_html_options, builtin_html_options =
        get_options([:tag, :override_html_options, :html_options, :builtin_html_options], *args)

      raise "Set tag option for #{self.class.name}" if tag.blank?

      html_options = override_html_options.merge user_html_options

      builtin_html_options.each do |key, value|
        if html_options.include? key
          html_options[key] = "#{value} #{html_options[key]}"
        else
          html_options[key] = value
        end
      end
      
      @renderer.element = self
      begin
        @renderer.produce_element tag, html_options, html_content(*args)
      ensure
        @renderer.element = nil
      end
    end

    def element_to_html(element, *args)
      send(element).map do |item|
        item.to_html(*args)
      end
    end

    protected
    # HTML content for element. Renders elements set by :render_nested_elements
    # wrapped by :tag.
    def html_content(*args)
      nested = get_options(:render_nested_elements, *args).first

      if nested.blank?
        raise "Set render_nested_elements options or override #html_content/#to_html for #{self.class.name}"
      end

      nested.map { |e| element_to_html(e, *args) }.flatten!(1)
    end

    private

    # Gets given option values. If an option is a block - yields it and
    # returns value.
    def get_options(keys, *args)
      keys = Array.wrap(keys)
      keys.map do |name|
        config[name].is_a?(Proc) ? config[name].call(*args) : config[name]
      end
    end
  end
end
