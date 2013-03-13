module GridFu
  class Column < Element
    def initialize(*args, &block)
      self.value = block
      self.key   = args.first if args.first.is_a?(String) or args.first.is_a?(Symbol)

      # Bypass block evaling: in this case it's not a config but a value formatter
      super(*args, &nil)
    end

    def colspan(args)
      override_html_options, html_options =
        get_options([:override_html_options, :html_options], *args)

      options = override_html_options.merge html_options
      options[:colspan]
    end

    protected
    attr_accessor :key, :value
  end

  class BodyColumn < Column
    config.tag = 'td'

    protected
    def html_content(member, index)
      value = self.value.call(member, index) if self.value.present?
      value ||= member.send(key) if key.present? and member.respond_to?(key)

      if config.formatter.present?
        value ||= send(config.formatter, key, member, index)
      end

      value
    end
  end

  class HeaderColumn < Column
    config.tag = 'th'

    protected
    def html_content(collection, resource_class = nil)
      return value.call(collection, resource_class) if value.is_a?(Proc)
      if resource_class.respond_to?(:human_attribute_name) && key.present?
        resource_class.human_attribute_name(key)
      else
        key
      end
    end
  end

  class FooterColumn < Column
    config.tag = 'td'

    protected
    def html_content(*args)
      return value.call(*args) if value.is_a?(Proc)
      key
    end
  end
end
