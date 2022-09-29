# frozen_string_literal: true

class OrdinalService
  def self.add_to_collection(collection:, element:, element_ordinal:)
    sorted = collection.order(ordinal: :asc)
    inserted = sorted.insert(element_ordinal, element)
    inserted.map_with_index do |item, i|
      item.ordinal = i
    end
  end
end
