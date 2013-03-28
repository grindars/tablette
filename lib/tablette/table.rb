module Tablette
  class Table < Element
    config.tag = 'table'
    config.render_nested_elements = %w(header! body footer!)
    config.allowed_configuration_options = %w(tag html_options)
    config.builtin_html_options = { :class => "tablette" }
    
    nest :header!, Header, :ivar_name => :header, :merge_children => true
    nest :body, Body
    nest :footer!, Footer, :ivar_name => :footer, :merge_children => true

    nest_through :body, :row, :column
    
    def initialize(*args, &block)
      @renderer = HTMLRenderer
      @helper = nil
      
      super
    end

    def header(&block)
      header! do
        column(html_options: { colspan: 'auto'}, &block)
      end
    end

    def footer(&block)
      footer! do
        column(html_options: { colspan: 'auto'}, &block)
      end
    end

    def to_html(*args)
      columns = 0

      all_sections = [ self.header!, self.body, self.footer! ].flatten
      all_sections.each do |section|
        section_columns = section.columns_for_section args
        columns = section_columns if section_columns > columns
      end

      all_sections.each do |section|
        section.update_auto_colspan! columns, args
      end

      @renderer.to_html(super)
    end
  end
end
