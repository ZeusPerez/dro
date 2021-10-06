# frozen_string_literal: true

require 'spec_helper'
require 'money'

class MyDRO < DRO
  property :test_string, :string, default: 'default value'
  property :test_number, :integer
  property :test_number_default, :integer, default: 2
  property :test_bool, :bool
  property :test_bool_default, :bool, default: false
  property :test_money, Money
  property :test_array, :array
end

RSpec.describe DRO do
  subject do
    properties = { test_string: 'hola', test_number: 6, test_bool: true, test_money: [100, 'EUR'] }
    MyDRO.new(properties)
  end

  it 'parses the fields when loads the class' do
    expected_fields = %w(test_string
                         test_number
                         test_number_default
                         test_bool
                         test_bool_default
                         test_money
                         test_array)
    expect(MyDRO.properties.keys).to eq(expected_fields)
    expect(MyDRO.properties.values).to all(be_an(Property))
  end

  it 'defines accesing method for each field' do
    expect { subject.test_string }.not_to raise_error
    expect { subject.test_number }.not_to raise_error
    expect { subject.test_bool }.not_to raise_error
    expect { subject.test_money }.not_to raise_error
  end

  it 'assigns the default value' do
    payload = MyDRO.new
    expect(payload.test_string).to eq('default value')
    expect(payload.test_number).to eq(0)
    expect(payload.test_number_default).to eq(2)
    expect(payload.test_bool).to eq(false)
    expect(payload.test_bool_default).to eq(false)
  end

  it 'returns the payload as a hash' do
    expected_result = { 'test_string' => 'default value',
                        'test_number' => 0,
                        'test_number_default' => 2,
                        'test_bool' => false,
                        'test_bool_default' => false,
                        'test_money' => '0,00',
                        'test_array' => [] }

    I18n.config.available_locales = :en # For converting the money to string
    payload = MyDRO.new(test_money: Money.new(0, 'EUR'))
    expect(JSON[payload.to_json]).to eq(expected_result)
  end

  it 'creates an object form a hash' do
    input = { test_string: 'default value',
              test_number: 5,
              test_bool: true }

    result = MyDRO.create_from_hash(input)
    expect(result.test_string).to eq('default value')
    expect(result.test_number).to eq(5)
    expect(result.test_bool).to eq(true)
  end

  it 'creates an object form a json' do
    input = { test_string: 'default value',
              test_number: 5,
              test_bool: true }

    result = MyDRO.create_from_json(input.to_json)
    expect(result.test_string).to eq('default value')
    expect(result.test_number).to eq(5)
    expect(result.test_bool).to eq(true)
  end

  it 'creates an object form a struct' do
    input = { test_string: 'default value',
              test_number: 5,
              test_bool: true }

    struct = OpenStruct.new(input)
    result = MyDRO.create_from_object(struct)
    expect(result.test_string).to eq('default value')
    expect(result.test_number).to eq(5)
    expect(result.test_bool).to eq(true)
  end
end
