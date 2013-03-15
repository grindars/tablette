module GridFu
  module HTMLRenderer
    def self.produce_element(tag, attributes, content)
      content = content.join if content.kind_of? Array
  
      "<#{tag} #{_to_html_args(attributes)}>#{content}</#{tag}>"
    end

    # Translates html_options to HTML attributes string. Accepts nested
    # data-attributes.
    #
    # Example:
    #   _to_html_args(ref: true, data: { id: 1 }) # ref="true" data-id="1"
    def self._to_html_args(options, prepend = nil)
      options = options || {}
      html_args = options.map do |key, value|
        if value.is_a?(Hash)
          _to_html_args(value, key)
        else
          key = "#{prepend}-#{key}" if prepend.present?
          %{#{key}="#{value}"}
        end
      end

      html_args.join(' ')
    end
  end
end
