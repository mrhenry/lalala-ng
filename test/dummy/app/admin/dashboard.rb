ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span "Howdy, partner! You’ve reached your own personal LALALA dashboard, full of stats, data and extravaganza!"
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do

      column do

        render partial: "/admin/stats", :locals => { :matches => "test" }

      end

    end

    columns do

      column :span => 2 do
        panel "Recent Posts List" do
          ul do
            Article.all.map do |article|
              li link_to(article.title, edit_lalala_article_path(article))
            end
          end
        end
      end

      column :span => 2 do
        panel "Latest Posts Updated" do
          table_for Article.where('id > 0').order('updated_at DESC').limit(5) do
            column :title do |article|
                link_to(article.title, edit_lalala_article_path(article))
            end
            column :updated_at do |article|
                span article.updated_at, { :class => "timeago", :title => article.updated_at }
            end
          end
        end
      end

    end


    columns do
      column :span => 2 do
        panel "Recent Posts List" do
          ul do
            Article.all.map do |article|
              li link_to(article.title, edit_lalala_article_path(article))
            end
          end
        end
      end

    end


  end # content
end
