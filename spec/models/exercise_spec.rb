# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exercise do
  it 'can create an exercise' do
    exercise = create(:exercise)
    expect(exercise.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:exercise, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  describe 'search' do
    it 'can search name by prefix match' do
      search_term = 'Foo'
      create(:exercise, name: 'Foo foo foo')
      create(:exercise, name: 'foo bar baz')
      create(:exercise, name: 'baz foo bar')

      found = described_class.all.prefix_search_by_name(search_term)

      expect(found.length).to eq 2
    end
  end
end
