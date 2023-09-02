class ShopBar
    BLOCK_WIDTH = 20
    HEIGHT = 20
  
    def initialize(window, max_charge, charge)
      @window = window
      @max_charge = max_charge
      @charge = charge
    end

    def increase_charge
      @charge = [@charge + 1, @max_charge].min
    end
  
    def draw (x,y)
      @max_charge.times do |i|
        color = (i < @charge) ? Gosu::Color::GREEN : Gosu::Color::GRAY
        @window.draw_rect(x + (i * BLOCK_WIDTH), y, BLOCK_WIDTH - 1, HEIGHT - 1, color)
      end
    end
end