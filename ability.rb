class Ability
    attr_reader :finished
    def initialize(window, x, y, radius)
        @x = x
        @y = y
        @offset = radius * 50
        @explosion_radius = radius
        @images = Gosu::Image.load_tiles('png/ability.png', 100, 100)
        @image_index = 0
        @finished = false
    end
    def draw
        if @image_index < @images.count
            @images[@image_index].draw(@x - @offset, @y - @offset, 10, @explosion_radius, @explosion_radius)
            @image_index += 1
        else
            @finished = true
        end
    end
end
