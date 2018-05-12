function modify_chest_money ( count, limit )
    local hero_army = Logic.hero_lu_army()
    local bonus = Logic.hero_lu_item("sp_addgold_chest","count")
    if Logic.army_cp_count( hero_army,"pirat")>0 or Logic.army_cp_count( hero_army,"pirat2")>0 then bonus=bonus+10 end
    return count*(1+bonus/100) , 0
end





function prepare_joining_units () --ftag:action

  local army = Logic.cur_lu_army()
  local unit, unitc = Logic.army_get(army, 1)
  Logic.cur_lu_var("unit", unit) -- atom
  Logic.cur_lu_var("unitc", tostring(unitc)) -- count

  return false

end

function join_units ( param ) --ftag:action

  local from_army = true
  local check_only = param ~= ""
  if param == "2" then
    from_army = false
  end

  if Logic.cur_to_hero_join_units( from_army, check_only ) then

    local tv = Logic.cur_lu_var( "taken" )
    if tv == nil or tv == "" then
      local takentext = Game.Config( "labels/taken_units" )
      Logic.cur_lu_var( "taken", takentext )
    end
  else
    local tv = Logic.cur_lu_var( "ntaken" )
    if tv == nil or tv == "" then
      local takentext = Game.Config( "labels/noplaceforunit" )
      Logic.cur_lu_var( "taken", takentext )
      Logic.cur_lu_var( "template", "" )
    else
      Logic.cur_lu_var( "usentm", "1" ) -- use not taken message
    end


  end
  return false

end




function gen_taken_units()

  local atom = Logic.cur_lu_var("unit") -- atom
  local count = Logic.cur_lu_var("unitc") -- count

  return "<br><imu=" .. atom .. ".png><br><label=cpsn_" .. atom .. ">: +" .. count
end

function gen_add_troop()

  local troop = troop_add_global

  return "<label=cpsn_" .. troop .. ">: +"
end


function gen_counter_in_box_name()

  -- доступны переменные:
  -- ctaken - тэг счетчика (например mana)
  -- count - количество взятого
  -- image
  return "<br><image="..Logic.cur_lu_var("image").."><br><label="..Logic.cur_lu_var("ctaken").."_name>: +"..Logic.cur_lu_var("count")
end

function gen_object_in_box_name(par)
  -- доступны переменные:
  -- object - тэг предмета
  -- count - количество взятого
  -- image
    local cs = Logic.cur_lu_var("count")
    local count = 0
    if cs ~= nil then
      count = tonumber( "0" .. cs )
    end
    if par == "image" then 
      return "<imb=" .. Logic.cur_lu_var("image") .. ">" --<br><label=itm_"..Logic.cur_lu_var("object").."_name>: "..tostring(count)
    end 
    if par == "name" then
      if count > 1 then
        return "<label=itm_"..Logic.cur_lu_var("object").."_name>: "..tostring(count)
      else
        return "<label=itm_"..Logic.cur_lu_var("object").."_name>"
      end
    end 
    
    if count > 1 then
      return "<br><imb=" .. Logic.cur_lu_var("image") .. "><br><label=itm_"..Logic.cur_lu_var("object").."_name>: "..tostring(count)
    else
      return "<br><imb=" .. Logic.cur_lu_var("image") .. "><br><label=itm_"..Logic.cur_lu_var("object").."_name>"
    end
end

function gen_scroll_in_box_name()
--<var=image><br>
  return "<br><image="..Logic.cur_lu_var("image").."><br><label="..Logic.cur_lu_var("scroll").."_name>: " .. Logic.cur_lu_var("scrollc")
end

function box_assume_empty () --ftag:action

  Logic.cur_cl_box_empty( true )
  return false

end

function box_before_take ( param ) --ftag:action
    local box_empty = Logic.cur_cl_box_empty()
    if ( not box_empty ) then
        Logic.cur_box_before_take()
    end

    if Logic.cur_is_units() then
      join_units("2")
    end
    return false
end

function box_taken ( param ) --ftag:action

    local box_empty = Logic.cur_cl_box_empty()

    if ( not box_empty ) then

        Logic.cur_to_hero_add_items()
        Logic.cur_to_hero_join_units()

        Logic.cur_cl_box_empty( true )
        Logic.cur_lu_var("status", "<label=visited_message_hint>")

        empty_altar()
    end

    return false

end

function empty_altar()

  local acd = tonumber( "0" .. Atom.mainval( "cooldown" ) )
  local nextc = tostring(Game.AmountFightsSuccess() + acd)
  Logic.cur_lu_var("nextc", nextc)

end

function altar_check_cooldown() --ftag:action

  local nextc = Logic.cur_lu_var("nextc")
  if nextc == nil or nextc == "" then
    Logic.cur_lu_var("status", "<label=not_visited_message_hint>")
    return false
  end

  local acd = tonumber( "0" .. Atom.mainval( "cooldown" ) )
  if acd == 0 then
    return false
  end

  if tonumber(nextc) <= Game.AmountFightsSuccess() then
    Logic.cur_lu_var("nextc", "")
    Logic.cur_cl_box_empty( false ) -- do reload
    Logic.cur_lu_var("status", "<label=not_visited_message_hint>")
    Atom.animate( "idle" )
  end
  return false
end

function object_empty_status () --ftag:vv

    local box_empty = Logic.cur_cl_box_empty()

    if ( box_empty ) then
        return "<label=empty_message_hint>"
    else
        return "<label=not_empty_message_hint>"
   end

end

function object_visited_status () --ftag:vv

    local box_empty = Logic.cur_cl_box_empty()

    if ( box_empty ) then
        return "<label=visited_message_hint>"
    else
        return "<label=not_visited_message_hint>"
   end

