class Bullet
    attr_reader :x, :y
    def initialize (window, x, y, bulletsize)
        @x = x
        @y = y
        @image = Gosu::Image.new('png/laserGreen13.png')
        @window = window
        @bulletsize = bulletsize
        @x_offset = @bulletsize * 4.5
        @y_offset = @bulletsize * 18.5
    end
    def move
        @y -= 10
    end
    def draw
        @image.draw(@x - @x_offset, @y - @y_offset, 5, @bulletsize, @bulletsize)
    end
end