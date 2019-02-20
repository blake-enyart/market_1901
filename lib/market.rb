class Market

  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.select { |vendor| vendor.inventory.has_key?(item) }
  end

  def sorted_item_list
    items_list = @vendors.inject([]) do |array, vendor|
      array << vendor.inventory.keys
      array.flatten
    end
    items_list.uniq!.sort!
  end

  def total_inventory
    inventory_list = Hash.new(0)
    @vendors.each do |vendor|
      vendor.inventory.keys.each do |item|
        inventory_list[item] += vendor.inventory[item]
      end
    end
    inventory_list
  end

  def sell(item, amount)
    if total_inventory[item] < amount
      false
    elsif total_inventory[item] > amount
      vendors_that_sell(item).each do |vendor|
        if amount > vendor.inventory[item]
          amount -= vendor.inventory[item]
          vendor.inventory[item] -= vendor.inventory[item]
        else
          vendor.inventory[item] -= amount
        end
      end
      true
    end
  end
end
