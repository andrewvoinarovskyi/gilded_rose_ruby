class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if item.name == 'Sulfuras, Hand of Ragnaros'

      item.sell_in -= 1

      adjust_quality(item)
    end
  end

  private

  MIN_QUALITY = 0
  MAX_QUALITY = 50
  QUALITY_IMPROVING_ITEMS = ['Aged Brie', 'Backstage passes to a TAFKAL80ETC concert']

  def adjust_quality(item)
    standard_change = base_quality_change(item.name)
    adjustment = determine_quality_adjustment(item, standard_change)
    apply_quality_change(item, adjustment)
  end

  def base_quality_change(name)
    return 1 if QUALITY_IMPROVING_ITEMS.include?(name)
    -1
  end

  def determine_quality_adjustment(item, standard_change)
    case item.name
    when 'Backstage passes to a TAFKAL80ETC concert'
      backstage_pass_adjustment(item, standard_change)
    when 'Conjured Mana Cake'
      conjured_item_adjustment(item, standard_change)
    else
      standard_adjustment(item, standard_change)
    end
  end

  def backstage_pass_adjustment(item, standard_change)
    return -item.quality if item.sell_in < 0

    adjustment = standard_change
    adjustment += 1 if item.sell_in < 11
    adjustment += 1 if item.sell_in < 6
    adjustment
  end

  def conjured_item_adjustment(item, standard_change)
    2*standard_adjustment(item, standard_change)
  end

  def standard_adjustment(item, standard_change)
    standard_change * (item.sell_in < 0 ? 2 : 1)
    end

  def apply_quality_change(item, change)
    item.quality = [[item.quality + change, MAX_QUALITY].min, MIN_QUALITY].max
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
