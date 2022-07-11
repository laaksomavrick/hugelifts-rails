# frozen_string_literal: true

module ApplicationHelper
  def layout_class
    'max-w-4xl mx-auto px-2 sm:px-6 lg:px-8'
  end

  def default_button_class(css_class_string = '')
    "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded cursor-pointer #{css_class_string}"
  end

  def create_button_class(css_class_string = '')
    "bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded cursor-pointer #{css_class_string}"
  end

  def delete_button_class(css_class_string = '')
    "bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded cursor-pointer #{css_class_string}"
  end

  def nav_link_to(text, path, opts = {})
    is_active = current_page?(path)
    opts[:class] ||= "#{is_active ? 'text-black-700' : 'text-gray-500'} px-3 py-2 rounded-md text-sm font-medium"
    link_to(text, path, opts)
  end
end
