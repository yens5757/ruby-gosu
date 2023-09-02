class Player
    UPPADDING = 20
    DOWNPADDING = 60
    SIDEPADDING = 40
    attr_reader :x, :y, :radius
    def initialize(window)
        @x = 220
        @y = 650
        @forwardSpeed = 6
        @sideSpeed = 6
        @radius = 19
        @y_offset = 18.75
        @x_offset = 24.5
        @window = window
        @image = Gosu::Image.new('png/playerShip3_green.png')
    end
    def draw
        @image.draw(@x - @x_offset, @y - @y_offset, 5, 0.5, 0.5)
    end
    def moveUp
        if @y < 0 + UPPADDING
            @y = 0 + UPPADDING
        end
        @y -= @forwardSpeed
    end
    def moveDown
        if @y > @window.height - DOWNPADDING
            @y = @window.height - DOWNPADDING
        end
        @y += @forwardSpeed
    end
    def moveLeft
        if @x < 0 + SIDEPADDING
            @x = 0 + SIDEPADDING
        end
        @x -= @sideSpeed
    end
    def moveRight
        if @x > @window.width - SIDEPADDING
            @x = @window.width - SIDEPADDING
        end
        @x += @sideSpeed
    end
end