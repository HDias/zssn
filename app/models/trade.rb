# frozen_string_literal: true

class Trade
  attr_reader :barterer, :counterpart, :errors

  def initialize(barterer:, counterpart:)
    @barterer = barterer
    @counterpart = counterpart
    @errors = []
  end

  def valid?
    @errors.clear
    validate_different_survivors
    validate_survivors_not_infected
    @errors.empty?
  end

  def exchange_items(barterer_items, counterpart_items)
    @barterer_items = barterer_items.to_h
    @counterpart_items = counterpart_items.to_h

    return false unless valid? && validate_point_exchange

    begin
      return false unless transfer_items(barterer, counterpart, @barterer_items)
      return false unless transfer_items(counterpart, barterer, @counterpart_items)
      true
    rescue StandardError
      false
    end
  end

  private

  def validate_different_survivors
    if barterer.id == counterpart.id
      @errors << "A survivor cannot trade with themselves"
    end
  end

  def validate_survivors_not_infected
    if barterer.infected? || counterpart.infected?
      @errors << "Infected survivors cannot trade"
    end
  end

  def validate_point_exchange
    return true if @barterer_items.nil? || @counterpart_items.nil?

    barterer_points = calculate_points(@barterer_items)
    counterpart_points = calculate_points(@counterpart_items)

    if barterer_points != counterpart_points
      @errors << "Point values must be equal for both sides of the trade"
      return false
    end
    true
  end

  def calculate_points(items)
    items.sum { |item_id, quantity| Item.find(item_id).point_value * quantity.to_i }
  end

  def transfer_items(from_survivor, to_survivor, items)
    items.each do |item_id, quantity|
      item = Item.find(item_id)
      quantity.to_i.times do
        unless from_survivor.inventory.remove_item(item)
          @errors << "#{from_survivor.name} doesn't have enough #{item.name}"
          return false
        end
        unless to_survivor.inventory.add_item(item)
          @errors << "#{to_survivor.name} cannot receive more #{item.name}"
          return false
        end
      end
    end
    true
  end
end
