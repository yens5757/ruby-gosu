class Enemy
    SPEED = 5
    attr_reader :x, :y, :radius
    def initialize(window)
        @radius = 15
        @y_offset = 14.7
        @x_offset = 17
        @x = rand(window.width - 2 * @radius) + @radius
        @y = 0
        @image = Gosu::Image.new('png/enemyBlack5.png')
    end
    def move
        @y += SPEED
    end
    def draw
        @image.draw(@x - @x_offset, @y - @y_offset, 5, 0.35, 0.35)
    end
end