end

function object_visited_logic () --ftag:vv

    local visited = Logic.cur_lu_var("visited")

    if ( visited == 1 or visited == "1") then
        return "<label=visited_message_hint>"
    else
        return "<label=not_visited_message_hint>"
   end

end



function genbox( racemask ) --ftag:boxgen

  local mapk = Game.MapLocDifficulty()

  local K = Boxgen.rnd(100)

 K = K - 2
 if K < 0 then
    local num = Boxgen.rnd(100)
    if num < 50 then
    	Boxgen.parlimit("mana", "1")
    elseif num < 75 then
    	Boxgen.parlimit("mana", "2")
    elseif num < 90 then
    	Boxgen.parlimit("mana", "3")
    else
    	Boxgen.parlimit("mana", "4")
    end
    return true
 end

 K = K - 2
 if K < 0 then
    local num = Boxgen.rnd(100)
    if num < 50 then
    	Boxgen.parlimit("rage", "1")
    elseif num < 75 then
    	Boxgen.parlimit("rage", "2")
    elseif num < 90 then
    	Boxgen.parlimit("rage", "3")
    else
    	Boxgen.parlimit("rage", "4")
    end
    return true
 end

 K = K - 2
 if K < 0 then
    local num = Boxgen.rnd(100)
    if num < 50 then
    	Boxgen.parcount("attack", "1")
    elseif num < 75 then
    	Boxgen.parcount("attack", "2")
    elseif num < 90 then
    	Boxgen.parcount("attack", "3")
    else
    	Boxgen.parcount("attack", "4")
    end
    return true
 end

 K = K - 2
 if K < 0 then
    local num = Boxgen.rnd(100)
    if num < 50 then
    	Boxgen.parcount("defense", "1")
    elseif num < 75 then
    	Boxgen.parcount("defense", "2")
    elseif num < 90 then
    	Boxgen.parcount("defense", "3")
    else
    	Boxgen.parcount("defense", "4")
    end
    return true
 end

 K = K - 2
 if K < 0 then
    local num = Boxgen.rnd(100)
    if num < 50 then
    	Boxgen.parcount("intellect", "1")
    elseif num < 75 then
    	Boxgen.parcount("intellect", "2")
    elseif num < 90 then
    	Boxgen.parcount("intellect", "3")
    else
    	Boxgen.parcount("intellect", "4")
    end
    return true
 end

 K = K - 5
 if K < 0 then
    local num = Boxgen.rnd(100)
    if num < 50 then
    	Boxgen.parcount("leadership", "15")
    elseif num < 75 then
    	Boxgen.parcount("leadership", "30")
    elseif num < 90 then
    	Boxgen.parcount("leadership", "70")
    else
    	Boxgen.parcount("leadership", "150")
    end
    return true
 end

  K = K - 20
  if K < 0 then
    if not Boxgen.object(mapk) then 
      -- cant add object, add money
      Boxgen.parcount( "money", "*500" )
    end
    return true
  end



  K = K - 5
  if K < 0 then -- магия странствий

    if not Boxgen.scroll( ) then
      -- cant add scroll, add money
      Boxgen.parcount( "money", "*7" ) -- генерим денег Mini,Small,Average
    end

    return true
  end

  K = K - 6
  if K < 0 then
    local num = Boxgen.rnd(100)
    local r = Boxgen.rnd(3)
    if num < 50 then
	    if r == 0 then
	      Boxgen.parcount( "rune_might", "1" )
	    elseif r == 1 then
	      Boxgen.parcount( "rune_magic", "1" )
	    else
	      Boxgen.parcount( "rune_mind", "1" )
	    end
    elseif num < 75 then
	    if r == 0 then
	      Boxgen.parcount( "rune_might", "2" )
	    elseif r == 1 then
	      Boxgen.parcount( "rune_magic", "2" )
	    else
	      Boxgen.parcount( "rune_mind", "2" )
	    end
    elseif num < 90 then
	    if r == 0 then
	      Boxgen.parcount( "rune_might", "3" )
	    elseif r == 1 then
	      Boxgen.parcount( "rune_magic", "3" )
	    else
	      Boxgen.parcount( "rune_mind", "3" )
	    end
    else
	    if r == 0 then
	      Boxgen.parcount( "rune_might", "4" )
	    elseif r == 1 then
	      Boxgen.parcount( "rune_magic", "4" )
	    else
	      Boxgen.parcount( "rune_mind", "4" )
	    end
    end


    return true
  end

  K = K - 10
  if K < 0 then
    local r = Boxgen.rnd(100)

    if r < 50 then
      Boxgen.parcount( "crystals", "1" )
    elseif r < 75 then
      Boxgen.parcount( "crystals", "2" )
    else
      Boxgen.parcount( "crystals", "3" )
    end

    return true
  end

  K = K - 10
  if K < 0 then -- простой свиток

    local r = Boxgen.rnd(100)
    local count = 3
    if r < 80 then
      count = 1
    elseif r < 95 then
      count = 2
    end

    if not Boxgen.scroll( mapk, count ) then
      -- cant add scroll, add money
      Boxgen.parcount( "money", "*7" ) -- генерим денег Mini,Small,Average
    end


    return true
  end


  -- Boxgen.parcount( "money", "*7" ) -- генерим денег Mini,Small,Average
  local r = Boxgen.rnd(100)
	if r < 50 then
  	Boxgen.parcount( "money", "*1" ) -- генерим денег Mini
	elseif r < 80 then
  	Boxgen.parcount( "money", "*2" ) -- генерим денег Small
	else
		Boxgen.parcount( "money", "*4" ) -- генерим денег Average
	end
  

  return true
end

