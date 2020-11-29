$is_it = true
module Logic
  def self.change_params(reg, type_item)
    pname = reg.cookies['name']
    Rack::Response.new do |response|

      case reg.cookies["time"]
      when '3'
        day_period = "morning"
      when '1'
        day_period = "noonday"
      when '2'
        day_period = "night"
      end
      response.set_cookie('day_period', day_period)
      response.set_cookie("time", reg.cookies["time"].to_i + 1) if reg.cookies["time"].to_i < 3
      case type_item
      when 'hp'
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i + 1)
        response.set_cookie("stomach", reg.cookies["stomach"].to_i + 1) if reg.cookies["stomach"].to_i < 5
        response.set_cookie("hp", reg.cookies["hp"].to_i + rand(0..1)) if reg.cookies["hp"].to_i < 6
        response.set_cookie("notification_action",
                            "You feed #{pname}")
        
      when 'interest'
        response.set_cookie('interest', reg.cookies['interest'].to_i + 1) if reg.cookies['interest'].to_i < 6
        response.set_cookie("stomach", reg.cookies["stomach"].to_i - 1) if reg.cookies["stomach"].to_i > 0
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i + 1)
        response.set_cookie("notification_action",
                            "You play with #{pname}")
        
      when 'cleaning'
        response.set_cookie("purity", 4)
        response.set_cookie("interest", reg.cookies["interest"].to_i - 1) if reg.cookies["interest"].to_i > 0
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i + 1)
        response.set_cookie("notification_action",
                            "You wash #{pname}")
        
      when 'looking'
        response.set_cookie("hp", reg.cookies["hp"].to_i - 1) if reg.cookies["hp"].to_i > 0
        response.set_cookie("stomach", reg.cookies["stomach"].to_i - 1) if reg.cookies["stomach"].to_i > 0
        response.set_cookie("intelect", reg.cookies["intelect"].to_i - 1) if reg.cookies["intelect"].to_i > 0
        response.set_cookie("interest", reg.cookies["interest"].to_i - 1) if reg.cookies["interest"].to_i > 0
        response.set_cookie("purity", reg.cookies["purity"].to_i - 1) if reg.cookies["purity"].to_i > 0
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i + 1)
        response.set_cookie("notification_action",
                            "You just looking of #{pname}")
        
      when 'walk'
        $walk_result = "away" if reg.cookies["interest"].to_i <= 3 && rand(1..10) == 3
        $walk_result = "lost" if reg.cookies["intelect"].to_i <= 2 && rand(1..10) == 4
        response.set_cookie("interest", reg.cookies["interest"].to_i + 1)
        response.set_cookie("stomach", reg.cookies["stomach"].to_i - 1) if reg.cookies["stomach"].to_i > 0
        response.set_cookie("purity", reg.cookies["purity"].to_i - 1) if reg.cookies["purity"].to_i > 0
        response.set_cookie("notification_action",
                            "You walk with #{pname}")
        
      when 'sleeping'
        response.set_cookie("hp", reg.cookies["hp"].to_i - 1) if reg.cookies["hp"].to_i > 0
        response.set_cookie("stomach", reg.cookies["stomach"].to_i - 1) if reg.cookies["stomach"].to_i > 0
        response.set_cookie("intelect", reg.cookies["intelect"].to_i - 1) if reg.cookies["intelect"].to_i > 0
        response.set_cookie("interest", reg.cookies["interest"].to_i - 1) if reg.cookies["interest"].to_i > 0
        response.set_cookie("purity", reg.cookies["purity"].to_i - 1) if reg.cookies["purity"].to_i > 0
        response.set_cookie("sleepiness", 0)
        response.set_cookie("time", 1)
        response.set_cookie("notification_action",
                            "#{pname} slept")
      when 'train'
        response.set_cookie("intelect", reg.cookies["intelect"].to_i + 1)
        response.set_cookie("stomach", reg.cookies["stomach"].to_i - 1) if reg.cookies["stomach"].to_i > 0
        response.set_cookie("notification_action",
                            "You train #{pname}")
      end
      check_status = -> (reg, item, minimal, adress, text) {
        if reg.cookies[item].to_i <= minimal
          response.set_cookie(adress, text)
        else
          response.set_cookie(adress, '')
        end
      }
      check_status.call(reg, 'stomach', 2, "sdsdsdsds","sdsdsd")
      check_status.call(reg, 'hp', 2, "sdsdsdsds","sdsdsd")
      check_status.call(reg, 'purity', 2, "sdsdsdsds","sdsdsd")
      check_status.call(reg, 'interest', 3, "sdsdsdsds","sdsdsd")
      check_status.call(reg, 'intelect', 2, "sdsdsdsds","sdsdsd")
      check_status.call(reg, 'sleepiness', 1, "sdsdsdsds","sdsdsd")



      #if reg.cookies['stomach'] <= 2

      #if reg.cookies['hp'] <= 2
      #if reg.cookies['purity'] <= 2
      #if reg.cookies['interest'] <= 3
      #if reg.cookies['intelect'] <= 2
      #if reg.cookies['sleepiness'] <= 1





        response.redirect('/start') if $is_it
    end
  end





  end


