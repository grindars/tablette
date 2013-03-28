# Tablette

Inspired by discussion at: https://github.com/evilmartians/slashadmin/issues/3.
Rails table renderer that tries to be flexible.

## Installation

Add this line to your application's Gemfile:

    gem 'tablette'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tablette

## Usage

Somwhere in your app:

```ruby
short_table = Tablette::Table.new do
  column :id
  column :name
end

puts short_table.to_html(collection, User)
```

You will see following:

```html
# <table>
#   <thead><tr><th>Id</th><th>User name</th></tr></thead>
#   <tbody>
#     <tr><td>1</td><td>John Doe</td></tr>
#     <tr>...</tr>
#   </tbody>
# </table>
```

## Full definition

```ruby
table = Tablette::Table.new do
  html_options class: 'table'

  header do
    row do
      column 'Id', html_options: { colspan: 5 }
      column do
        'Doctor strangelove'
      end
    end
  end

  body do
    html_options class: 'sortable'
    row do
      html_options do |member, index|
        { data: { id: member.id, index: index } }
      end

      column html_options: ->(member, _) { { data: { value: member.id } } } do |_, index|
        index
      end
      column :id
      column :age do |member, _|
        "Dead at #{member.age}"
      end
      column do |_, index|
        sample_helper_function(index)
      end
    end

    row html_options: { class: 'small' } do
      tag 'overriden_tr'

      column :test do
        "test"
      end

      column :age, formatter: :sample_formatter
    end
  end

  footer do
    row do
      column html_options: { rowspan: 3 } do
        "On foot"
      end
    end
  end
end

puts table.to_html(collection)
```

Every element accepts:
* html_options - to customize default options.
* override_html_options - to completely override default html options.
* tag - to change tag name.

Default HTML options are:
* data-id - for tbody/tr.
* data-key - for tbody/tr/td.

Options which are set by blocks accepts:
* |member, index| - for row and column inside body element.
* |collection, klass = nil| - for table, header and footer (and all nested elements)
* Same for body.

Method called with :formatter option accepts value, member and index.

You can override default html options for an element with :override_html_options
option.

You can specify two or more rows in body section. All of this rows will be
rendered for every collection item.

## Global configuration

Table elements can be customized at application level.

Somewhere in initializer:

```ruby
Tablette::Table.config.html_options     = { class: 'table' }
Tablette::HeaderRow.config.html_options = proc { |_, resource_class = nil|
  { class: resource_class.name.underscore }
}
```

You can use: Table, Header, Body, Footer, HeaderRow, BodyRow, FooterRow,
HeaderColumn, BodyColumn, FooterColumn.

So, you can replace table with ordered list or something you need.

## Partial rendering

Could be useful for twitter-style pagination:

```ruby
table.element_to_html(:header, collection, User)
table.element_to_html(:body, collection, User)
table.element_to_html(:footer, collection, User)
```

## TODO

1. Think about sorting.
2. Formatted output.
3. Data attrs for everything.
4. Authospan.
5. :row as parameter.
6. Reusable columns
7. Shortened column definition
8. Tablette.render() do

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
