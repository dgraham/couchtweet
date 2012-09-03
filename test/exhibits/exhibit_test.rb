require 'minitest_helper'

describe Exhibit do
  let(:model)   { 42 }
  let(:view)    { Object.new }
  let(:exhibit) { Exhibit.new(model, view) }

  describe '.wrap' do
    it 'wraps a single object' do
      Exhibit.wrap(model, view).tap do |wrapped|
        wrapped.size.must_equal 1
        wrapped.first.is_a?(Exhibit).must_equal true
      end
    end

    it 'wraps several objects' do
      Exhibit.wrap(model, 12, view).tap do |wrapped|
        wrapped.size.must_equal 2
        wrapped.first.is_a?(Exhibit).must_equal true
      end
    end

    it 'ignores nil elements' do
      Exhibit.wrap([nil, model, 12], view).tap do |wrapped|
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

  describe '#class' do
    it 'pretends to be another class' do
      exhibit.class.must_equal Fixnum
    end
  end
end

