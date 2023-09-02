class ChargeBar
    def initialize(max_fill_level, fill_speed)
      @max_fill_level = max_fill_level
      @fill_speed = fill_speed
      @fill_level = 0
    end
  
    def decaying
        @fill_level -= @fill_speed
        @fill_level = [0, @fill_level].max
    end
    def charging
        @fill_level += @fill_speed
        @fill_level = [@fill_level, @max_fill_level].min
    end
    def reset
        @fill_level = 0
    end
    def checkCharge
        return @fill_level
    end
    def draw(window, x, y, width, height, background_color, fill_color)
      fill_width = (width * @fill_level / @max_fill_level).to_i
      window.draw_quad(x, y, background_color, x + width, y, background_color, x, y + height, background_color, x + width, y + height, background_color, 0)
      window.draw_quad(x, y, fill_color, x + fill_width, y, fill_color, x, y + height, fill_color, x + fill_width, y + height, fill_color, 0)
    end
end