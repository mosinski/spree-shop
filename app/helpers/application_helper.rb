module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def current_category(category, category2)
    content_tag(:li) do
      if category[0] == category2.to_i
        link_to("#{category[1]} (#{category[2]})", products_path(params.merge({category: category[0]})), class: 'active')
      else
        link_to("#{category[1]} (#{category[2]})", products_path(params.merge({category: category[0]})))
      end
    end
  end

  def go_up(category=nil)
    if category
      if category.parent_id
        if category.parent_id > 1
          link_to products_path(params.merge({category: category.parent_id})) do
            '<i class="fa fa-level-up text-primary"></i>'.html_safe
          end
        else
          link_to products_path do
            '<i class="fa fa-level-up text-primary"></i>'.html_safe
          end
        end
      end
    end
  end
end
