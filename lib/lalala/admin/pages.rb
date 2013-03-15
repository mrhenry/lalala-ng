if defined?(ActiveAdmin)
  ActiveAdmin.register ApplicationPage, :as => 'Page' do

    config.filters = false

    index as: :tree_table, paginator: false, download_links: false do
      selectable_column
      id_column
      column :title

      actions defaults: false do |page|
        links = ''.html_safe

        if authorized?(ActiveAdmin::Auth::CREATE, page)
          classes = page.allowed_child_classes
          if classes.size > 0
            dropdown_menu "Add" do
              classes.each do |page_class|
                if page_class.allow_create
                  item page_class.to_s.humanize, new_resource_path(parent_id: page.to_param, page_type: page_class.to_s)
                end
              end
            end
          end
        end

        if authorized?(ActiveAdmin::Auth::UPDATE, page)
          links << link_to(I18n.t('active_admin.edit'), edit_resource_path(page), :class => "member_link edit_link")
        elsif authorized?(ActiveAdmin::Auth::READ, page)
          links << link_to(I18n.t('active_admin.view'), resource_path(page), :class => "member_link view_link")
        end

        if authorized?(ActiveAdmin::Auth::DESTROY, page) and page.allow_destroy
          links << link_to(I18n.t('active_admin.delete'), resource_path(page), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link")
        end

        links
      end

    end

    form do |f|
      h = "".html_safe
      h << f.input(:parent_id, as: :hidden, wrapper_html: { :style => "display:none;" })
      h << f.input(:page_type, as: :hidden, value: f.object.class.to_s, wrapper_html: { :style => "display:none;" })
      h << self.instance_exec(f, &f.object.form)
      h
    end

    controller do

      def new
        parent         = ApplicationPage.find(params[:parent_id])
        page_classname = params[:page_type]

        unless parent.allowed_children.include?(page_classname)
          raise "Invalid page"
        end

        page_class = page_classname.constantize
        @page = page_class.new(params[:page])
        @page.parent_id = parent.id

        new!
      end

      def create
        page_params    = params[:page]
        parent         = ApplicationPage.find(page_params.delete(:parent_id))
        page_classname = page_params.delete(:page_type)

        unless parent.allowed_children.include?(page_classname)
          raise "Invalid page"
        end

        page_class = page_classname.constantize
        @page = page_class.new(params[:page])

        r = create!

        parent.children << @page

        r
      end

    end

  end
end