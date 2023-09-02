class Explosion
    attr_reader :finished
    def initialize(window, x, y)
        @x = x
        @y = y
        @offset = 16
        @images = Gosu::Image.load_tiles('png/spritesheet.png', 32, 32)
        @image_index = 0
        @finished = false
    end
    def draw
        if @image_index < @images.count
            @images[@image_index].draw(@x - @offset, @y - @offset, 10)
            @image_index += 1
        else
            @finished = true
        end
    end
end
