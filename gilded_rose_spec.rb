require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  def create_item(name, sell_in, quality)
    Item.new(name, sell_in, quality)
  end

  before(:each) do
    @items = [create_item(name, sell_in, quality)]
    GildedRose.new(@items).update_quality
  end

  shared_examples 'a normal item' do |expected_quality_change|
    it 'does not change the name' do
      expect(@items[0].name).to eq name
    end

    it 'decreases sell_in by 1' do
      expect(@items[0].sell_in).to eq sell_in - 1
    end

    it "changes quality by #{expected_quality_change}" do
      expect(@items[0].quality).to eq [quality + expected_quality_change, 50].min
    end
  end

  shared_examples 'a backstage pass' do |expected_quality|
    it 'does not change the name' do
      expect(@items[0].name).to eq name
    end

    it 'decreases sell_in by 1' do
      expect(@items[0].sell_in).to eq sell_in - 1
    end

    it "sets quality to #{expected_quality}" do
      expect(@items[0].quality).to eq expected_quality
    end
  end

  context 'Normal Items' do
    let(:name) { 'foo' }

    context 'not overdue' do
      let(:sell_in) { 5 }
      let(:quality) { 10 }
      include_examples 'a normal item', -1
    end

    context 'overdue' do
      let(:sell_in) { 0 }
      let(:quality) { 10 }
      include_examples 'a normal item', -2
    end

    context 'with zero quality' do
      let(:sell_in) { 5 }
      let(:quality) { 0 }
      include_examples 'a normal item', 0
    end
  end

  context 'Conjured Items' do
    let(:name) { 'Conjured Mana Cake' }

    context 'not overdue' do
      let(:sell_in) { 5 }
      let(:quality) { 10 }
      include_examples 'a normal item', -2
    end

    context 'overdue' do
      let(:sell_in) { 0 }
      let(:quality) { 10 }
      include_examples 'a normal item', -4
    end
  end

  context 'Aged Brie' do
    let(:name) { 'Aged Brie' }

    context 'before sell_in period' do
      let(:sell_in) { 5 }
      let(:quality) { 10 }
      include_examples 'a normal item', 1
    end

    context 'after sell_in period' do
      let(:sell_in) { 0 }
      let(:quality) { 10 }
      include_examples 'a normal item', 2
    end

    context 'with high quality' do
      let(:sell_in) { 5 }
      let(:quality) { 50 }
      include_examples 'a normal item', 0
    end
  end

  context 'Backstage passes to a TAFKAL80ETC concert' do
    let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

    context 'more than 10 days before concert' do
      let(:sell_in) { 15 }
      let(:quality) { 10 }
      include_examples 'a normal item', 1
    end

    context '6 to 10 days before concert' do
      let(:sell_in) { 10 }
      let(:quality) { 10 }
      include_examples 'a normal item', 2
    end

    context '1 to 5 days before concert' do
      let(:sell_in) { 5 }
      let(:quality) { 10 }
      include_examples 'a normal item', 3
    end

    context 'after concert' do
      let(:sell_in) { 0 }
      let(:quality) { 10 }
      include_examples 'a backstage pass', 0
    end
  end

  context 'Sulfuras, Hand of Ragnaros' do
    let(:name) { 'Sulfuras, Hand of Ragnaros' }
    let(:sell_in) { 5 }
    let(:quality) { 80 }

    it 'does not change the name' do
      expect(@items[0].name).to eq name
    end

    it 'does not change the sell_in' do
      expect(@items[0].sell_in).to eq sell_in
    end

    it 'does not change the quality' do
      expect(@items[0].quality).to eq quality
    end
  end
end
