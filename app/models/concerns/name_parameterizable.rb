# frozen_string_literal: true

module NameParameterizable
  def to_param
    [id, name.parameterize].join('-')
  end
end
