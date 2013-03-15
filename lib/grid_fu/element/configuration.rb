module GridFu
  class Element
    protected

    config.allowed_configuration_options = %w(
      tag html_options override_html_options
    )
    config.html_options                  = {}
    config.builtin_html_options          = {}
    config.override_html_options         = {}
    config.render_nested_elements        = []
    config.tag                           = nil
  end
end