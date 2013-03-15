module GridFu
  class Element
    include ActiveSupport::Configurable

    attr_accessor :renderer, :helper
    
    def initialize(*args, &definition)
      options = args.extract_options!
      if options.include? :renderer
        @renderer = options.delete :renderer
      end
      
      if options.include? :helper
        @helper = options.delete :helper
      end
      
      instance_exec(&definition) if block_given?
      config.merge!(options)
    end
  end
  
  def respond_to?(method)
    super || @helper.respond_to?(method)
  end
  
  def method_missing(method, *args, &block)
    if @helper.respond_to? method
      @helper.send method, *args, &block
    else
      super
    end
  end
end