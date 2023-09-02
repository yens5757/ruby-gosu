class Credit
    def initialize (window, text, x, y, color)
        @x = x
        @y = y
        @text = text
        @color = color
        @font = Gosu::Font.new(32)
    end
    def draw
        @font.draw(@text, @x, @y, 1, 1, 1, @color)
    end
end