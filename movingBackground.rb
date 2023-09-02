class MovingBackground
    def initialize()
        @background1 = Gosu::Image.new('png/stars_0.png')
        @background1_2 = Gosu::Image.new('png/stars_0.png')
        @background2 = Gosu::Image.new('png/stars_1.png')
        @background2_2 = Gosu::Image.new('png/stars_1.png')
        @vel1 = 2
        @vel2 = 4
        @y1 = -846
        @y2 = -2546
        @y3 = -846
        @y4 = -2546
    end

    def draw
        @background1.draw(0, @y1, 0)
        @background1_2.draw(0,@y2,0)
        @background2.draw(0,@y3,1)
        @background2_2.draw(0,@y4,1)
    end

    def moving
        @y1 += @vel1
        @y2 += @vel1
        @y3 += @vel2
        @y4 += @vel2
        if @y1 >= 854
            @y1 = -2546
        end
        if @y2 >= 854
            @y2 = -2546
        end
        if @y3 >= 854
            @y3 = -2546
        end
        if @y4 >= 854
            @y4 = -2546
        end
    end
end