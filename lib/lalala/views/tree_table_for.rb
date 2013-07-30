module ActiveAdmin
  module Views
    class TreeTableFor < ActiveAdmin::Views::TableFor

      Column = ActiveAdmin::Views::TableFor::Column

      def column(*args, &block)
        options = default_options.merge(args.extract_options!)
        title = args[0]
        data  = args[1] || args[0]

        col = Column.new(title, data, @resource_class, options, &block)
        @columns << col

        # Build our header item
        within @header_row do
          build_table_header(col)
        end

        # Add a table cell for each item
        populate_columns(@tbody, @collection, col)
      end

    protected

      def populate_columns(tbody, collection, col)
        i = 0
        collection.each do |item|

          # find the <tr/>
          tr_elem = tbody.children[i]
          within tr_elem do
            build_table_cell(col, item)
            i += 1
          end

          unless item.children.blank?
            # find the tbody
            tr_elem    = tbody.children[i]
            td_elem    = tr_elem.children[0]
            table_elem = td_elem.children[0]
            tbody_elem = table_elem.children[0]

            populate_columns(tbody_elem, item.children, col)
            i += 1
          end
        end
      end

      def build_table_body
        @tbody = build_tbody(@collection)
      end

      def build_tbody(collection)
        tbody do
          # Build enough rows for our collection (and the sub trees)
          collection.each do |node|
            tr(:class => cycle('odd', 'even'), :id => dom_id(node), :'data-id' => node.id.to_s)
            build_subtree(node.children)
          end
        end
      end

      def build_subtree(collection)
        if collection.blank?
          return
        end

        tr do
          td(:class => "subtree", :colspan => "42") do
            table(:class => "subtree") do
              build_tbody(collection)
            end
          end
        end
      end

    end
  end
end
