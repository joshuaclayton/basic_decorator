require 'spec_helper'
require 'money'

describe BasicDecorator::Decorator do
  before do
    class Coffee
      def cost
        Money.new(250, 'USD')
      end

      def origin
        'Columbia'
      end

      def additional_ingredients
        []
      end
    end

    class Cream < BasicDecorator::Decorator
      def cost
        @component.cost + Money.new(75, 'USD')
      end

      def additional_ingredients
        @component.additional_ingredients + ['Cream']
      end
    end

    class Sugar < BasicDecorator::Decorator
      def cost
        @component.cost + Money.new(25, 'USD')
      end

      def additional_ingredients
        @component.additional_ingredients + ['Sugar']
      end
    end
  end

  let(:coffee) { Coffee.new }

  shared_examples_for 'Coffee' do
    context 'maintaining the object' do
      it { should == coffee }
      it { should be_an_instance_of(Coffee) }

      its(:object_id) { should == coffee.object_id }
      its(:class) { should == coffee.class }
    end

    context 'maintaining interface' do
      it { should respond_to(:cost) }
      it { should respond_to(:origin) }
      it { should respond_to(:additional_ingredients) }
      it { expect { subject.method(:cost) }.to_not raise_error(NameError) }
      it { expect { subject.method(:origin) }.to_not raise_error(NameError) }
      it { expect { subject.method(:additional_ingredients) }.to_not raise_error(NameError) }
    end
  end

  describe 'Coffee' do
    subject { coffee }

    it_behaves_like 'Coffee'

    its(:cost) { should == 2.5 }
    its(:origin) { should == 'Columbia' }
    its(:additional_ingredients) { should be_empty }
  end

  describe 'Coffee with Sugar' do
    subject { Sugar.new(coffee) }

    it_behaves_like 'Coffee'

    its(:cost) { should == 2.75 }
    its(:origin) { should == 'Columbia' }
    its(:additional_ingredients) { should == ['Sugar'] }
  end

  describe 'Coffee with two Sugar' do
    subject { Sugar.new(Sugar.new(coffee)) }

    it_behaves_like 'Coffee'

    its(:cost) { should == 3.0 }
    its(:origin) { should == 'Columbia' }
    its(:additional_ingredients) { should == ['Sugar', 'Sugar'] }
  end

  describe 'Coffee with Cream and Sugar' do
    subject { Sugar.new(Cream.new(coffee)) }

    it_behaves_like 'Coffee'

    its(:cost) { should == 3.5 }
    its(:origin) { should == 'Columbia' }
    its(:additional_ingredients) { should == ['Cream', 'Sugar'] }
  end
end
