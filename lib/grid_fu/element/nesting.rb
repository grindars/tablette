module GridFu
  class Element
    class << self
      protected
      # Defines DSL method for configuring nested element.
      # If no args/block passed - returns currently defined elements as array.
      #
      # Example:
      #   class Table < Element
      #     nest :body, Body
      #   end
      #
      #   table = Table.new do
      #     body do
      #       (...)
      #     end
      #   end
      #
      #   table.body.first.to_html # <tbody>...</tbody>
      def nest(accessor_name, klass, opts = {})
        ivar_name = opts[:ivar_name] || accessor_name
        merge_children = opts[:merge_children] || false

        define_method accessor_name do |*args, &block|
          items = instance_variable_get("@#{ivar_name}") || []
          return items if args.blank? && block.blank?

          value = klass.new(*args, &block)
          if merge_children && items.any?
            items.first.merge_with! value
          else
            items.push(value)
          end
          instance_variable_set("@#{ivar_name}", items)
          value
        end
        protected accessor_name
      end

      # Defines top-level shortcut DSL method.
      #
      # Example:
      #   class Body < Element
      #     nest :row, BodyRow
      #   end
      #
      #   class Table < Element
      #     nest_through :body, :row, :column # Table#column calls .body.row.column
      #   end
      #
      #   table = Table.new do
      #     column :id
      #   end
      #
      #   table.body.first.row.first.column.first.to_html # <td data-name="id">...</td>
      def nest_through(*chain)
        nested_method = chain.last

        define_method nested_method do |*args, &block|
          _get_chained(self, chain.dup, *args, &block)
        end
      end
    end

    private
    def _get_chained(context, chain, *args, &block)
      key = chain.shift
      if chain.empty?
        context.send(key, *args, &block)
      else
        # Get last defined element, or define new blank
        nested_item = context.send(key).last || context.send(key) { }
        _get_chained(nested_item, chain, *args, &block)
      end
    end
  end
end