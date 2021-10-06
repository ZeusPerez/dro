# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Property do
  context 'cast using the lambda definition' do
    it 'cast a string' do
      property = described_class.new('string_property', :string, 'default_string')
      expect(property.cast(123)).to eq('123')
    end

    it 'cast a bool' do
      property = described_class.new('bool_property', :bool, true)
      expect(property.cast('false')).to be_falsey
    end

    it 'cast an Array' do
      property = described_class.new('array_property', :array, [])
      expect(property.cast([1, 2, 3, 4])).to eq([1, 2, 3, 4])
    end

    it 'cast a Hash' do
      property = described_class.new('array_property', :hash, {})
      expect(property.cast(test: 'test_hash')).to eq(test: 'test_hash')
    end

    it 'cast a Proc' do
      type = proc { |value| "Hey! I am a #{value}" }
      property = described_class.new('proc_property', type, 'default_string')
      expect(property.cast('test proc')).to eq('Hey! I am a test proc')
    end
  end

  context 'cast using new method from the type' do
    it 'cast a type that respond to :new with one params' do
      type = Time
      property = described_class.new('money_property', type, Time.now)
      result = property.cast(2020)
      expect(result).to eq(Time.new(2020))
    end

    it 'cast a type that respond to :new with two params' do
      type = Time
      property = described_class.new('time_property', type, Time.now)
      result = property.cast([2020, 2])
      expect(result).to eq(Time.new(2020, 2))
    end
  end
end
