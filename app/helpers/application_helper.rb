# frozen_string_literal: true

module ApplicationHelper

  def layout_class
    "max-w-4xl mx-auto px-2 sm:px-6 lg:px-8"
  end

  def nav_link_to(text, path, opts = {})
    is_active = current_page?(path)
    opts[:class] ||= "#{is_active ? 'text-black-700' : 'text-gray-500'} px-3 py-2 rounded-md text-sm font-medium"
    link_to(text, path, opts)
  end
end
