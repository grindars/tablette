module Tablette
  class HTMLRenderer
    def element=(element)
    
    end
  
    def produce_element(tag, attributes, content)
      content = content.join if content.kind_of? Array
  
      "<#{tag} #{to_html_args(attributes)}>#{content}</#{tag}>"
    end
  
    def to_html(root)
      if root.kind_of? Array
        root.join
      else
        root
      end
    end

    def wrap_content(proc)
      proc
    end

    private

    # Translates html_options to HTML attributes string. Accepts nested
    # data-attributes.
    #
    # Example:
    #   to_html_args(ref: true, data: { id: 1 }) # ref="true" data-id="1"
    def to_html_args(options, prepend = nil)
      options = options || {}
      html_args = options.map do |key, value|
        if value.is_a?(Hash)
          to_html_args(value, key)
        else
          key = "#{prepend}-#{key}" if prepend.present?
          %{#{key}="#{value}"}
        end
      end

      html_args.join(' ')
    end
  end
end
