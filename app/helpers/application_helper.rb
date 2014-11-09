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
      if category.id == category2.to_i
        link_to("#{category.name} (#{category.products.count})", products_path(params.merge({category: category.id})), class: 'active')
      else
        link_to("#{category.name} (#{category.products.count})", products_path(params.merge({category: category.id})))
      end
    end
  end
end
