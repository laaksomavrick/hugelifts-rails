# frozen_string_literal: true

module ApplicationHelper
  def layout_class
    'max-w-2xl mx-auto px-2 sm:px-6 lg:px-8 text-gray-600'
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

  def outline_button_class(css_class_string = '')
    "bg-white hover:bg-gray-100 border border-gray-300 font-bold py-2 px-4 rounded cursor-pointer #{css_class_string}"
  end

  def page_header_class(css_class_string = '')
    "flex items-center mb-4 #{css_class_string}"
  end

  def form_element_class(css_class_string = '')
    "mb-4 text-gray-700 #{css_class_string}"
  end

  def form_label_class(css_class_string = '')
    "block font-bold mb-2 #{css_class_string}"
  end

  def form_check_box_class(css_class_string = '')
    "appearance-none border rounded p-2 center #{css_class_string}"
  end

  def form_input_class(css_class_string = '')
    # rubocop:disable Layout/LineLength
    "appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline #{css_class_string}"
    # rubocop:enable Layout/LineLength
  end

  def href_class(css_class_string = '')
    "text-blue-400 cursor-pointer #{css_class_string}"
  end

  def nav_link_to(text, nav_link_path, opts = {})
    is_active = current_page?(nav_link_path) || request.path.starts_with?(nav_link_path)
    opts[:class] ||= "#{is_active ? 'text-blue-600' : ''} px-3 py-2 rounded-md text-md font-medium"
    link_to(text, nav_link_path, opts)
  end
end
