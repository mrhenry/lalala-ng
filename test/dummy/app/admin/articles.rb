ActiveAdmin.register Article do

  scope :all, :default => true
  scope :catA
  scope :catB
  scope :catC

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :tags
      f.input :category, as: :select, collection: %w(A B C)
      f.input :images, as: :haraway do |h|
        h.inputs do
          h.input :title, as: :string
          h.input :choice, as: :select, collection: %w(A B C)
          h.input :check_it, as: :boolean
        end
      end
    end

    f.actions
  end


  sidebar "Related tags", :only => [:show] do

    div :class => "lalala sidebar message", :id => "lalala_sidebar_message" do
      "This is an intro block.... It is yours. It is the best <strong>intro block</strong> in the world. Click the link for a tag detail.".html_safe
    end

    div :class => "lalala sidebar message with-closing-line" do
      "This is an intro block with a closing line.... It is yours. It is the best <strong>intro block</strong> in the world. Click the <a href='#'>link</a> for a tag detail.".html_safe
    end

    div :class => "lalala sidebar listing div" do

      div :class => "item" do
        span link_to("tag.title", "#")
        div "2 days ago", { :class => "timeago", :title => "2 days ago" }
      end

      div :class => "item" do
        div link_to("hoe laat zou het zijn", "#")
        div "2 days ago", { :class => "timeago", :title => "2 days ago" }
      end

      div :class => "item" do
        div link_to("maakt da nu eens mee seg, een te lange titel", "#")
        div "2 days ago", { :class => "timeago", :title => "2 days ago" }
      end

    end

  end

  sidebar "User Information", :only => [:show] do
    div :class => "lalala sidebar person" do

      gravatar_id  = Digest::MD5.hexdigest("hanefaeffes@mrhenry.be")
      default_url  = "http://gravatar.com/avatar/#{gravatar_id}.png?s=100"

      img(:src => default_url, :class => "avatar")

      h4 :class => "title" do
        "Hans Spooren"
      end

      div :class => "details" do
        "sex: m<br />e-mail: hans@mrhenry.be<br />address: kronenburgstraat 14, 2000 Antwerp".html_safe
      end

      div :class => "cta" do
        link_to("view detailed info", "#")
      end

    end
  end

  sidebar "Help", :only => [:show] do
    div :class => "lalala sidebar message", :id => "lalala_sidebar_message" do
      "Test".html_safe
    end

    ul :class => "lalala sidebar listing ul" do

      li :class => "item" do
        span link_to("tag.title", "#")
        div "2 days ago", { :class => "timeago", :title => "2 days ago" }
      end

      li :class => "item" do
        span link_to("tag.title", "#")
        div "2 days ago", { :class => "timeago", :title => "2 days ago" }
      end

    end

  end

end
