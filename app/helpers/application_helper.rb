# frozen_string_literal: true

module ApplicationHelper
  def nav_link_class
    'text-black-500 px-3 py-2 rounded-md text-sm font-medium'
  end

  def nav_link_to(text, path, opts = {})
    is_active = current_page?(path)
    opts[:class] ||= "#{is_active ? 'text-black-700' : 'text-gray-500'} px-3 py-2 rounded-md text-sm font-medium"
    link_to(text, path, opts)
  end
end
