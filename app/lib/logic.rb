$is_it = true
module Logic
  def self.change_params(reg, type_item)
    pname = reg.cookies['name']
    Rack::Response.new do |response|
      random_event = -> (reg, item) {
        intelect = reg.cookies["intelect"].to_i
        interest = reg.cookies["interest"].to_i
        stomach = reg.cookies["stomach"].to_i
        hp = reg.cookies["hp"].to_i
        case item
        when 'walk'
          if intelect < 2
            situation = rand(1..5)
          elsif intelect >= 2 && intelect <= 4
            situation = rand(3..5)
          else
            situation = rand(4..5)
          end
          case situation
          when 1
            stomach -= 3 if stomach > 3
            stomach = 0 if stomach < 3
            hp -= 1
            $notification_event = "When you walking your pet found trash and eat it. It's hurts....(-3 stomach and -1 hp)"
          when 3
            stomach += 2
            stomach = 5 if stomach < 5 - 3
            hp += 1 if hp != 6
            $notification_event = 'When you walking your pet normal food. Next time be careful you may catch something dangerous
(+2 stomach and +1 hp)'
          when 5
            stomach = 5
            hp = 6
            $notification_event = "During your walkin #{pname} breathed freash air and it feel nice(max stomach and max hp)"
          end
        when 'train'
          situation = rand(1..5)
          case situation
          when 1
            hp -= 2
            $notification_event = 'When you trained your pet, you were inattentive. It hurts .... ( -2 hp)'
          when 3
            intelect += 1 if intelect <= 6 - 1
            hp += 1 if hp != 6 - 1
            $notification_event = 'Your training is successful. Get extra bonus(+1 intelect and +1 hp)'
          when 5
            intelect += 2 if intelect <= 6 - 3
            hp += 2 if hp != 6 - 2
            $notification_event = 'Your training is very successful. Get mega bonus(+2 intelect and +2 hp)'
          end
        when 'interest'
          situation = rand(1..5)
          case situation
          when 1
            hp -= 2
            $notification_event = 'When you play with your pet, you were inattentive. It hurts .... (-2 hp)'
          when 3
            intelect += 1 if intelect <= 6 - 1
            hp += 1 if hp != 6 - 1
            $notification_event = 'Your playing is successful. Get extra bonus(+1 intelect and +1 hp)'
          when 5
            interest += 1 if interest <= 5 - 2
            intelect += 1 if reg.cookies["intelect"].to_i <= 6 - 2
            hp += 2 if hp != 6 - 2
            $notification_event = 'Your playing is very successful. Get mega bonus(+ 1 interest and +1 intelect and +1 hp)'
          end
        end
      }

      case reg.cookies["time"].to_i
      when '3'
        day_period = "morning"
      when '1'
        day_period = "noonday"
      when '2'
        day_period = "night"
      end
      response.set_cookie('day_period', day_period)
      response.set_cookie("time", reg.cookies["time"].to_i.to_i + 1) if reg.cookies["time"].to_i.to_i < 3
      case type_item
      when 'hp'
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i.to_i + 1)
        response.set_cookie("stomach", reg.cookies["stomach"].to_i.to_i + 1) if reg.cookies["stomach"].to_i.to_i < 5
        response.set_cookie("hp", reg.cookies["hp"].to_i.to_i + rand(0..1)) if reg.cookies["hp"].to_i.to_i < 6
        response.set_cookie("notification_action",
                            "You feed #{pname}")
        
      when 'interest'
        response.set_cookie('interest', reg.cookies['interest'].to_i + 1) if reg.cookies['interest'].to_i < 6
        response.set_cookie("stomach", reg.cookies["stomach"].to_i.to_i - 1) if reg.cookies["stomach"].to_i.to_i > 0
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i.to_i + 1)
        response.set_cookie("notification_action",
                            "You play with #{pname}")
        random_event.call(reg, type_item)
        
      when 'cleaning'
        response.set_cookie("purity", 4)
        response.set_cookie("interest", reg.cookies["interest"].to_i.to_i - 1) if reg.cookies["interest"].to_i.to_i > 0
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i.to_i + 1)
        response.set_cookie("notification_action",
                            "You wash #{pname}")
        
      when 'looking'
        response.set_cookie("hp", reg.cookies["hp"].to_i.to_i - 1) if reg.cookies["hp"].to_i.to_i > 0
        response.set_cookie("stomach", reg.cookies["stomach"].to_i.to_i - 1) if reg.cookies["stomach"].to_i.to_i > 0
        response.set_cookie("intelect", reg.cookies["intelect"].to_i.to_i - 1) if reg.cookies["intelect"].to_i.to_i > 0
        response.set_cookie("interest", reg.cookies["interest"].to_i.to_i - 1) if reg.cookies["interest"].to_i.to_i > 0
        response.set_cookie("purity", reg.cookies["purity"].to_i.to_i - 1) if reg.cookies["purity"].to_i.to_i > 0
        response.set_cookie("sleepiness", reg.cookies["sleepiness"].to_i.to_i + 1)
        response.set_cookie("notification_action",
                            "You just looking of #{pname}")
        
      when 'walk'
        $walk_result = "away" if reg.cookies["interest"].to_i.to_i <= 3 && rand(1..10) == 3
        $walk_result = "lost" if reg.cookies["intelect"].to_i.to_i <= 2 && rand(1..10) == 4
        response.set_cookie("interest", reg.cookies["interest"].to_i.to_i + 1)
        response.set_cookie("stomach", reg.cookies["stomach"].to_i.to_i - 1) if reg.cookies["stomach"].to_i.to_i > 0
        response.set_cookie("purity", reg.cookies["purity"].to_i.to_i - 1) if reg.cookies["purity"].to_i.to_i > 0
        response.set_cookie("notification_action",
                            "You walk with #{pname}")

        
      when 'sleeping'
        response.set_cookie("hp", reg.cookies["hp"].to_i.to_i - 1) if reg.cookies["hp"].to_i.to_i > 0
        response.set_cookie("stomach", reg.cookies["stomach"].to_i.to_i - 1) if reg.cookies["stomach"].to_i.to_i > 0
        response.set_cookie("intelect", reg.cookies["intelect"].to_i.to_i - 1) if reg.cookies["intelect"].to_i.to_i > 0
        response.set_cookie("interest", reg.cookies["interest"].to_i.to_i - 1) if reg.cookies["interest"].to_i.to_i > 0
        response.set_cookie("purity", reg.cookies["purity"].to_i.to_i - 1) if reg.cookies["purity"].to_i.to_i > 0
        response.set_cookie("sleepiness", 0)
        response.set_cookie("time", 1)
        response.set_cookie("notification_action",
                            "#{pname} slept")
      when 'train'
        response.set_cookie("intelect", reg.cookies["intelect"].to_i.to_i + 1)
        response.set_cookie("stomach", reg.cookies["stomach"].to_i.to_i - 1) if reg.cookies["stomach"].to_i.to_i > 0
        response.set_cookie("notification_action",
                            "You train #{pname}")
        random_event.call(reg, type_item)
      end

      check_status = -> (reg, item, minimal, adress, text) {
        if reg.cookies[item].to_i - 1 <= minimal
          response.set_cookie(adress, text.to_s)
        else
          response.set_cookie(adress, '')
        end
      }
      check_status.call(reg, 'stomach', 2, "stomach_notification",
                        "#{pname} stomach is #{reg.cookies["stomach"].to_i} and it's to low. Feed #{pname}")
      check_status.call(reg, 'hp', 2, "hp_notification",
                        "#{pname} hp is #{reg.cookies["hp"].to_i} and it's to low. Feed #{pname}")
      check_status.call(reg, 'purity', 2, "purity_notification",
                        "#{pname} purity is #{reg.cookies["purity"].to_i} and it's to low. Wash #{pname}")
      check_status.call(reg, 'interest', 3, "interest_notification",
                        "#{pname} interest is #{reg.cookies["interest"].to_i} and it's to low. Play or walk with #{pname} ")
      check_status.call(reg, 'intelect', 2, "intelect_notification",
                        "#{pname} intelect is #{reg.cookies["intelect"].to_i} and it's to low. Train #{pname}")



        response.redirect('/start') if $is_it
    end
  end





  end


