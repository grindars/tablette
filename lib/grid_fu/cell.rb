module GridFu
  class Cell < Element
    def initialize(tag, *args, &block)
      self.value = block
      self.key   = args.first if args.first.is_a?(String) or args.first.is_a?(Symbol)

      config.tag = tag

      super(*args, &nil) # Bypass block evaling: in this case it's a value formatter
    end

    attr_reader :key, :value

    protected
    def html_content(member, index)
      value = self.value.call(member, index) if self.value.present?
      value ||= member.send(key) if key.present? and member.respond_to?(key)
      value
    end

    attr_writer :value
    attr_writer :key
  end
end
