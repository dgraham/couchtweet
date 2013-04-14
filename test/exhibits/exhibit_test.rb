require 'minitest_helper'

describe Exhibit do
  let(:model)   { 42 }
  let(:view)    { Object.new }
  let(:exhibit) { Exhibit.new(model, view) }

  describe '.decorate' do
    it 'decorates a single object' do
      Exhibit.decorate(model, view).tap do |wrapped|
        wrapped.size.must_equal 1
        wrapped.first.is_a?(Exhibit).must_equal true
      end
    end

    it 'decorates several objects' do
      Exhibit.decorate(model, 12, view).tap do |wrapped|
        wrapped.size.must_equal 2
        wrapped.first.is_a?(Exhibit).must_equal true
      end
    end

    it 'ignores nil elements' do
      Exhibit.decorate([nil, model, 12], view).tap do |wrapped|
        wrapped.size.must_equal 2
        wrapped.first.is_a?(Exhibit).must_equal true
      end
    end
  end

  describe 'initialize' do
    it 'knows the model and view' do
      exhibit.model.must_equal model
      exhibit.view.must_equal view
    end

    it 'delegates methods to model' do
      exhibit.to_s.must_equal '42'
      exhibit.to_i.must_equal 42
    end
  end

  describe '#to_model' do
    it 'returns the decorated model object' do
      exhibit.to_model.class.must_equal Fixnum
      exhibit.to_model.must_equal 42
    end
  end
end

