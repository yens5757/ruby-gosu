require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'movingBackground'
require_relative 'credit'
require_relative 'ability'
require_relative 'ChargeBar'
require_relative 'ShopBar'

class LaserDefender < Gosu::Window
    def initialize
        super 480, 854
        self.caption = 'Laser Defender'
        @background_image = Gosu::Image.new('png/menubackground.png')
        @background_music = Gosu::Song.new('sound/title.wav')
        @background_music.volume = 0.1
        @background_music.play(true)

        @abilityradius = 3
        @chargebar_time = 2
        @enemies_destroyed = 0
        @bulletsize = 0.7
        @shootspeed = 250
        @max_enemies = 30
        @enemies_frequency = 0.05

        @bulletsize_bar_count = 0
        @shootspeed_bar_count = 0
        @chargebar_bar_count = 0
        @abilityradius_bar_count = 0

        @scene = :start
    end

    def draw
        case @scene
        when :start
            draw_start
        when :game
            draw_game
        when :shop
            draw_shop
        when :end
            draw_end
        end
    end

    def update
        case @scene
        when :game
            update_game
        end
    end

    def button_down(id)
        case @scene
        when :start
            button_down_start(id)
        when :game
            button_down_game(id)
        when :shop
            button_down_shop(id)
        when :end
            button_down_end(id)
        end
    end

    def draw_start
        @background_image.draw(0,0,0)
    end

    def button_down_start(id)
        if id == Gosu::MsLeft
            if ((mouse_x > 160 and mouse_x < 320) and (mouse_y > 530 and mouse_y < 554))
                initialize_game
            end
            if ((mouse_x > 205 and mouse_x < 272) and (mouse_y > 598 and mouse_y < 622))
                close
            end
        end
    end



    def initialize_game
        @moving_background = MovingBackground.new
        @background_music = Gosu::Song.new('sound/level1.wav')
        @background_music.volume = 0.1
        @background_music.play(true)
        @laser_sound = Gosu::Sample.new('sound/laserSmall_001.ogg')
        @explosion_sound = Gosu::Sample.new('sound/explosionCrunch_004.ogg')
        @ability_sound = Gosu::Sample.new('sound/ability.wav')

        @charge_bar = ChargeBar.new(200, @chargebar_time)

        @player = Player.new(self)
        @enemies = []
        @bullets = []
        @explosions = []
        @abilities = []
        @scene = :game
        @enemies_appeared = 0
        @last_shot_time = Gosu.milliseconds
    end  

    def draw_game
        @moving_background.draw
        @credit = Credit.new(self, @enemies_destroyed.to_s, 0, 0, 0xff_d155d7)
        @credit.draw
        @player.draw
        @charge_bar.draw(self, 140, 754, 200, 20, Gosu::Color::GRAY, Gosu::Color::RED)

        @enemies.each do |enemy|
            enemy.draw
        end
        @bullets.each do |bullet|
             bullet.draw
        end
        @explosions.each do |explosion|
            explosion.draw
        end
        @abilities.each do |ability|
            ability.draw
        end
        puts @count
    end

    def update_game
        @moving_background.moving

        if button_down?(Gosu::KbJ)
            @charge_bar.charging
            if @charge_bar.checkCharge >= 198
                @charge_bar.reset
                @abilities.push Ability.new(self, @player.x, @player.y, @abilityradius)
                @ability_sound.play
                @enemies.dup.each do |enemy|
                    distance = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
                    if distance < @abilityradius * 40
                        @enemies.delete enemy
                        @explosions.push Explosion.new(self, enemy.x, enemy.y)
                        @enemies_destroyed += 1
                    end
                end
            end
        else
            @charge_bar.decaying
        end

        @player.moveUp if button_down?(Gosu::KbW)
        @player.moveDown if button_down?(Gosu::KbS)
        @player.moveLeft if button_down?(Gosu::KbA)
        @player.moveRight if button_down?(Gosu::KbD)
        
        if button_down?(Gosu::KbSpace)
            @current_time = Gosu.milliseconds
            if @current_time - @last_shot_time > @shootspeed
                @bullets.push Bullet.new(self, @player.x, @player.y, @bulletsize)
                @laser_sound.play
                @last_shot_time = @current_time
            end
        end

        if rand < @enemies_frequency
            @enemies.push Enemy.new(self)
            @enemies_appeared += 1
        end
        @enemies.each do |enemy|
            enemy.move
        end
        @bullets.each do |bullet|
            bullet.move
        end
        @enemies.dup.each do |enemy|
            @bullets.dup.each do |bullet|
                distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
                if distance < enemy.radius
                    @enemies.delete enemy
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @explosion_sound.play
                    @enemies_destroyed += 1
                end
                if bullet.y < -20
                    @bullets.delete bullet
                end
            end
            if enemy.y > 900
                @enemies.delete enemy
            end 
        end

        @explosions.dup.each do |explosion|
            if explosion.finished
                @explosions.delete explosion
            end
        end

        @abilities.dup.each do |ability|
            if ability.finished
                @abilities.delete ability
            end
        end
        
        if @enemies_appeared > @max_enemies
            initialize_shop
        end
        @enemies.each do |enemy|
            distance = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
            if distance <  @player.radius + enemy.radius
                initialize_end
            end
        end
    end


    
    def button_down_game(id)

    end

    def initialize_shop
        @background_image = Gosu::Image.new('png/shop.png')
        @scene = :shop
        @max_enemies = @max_enemies * 1.4
        @enemies_frequency = @enemies_frequency * 1.25
        @background_music = Gosu::Song.new('sound/level2.wav')
        @background_music.volume = 0.1
        @background_music.play(true)
        @bulletsize_bar = ShopBar.new(self, 10, @bulletsize_bar_count)
        @shootspeed_bar = ShopBar.new(self, 10, @shootspeed_bar_count)
        @chargebar_bar = ShopBar.new(self, 10, @chargebar_bar_count)
        @abilityradius_bar = ShopBar.new(self, 10, @abilityradius_bar_count)
        @buy_times = 3
    end

    def draw_shop
        @background_image.draw(0,0,0)
        @bulletsize_bar.draw(150, 160)
        @shootspeed_bar.draw(150, 265)
        @chargebar_bar.draw(150, 365)
        @abilityradius_bar.draw(150, 470)
    end

    def button_down_shop(id)
        if id == Gosu::MsLeft
            if ((mouse_x > 100 and mouse_x < 370) and (mouse_y > 756 and mouse_y < 780))
                initialize_game
            end
            if @buy_times > 0
                if ((mouse_x > 385 and mouse_x < 475) and (mouse_y > 160 and mouse_y < 185))
                    if @bulletsize_bar_count < 10
                        @bulletsize_bar_count += 1
                        @bulletsize += 0.15
                        @bulletsize_bar.increase_charge
                        @buy_times -= 1
                    end
                end
                if ((mouse_x > 385 and mouse_x < 475) and (mouse_y > 260 and mouse_y < 285))
                    if @shootspeed_bar_count < 10
                        @shootspeed_bar_count += 1
                        @shootspeed -= 15
                        @shootspeed_bar.increase_charge
                        @buy_times -= 1
                    end
                end
                if ((mouse_x > 385 and mouse_x < 475) and (mouse_y > 365 and mouse_y < 390))
                    if @chargebar_bar_count < 10
                        @chargebar_bar_count += 1
                        @chargebar_time += 0.1
                        @chargebar_bar.increase_charge
                        @buy_times -= 1
                    end
                end
                if ((mouse_x > 385 and mouse_x < 475) and (mouse_y > 465 and mouse_y < 490))
                    if @abilityradius_bar_count < 10
                        @abilityradius_bar_count += 1
                        @abilityradius += 0.15
                        @abilityradius_bar.increase_charge
                        @buy_times -= 1
                    end
                end
            end
        end
    end

    def initialize_end
        @points = @enemies_destroyed

        @abilityradius = 3
        @chargebar_time = 2
        @enemies_destroyed = 0
        @bulletsize = 0.7
        @shootspeed = 250
        @max_enemies = 20
        @enemies_frequency = 0.05

        @bulletsize_bar_count = 0
        @shootspeed_bar_count = 0
        @chargebar_bar_count = 0
        @abilityradius_bar_count = 0



        @background_image = Gosu::Image.new('png/gameover.png')
        @background_music = Gosu::Song.new('sound/end.wav')
        @background_music.volume = 0.1
        @background_music.play(true)
        @credit = Credit.new(self, @points.to_s, 225, 427, 0xff_d155d7)
        @scene = :end
    end

    def draw_end
        @background_image.draw(0,0,0)
        @credit.draw
    end

    def button_down_end(id)
        if id == Gosu::MsLeft
            if ((mouse_x > 133 and mouse_x < 336) and (mouse_y > 543 and mouse_y < 562))
                initialize_game
            end
            if ((mouse_x > 146 and mouse_x < 320) and (mouse_y > 603 and mouse_y < 628))
                initialize
            end
        end
    end
end




window = LaserDefender.new
window.show