module Tablette
  class ActionViewRenderer < HTMLRenderer
    def initialize(template)
      super()

      @template = template
    end

    def wrap_content(proc)
      ->(*args) do
        @template.capture(*args, &proc)
      end
    end

    def to_html(node)
      super(node).html_safe
    end
  end

  module ActionViewHelper
    def tablette_for(objects, options = {}, &block)
      default_options = {
        :renderer => ActionViewRenderer.new(self),
        :helper   => self
      }

      table = Tablette::Table.new(options.merge(default_options), &block)
      table.to_html(objects)
    end
  end
end

ActionView::Base.send :include, Tablette::ActionViewHelper
