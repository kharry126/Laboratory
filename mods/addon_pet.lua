function pet_idle()
	if Attack.val_restore("available") ~= 0 then
		if Attack.is_pet_attack_selected() then
    		Atom.animate("idleshort")
    	else
    		local petpos,ang = Attack.get_spirit_cell()
    		ang = ang - math.pi
    		local x,y = Attack.act_get_center(petpos)
    		local c = Attack.find_nearest_cell(x+math.sin(ang)*3, y+math.cos(ang)*3)
    		local animname = "idlenosteps"
    		if Attack.cell_present(c) and Attack.cell_is_empty(c) then
    			animname = "idle"
    			for dir=0,5 do
    				local t = Attack.cell_adjacent(c, dir)
		    		if not (t ~= nil and Attack.cell_present(t) and Attack.cell_is_empty(t)) then
		    			animname = "idlenosteps"
		    			break
		    		end
    			end
			end
    		Atom.animate(animname)
    	end
	else
		Atom.animate("sleep")
	end
end

function pet_after_hit()

   	Attack.done_timeshift(Attack.aseq_time(0))
	if tonumber(Attack.get_custom_param("rest")) > 0 then
		Attack.act_aseq( 0, "sleepdown" )
		Attack.val_store(0, "available", 0)
		pet_rest = tonumber(Attack.get_custom_param("rest"))
		Attack.val_store(0, "rest", pet_rest)
	end

	-- spend rage
	local hero_rage = Logic.cur_lu_item( "rage", "count" )
	local rage_used = tonumber( "0" .. Attack.get_custom_param("rage") )
	local new_hero_rage = math.max( 0, hero_rage - rage_used )
	Game.GVNumInc("pet_rage_used", rage_used)
	Game.GVSNumInc("latest_battle", "rage_spent", rage_used)

	Logic.cur_lu_item( "rage", "count", new_hero_rage )

	-- add exp
	local exp_add = tonumber( "0" .. Attack.get_custom_param("exp") )
	local exp_bonus=tonumber( "0" .. Logic.hero_lu_item("sp_addexp_spirit","count") )
	Attack.add_exp( exp_add*(1+exp_bonus/100) )

end


function get_lightning_ball_ids()
    local lightning_ball_ids = {} -- запоминаем клетки, где стоят гизмо, чтобы два не встали на одну клетку
    for i=1, Attack.act_count()-1 do
        if Attack.act_name(i) == "lightning_ball" then
            lightning_ball_ids[Attack.cell_id(Attack.get_cell(i))] = true
            
        end
    end
    return lightning_ball_ids
end

function lightning_ball_calccells()

    local lightning_ball_ids = get_lightning_ball_ids()

    local ccnt = Attack.cell_count()
    for i=0,ccnt-1 do               -- for all cells
        local c = Attack.cell_get(i)
        if empty_cell(c) and lightning_ball_ids[Attack.cell_id(c)] ~= true then
            Attack.marktarget(c)     -- select
        end
    end

    return true

end

function lightning_ball_attack()

	Attack.log_label("null")
		local bel = Attack.val_restore("belligerent")
		local charges = Attack.val_restore("charges")

    local under, target = Attack.get_caa(Attack.get_cell(0))

    local can_stay_here = false
    if under ~= nil then
				if Attack.act_enemy(under, bel) then
            can_stay_here = true
        end
    end

    local lightning_ball_ids = {} -- запоминаем клетки, где стоят гизмо, чтобы два не встали на одну клетку
    for i=1, Attack.act_count()-1 do
        if Attack.act_name(i) == "lightning_ball" then
            lightning_ball_ids[Attack.cell_id(Attack.get_cell(i))] = true
        end
    end

    local ap, rand = 4, Game.CurLocRand(100)
    if can_stay_here and rand < 20 then
        -- остаёмся на месте
        target = under
    else
        local maxtothp, dist, nearest = 0, 1e6

		if under ~= nil then maxtothp = Attack.act_totalhp(under); target = under end

        for a=1, Attack.act_count()-1 do
            local i = Attack.get_cell(a)
            if (under == nil or not Attack.act_equal(under, i)) and (Attack.act_enemy(i, bel)) and lightning_ball_ids[Attack.cell_id(i)] ~= true then -- последняя проверка нужна, чтобы молнии не кучковались

				local d = Attack.cell_mdist(0, i)
                local tothp = Attack.act_totalhp(i) -- ищем толстейшую цель (т.к. урон в процентах от totalhp) в пределах досягаемости
                if tothp > maxtothp and d / 1.8 <= ap + 1 then
                    maxtothp = tothp
                    target = i
                end
				if d < dist then -- также ищем ближайшую цель
					dist = d
					nearest = i
				end

            end
        end

		if target == nil then target = nearest end -- если сильнейшая цель за пределами досягаемости, то выбираем ближайшую

        if can_stay_here and
            (dist / 1.8 > ap*1.5 or -- ближайшая цель слишком далеко
            (dist / 1.8 > ap + 1 and rand < 80)) then -- цель не очень далеко, но вне радиуса действия (одного хода не хватит, чтобы долететь), тогда с вероятностью 33% мы полетим до неё, и с такой же - останемся на месте
                target = under
        end
    end

    if target ~= nil then
        local d = Attack.cell_mdist(0, target) / 1.8
        if d > ap + 1 then -- запас +1 нужен, чтобы не было так, что гизмо встал на клетку с врагом и при этом ничего не сделал

            for i=ap,1,-1 do
                local dist = 1.8 * i
                local x, y = Attack.act_get_center(0)
                local dx, dy = Attack.act_get_center(target)
                dx = dx - x; dy = dy - y
                local len = math.sqrt(dx*dx + dy*dy)
                dx = dx*dist/len; dy = dy*dist/len
                local dest = Attack.find_nearest_cell(x + dx, y + dy)

                if lightning_ball_ids[Attack.cell_id(dest)] ~= true then
                    Attack.act_move(0, i, 0, dest)
                    break
                end
            end

        else

            Attack.act_move(0, d, 0, target)
            if Attack.act_ally(target, bel) then


            else

            -- калечим!
	if Game.CurLocRand(100) < tonum(Attack.val_restore("shock")) then
		effect_shock_attack(target, d)
	end

								Attack.log_label("")
                Attack.act_aseq(0, "attack"..charges)
                Attack.atk_set_damage("magic", Game.CurLocRand(text_range_dec(Attack.val_restore("damage"))) * Attack.act_totalhp(target) / 100)
                common_cell_apply_damage(target, d + Attack.aseq_time(0, "x"))

				-- уменьшаем заряды только при нанесении урона
	            if charges == 1 then
	                Attack.act_aseq(0, "disappear")
	                Attack.act_remove(0, d + Attack.aseq_time(0))
	            else
	                Attack.val_store(0, "charges", charges-1, d+.1)
	            end

            Attack.aseq_timeshift(0, d)
					end
        end
    end

    return true

end

function lightning_ball_idle()
		
		local count = Attack.val_restore("charges")
		if count == nil then count = "3" end 
    Atom.animate("idle" .. count)

end


--------------
---- Lava ----
--------------
function pet_lava()
------------------------ camera block --------------
	if Game.CurLocRand(100) < 70 then
	  if Game.ArenaShape() == 1 or Game.ArenaShape() == 5 or Game.ArenaShape() == 2 then
            Attack.cam_track(0, 0, "cam_pet_attack_lava_left.track" )
	  else
	    if Game.CurLocRand(100) < 50 then
              Attack.cam_track(0, 0, "cam_pet_attack_lava_left.track" )
	    else
	      Attack.cam_track(0, 0, "cam_pet_attack_lava.track" )
	    end
	  end
	end
------------------------ end of camera -------------
	Attack.act_aseq( 0, "attack_lava" )
	local hit_time = Attack.aseq_time( 0, "x")
	local count = tonumber(Attack.get_custom_param("count"))
	
	local spread_max = Attack.aseq_time( 0, "spread")
  for i=1,Attack.act_count()-1 do

    if Attack.act_enemy(i) and Attack.act_takesdmg(i) and count>0 then

	  local spread = math.random()*spread_max
	  common_cell_apply_damage(i, hit_time+spread)

      Attack.atom_spawn(i, spread, "fxm_lava4pet", Attack.angleto(0,i))
      count=count-1

    end
  end

    pet_after_hit()

	return true

end

function calccells_smash_hit()

  Attack.direction(true)
  for i=1,Attack.act_count()-1 do
    if (Attack.act_enemy(i) or Attack.act_pawn(i)) and Attack.act_hp(i)>0 and Attack.act_applicable(i) and Attack.act_takesdmg(i) then
    	for dir=0,5 do
    		local c = Attack.cell_adjacent(i,dir)
    		if empty_cell(c) then -- нужно чтобы вокруг врага была хотя б одна пустая клетка
        		Attack.marktarget(i)
        		break
        	end
        end
    end
  end
  return true

end

--------------
---- Hit  ----
--------------
function pet_smash_hit()

	local target = Attack.get_target()
	local dir = Attack.direction()
	local invdir = math.mod(dir+3,6)
	local cellto = Attack.cell_adjacent(target, dir)
	local startpos,startdir = Attack.get_spirit_cell()
------------------------ camera block --------------
	local photo = Attack.photogenic(target)

	if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
	  if math.random(100) < 80 then
	    if photo == 1 then
              Attack.cam_track(0, 35, 75, 0, target, "cam_pet_attack_hit_left.track" )
	    end
	    if photo == 0 then
	      if Game.ArenaShape() ~= 1 then
		if math.random(100) < 50 then
	          Attack.cam_track(0, 35, 75, 0, target, "cam_pet_attack_hit_left.track" )
		else
		  Attack.cam_track(0, 35, 75, 0, target, "cam_pet_attack_hit.track" )
		end
	      end
	    end
	  end
	end

------------------------ end of camera -------------

	Attack.act_aseq( 0, "attack_hit" )
	Attack.act_rotate( Attack.aseq_time(0,"rs1"), Attack.aseq_time(0,"re1"), 0, cellto )
	Attack.act_move  ( Attack.aseq_time(0,"ms1"), Attack.aseq_time(0,"me1"), 0, cellto )
	Attack.act_rotate( Attack.aseq_time(0,"rs2"), Attack.aseq_time(0,"re2"), 0, Game.Dir2Ang(invdir) )
	local dmgts = Attack.aseq_time(0,"x")
	common_cell_apply_damage(target, dmgts)
	Attack.act_rotate( Attack.aseq_time(0,"rs3"), Attack.aseq_time(0,"re3"), 0, Attack.angleto(0,cellto) )
	Attack.act_move  ( Attack.aseq_time(0,"ms2"), Attack.aseq_time(0,"me2"), 0, startpos )
	Attack.act_rotate( Attack.aseq_time(0,"rs4"), Attack.aseq_time(0,"re4"), 0, startdir )

	local push = Attack.get_custom_param("push")

	if not Attack.act_feature(target, "boss,pawn") and Attack.act_level(target)<4 and Attack.act_get_par(target, "dismove") == 0 then
		local to, moveto = target
		for i=1, push do
			to = Attack.cell_adjacent(to, invdir)
			if empty_cell(to) then moveto = to else break end
		end
		if moveto ~= nil then
    		Attack.act_move(dmgts, Attack.aseq_time(0,"x1"), target, moveto)
    	end
	end

    pet_after_hit()

	return true

end

--------------
--- Digger ---
--------------
function calccells_digger()

	if dig_cells == nil then -- расставляем клады при первом использовании
		-- Инициализация кладоискателя
		local all_cells = {}
		for i=0,Attack.cell_count()-1 do
			local c = Attack.cell_get(i)
			if empty_cell(c) then table.insert(all_cells, Attack.cell_id(c)) end
		end
		dig_cells = {}
		for i=1,10 do
			if table.getn(all_cells) == 0 then break end
			local n = Game.CurLocRand(1,table.getn(all_cells))
			dig_cells[all_cells[n]] = math.mod(i,2)+1
			table.remove(all_cells, n)
		end
	end

	local limits = {tonum(Attack.get_custom_param("green")), tonum(Attack.get_custom_param("red"))}
	for id,type in pairs(dig_cells) do
	  local cell, abstype = Attack.cell_id(id), math.abs(type)
	  if limits[abstype] > 0 then
	    if type > 0 and Attack.cell_is_empty(cell) and Attack.cell_is_pass(cell) then  -- cell is empty
	    	Attack.marktarget(cell, ({"green","red"})[type])         -- select it
		end
	    limits[abstype] = limits[abstype] - 1
	  end
	end

	return true

end

function pet_digger()

	local target = Attack.get_target()

	local what, ischest
    if dig_cells[Attack.cell_id(target)] == DIGCELL_BOX then
        what = "pet_chest"; ischest = true
    else
		local pawns = {"altar_bad_statue", "altar_bomb", "altar_hollow", "altar_volcano"}
		what = pawns[Game.CurLocRand(1, table.getn(pawns))]
    end
	local startpos,startdir = Attack.get_spirit_cell()
------------------------ camera block --------------
	local photo = Attack.photogenic(target)

	if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
	  if math.random(100) < 80 then
	    if photo == 1 then
              Attack.cam_track(0, 37, 70, 0, target, "cam_pet_attack_digger_centre.track" )
	    end
	    if photo == 0 then
	      if Game.ArenaShape() ~= 1 then
		if math.random(100) < 50 then
	          Attack.cam_track(0, 37, 70, 0, target, "cam_pet_attack_digger_centre.track" )
		else
		  Attack.cam_track(0, 37, 70, 0, target, "cam_pet_attack_digger.track" )
		end
	      end
	    end
	  end
	end
------------------------ end of camera -------------

	Attack.act_aseq( 0, "attack_digger" )
	Attack.act_rotate( Attack.aseq_time(0,"rs1"), Attack.aseq_time(0,"re1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms1"), Attack.aseq_time(0,"me1"), 0, target )
	local a=Attack.atom_spawn(target, Attack.aseq_time(0,"as1")-.1, what, 0)
	if not ischest then init_pawn(Attack.get_caa(a)) end
--	Attack.act_rotate( Attack.aseq_time(0,"rs2"), Attack.aseq_time(0,"re2"), 0, Attack.angleto(0,target) )
	Attack.act_move  ( Attack.aseq_time(0,"ms2"), Attack.aseq_time(0,"me2"), 0, startpos )
	Attack.act_rotate( Attack.aseq_time(0,"rs2"), Attack.aseq_time(0,"re2"), 0, startdir )

    local tx,ty,tz = Attack.act_get_center(a) -- запоминаем начальное положение
    Attack.act_move( Attack.aseq_time(0,"as1")-.1, Attack.aseq_time(0,"as1"), a, tx,ty,tz-2 )
    Attack.act_move( Attack.aseq_time(0,"as1")   , Attack.aseq_time(0,"ae1"), a, tx,ty,tz )

	dig_cells[Attack.cell_id(target)] = -dig_cells[Attack.cell_id(target)]
	
	Attack.log_label("use_pet_search_")
    pet_after_hit()

	return true

end

function custom_genbox( racemask ) -- для сундуков дракончика

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
  if K < 0 then
    if not Boxgen.scroll( ) then
      -- cant add scroll, add money
      Boxgen.parcount( "money", "*7" )
    end

    return true
  end

  K = K - 7
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

  K = K - 9
  if K < 0 then
    local r = Boxgen.rnd(100)

    if r < 50 then
      Boxgen.parcount( "crystals", "1" )
    elseif r < 75 then
      Boxgen.parcount( "crystals", "2" )
    elseif r < 90 then
      Boxgen.parcount( "crystals", "3" )
    else
      Boxgen.parcount( "crystals", "5" )
    end

    return true
  end

  K = K - 12
  if K < 0 then -- простой свиток

    local r = Boxgen.rnd(100)
    local count = 3
    if r < 80 then
      count = 1
    elseif r < 95 then
      count = 2
    end

    if not Boxgen.scroll( Game.MapLocDifficulty(), count ) then
      -- cant add scroll, add money
      Boxgen.parcount( "money", "*7" ) -- генерим денег Mini,Small,Average
    end

    return true
  end


  -- Boxgen.parcount( "money", "*7" ) -- генерим денег Mini,Small,Average
  local r = Boxgen.rnd(100)
	if r < 40 then
  	Boxgen.parcount( "money", "*1" ) -- генерим денег Mini
	elseif r < 75 then
  	Boxgen.parcount( "money", "*2" ) -- генерим денег Small
	else
		Boxgen.parcount( "money", "*4" ) -- генерим денег Average
	end


  return true

end

--------------
--- Frenzy ---
--------------
function pet_frenzy()
------------------------ camera block --------------
	if math.random(100) < 70 then
	  if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
            Attack.cam_track(0, 0, "cam_pet_attack_frenzy_castle.track" )
	  else
	    if math.random(100) < 50 then
              Attack.cam_track(0, 0, "cam_pet_attack_frenzy_castle.track" )
	    else
	      Attack.cam_track(0, 0, "cam_pet_attack_frenzy.track" )
	    end
	  end
	end
------------------------ end of camera -------------
	Attack.act_aseq( 0, "attack_frenzy" )
	local hit_time = Attack.aseq_time( 0, "x")
	local hit_shift = Attack.aseq_time( "fxm_pet_ghost_frenzy_drop", "idle", "x" )
	local spread_max = Attack.aseq_time( 0, "spread")
	local allyk = Attack.get_custom_param("ally")/100

	for t=0,Attack.get_targets_count()-1 do

		local i = Attack.get_target(t)

		if i ~= nil and Attack.get_caa(i) ~= nil and Attack.act_applicable(i) and Attack.act_takesdmg(i) then
			local spread = math.random()*spread_max
			local k = 1
			if Attack.act_ally(i) then k = allyk end
			Attack.atk_set_damage("astral", Attack.get_custom_param("damage.astral.0")*k, Attack.get_custom_param("damage.astral.1")*k)
			common_cell_apply_damage(i, hit_time+spread+hit_shift)
			Attack.atom_spawn(i, hit_time+spread, "fxm_pet_ghost_frenzy_drop", Attack.angleto(0,i))
		end

	end

    pet_after_hit()

	return true

end

--------------
--- Ball   ---
--------------
function pet_ball()

	local target = Attack.get_target()

	local startpos,startdir = Attack.get_spirit_cell()

------------------------ camera block --------------
	local photo = Attack.photogenic(target)

	if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
	  if math.random(100) < 80 then
	    if photo == 1 then
              Attack.cam_track(0, 40, 75, 0, target, "cam_pet_attack_ball_left.track" )
	    end
	    if photo == 0 then
	      if Game.ArenaShape() ~= 1 then
		if math.random(100) < 90 then
	          Attack.cam_track(0, 40, 75, 0, target, "cam_pet_attack_ball_left.track" )
		else
		  Attack.cam_track(0, 40, 75, 0, target, "cam_pet_attack_ball.track" )
		end
	      end
	    end
	  end
	end
------------------------ end of camera -------------

	Attack.act_aseq( 0, "attack_ball" )
	Attack.act_rotate( Attack.aseq_time(0,"rs1"), Attack.aseq_time(0,"re1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms1"), Attack.aseq_time(0,"me1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms2"), Attack.aseq_time(0,"me2"), 0, startpos )
	Attack.act_rotate( Attack.aseq_time(0,"rs2"), Attack.aseq_time(0,"re2"), 0, startdir )

    local start = Attack.aseq_time(0,"x")
	local atom = Attack.atom_spawn(target, start, "lightning_ball", 0)
    Attack.act_animate(atom, "appear", start)

    Attack.val_store(atom, "belligerent", Attack.act_belligerent())
    Attack.val_store(atom, "charges", 3)
    Attack.val_store(atom, "damage", Attack.get_custom_param("damage.magic.0")..'-'..Attack.get_custom_param("damage.magic.1"))
    Attack.val_store(atom, "shock", Attack.get_custom_param("shock"))
    Attack.resort( atom )

		Attack.log_label("use_pet_ball_")
    pet_after_hit()

	return true

end

--------------
--- Dive   ---
--------------
function pet_dive()

	local target = Attack.get_target()

	local startpos,startdir = Attack.get_spirit_cell()
------------------------ camera block --------------
	local photo = Attack.photogenic(target)

	if math.random(100) < 70 then
	  if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
	    if photo < 2 then
              Attack.cam_track(0, 45, 70, 0, target, "cam_pet_attack_dive_calm.track" )
	    end
	  else
	    if photo == 1 then
              Attack.cam_track(0, 45, 70, 0, target, "cam_pet_attack_dive_calm.track" )
	    else
	      if photo == 0 then
	      Attack.cam_track(0, 45, 70, 0, target, "cam_pet_attack_dive.track" )
	      end
	    end
	  end
	end
------------------------ end of camera -------------

	local k = tonumber(Attack.get_custom_param("amp"))
	local dmg_min, dmg_max = tonumber(Attack.get_custom_param("damage.physical.0")),tonumber(Attack.get_custom_param("damage.physical.1"))

	Attack.act_aseq( 0, "attack_dive" )
	Attack.act_rotate( Attack.aseq_time(0,"rs1"), Attack.aseq_time(0,"re1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms1"), Attack.aseq_time(0,"me1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms2"), Attack.aseq_time(0,"me2"), 0, startpos )
	Attack.act_rotate( Attack.aseq_time(0,"rs2"), Attack.aseq_time(0,"re2"), 0, startdir )

	local dmgts, move_end = Attack.aseq_time(0,"as1"), Attack.aseq_time(0,"ae1")
	for i=1, Attack.act_count()-1 do
	    if Attack.act_enemy(i) and Attack.act_applicable(i) and Attack.act_hp(i)>0 then

		    local dist = Attack.cell_dist(target,i)-1
		    Attack.atk_set_damage("physical",dmg_min*(1-k*dist/100),dmg_max*(1-k*dist/100))

			common_cell_apply_damage(i, dmgts)
			if Attack.cell_dist(target, i) == 1 then
				local dir = Game.Ang2Dir(Attack.angleto(target,i))
				local to = Attack.cell_adjacent(i, dir)
				if empty_cell(to) and Attack.act_get_par(i, "dismove") == 0 and not Attack.act_pawn(i) then
				    Attack.act_move(dmgts, move_end, i, to)
				end
			end
		end
	end

    pet_after_hit()

	return true

end

----------------
--- Alienegg ---
----------------
function pet_alienegg()

	local target = Attack.get_target()

	local startpos,startdir = Attack.get_spirit_cell()
------------------------ camera block --------------
	local photo = Attack.photogenic(target)

	if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
	  if math.random(100) < 80 then
	    if photo == 1 then
              Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg_calm.track" )
	    end
	    if photo == 0 then
	      if Game.ArenaShape() ~= 1 then
		if math.random(100) < 50 then
	          Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg_calm.track" )
		else
		  Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg.track" )
		end
	      end
	    end
	  end
	end
------------------------ end of camera -------------

	Attack.act_aseq( 0, "attack_alienegg" )
	Attack.act_rotate( Attack.aseq_time(0,"rs1"), Attack.aseq_time(0,"re1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms1"), Attack.aseq_time(0,"me1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms2"), Attack.aseq_time(0,"me2"), 0, startpos )
	Attack.act_rotate( Attack.aseq_time(0,"rs4"), Attack.aseq_time(0,"re4"), 0, startdir )

  local unit={"spider_undead,spider,spider_venom,dragonfly_fire,dragonfly_lake","spider_fire,snake_green,snake","highterrant,snake_royal,griffin,griffin2","blackdragon,bonedragon,greendragon,reddragon"}
  local unit_level=tonumber(Attack.get_custom_param("lvl"))
  
  local unit_tmp_name=unit[math.max(1,Game.CurLocRand(unit_level-2,unit_level))]
  local unit_tmp_count=text_par_count(unit_tmp_name)
  local unit_summon=text_dec(unit_tmp_name,Game.CurLocRand(1,unit_tmp_count))

  local lead_attack=math.floor(tonumber(Attack.get_custom_param("lead"))*hero_item_count2("leadership","count")/100)+tonumber(Attack.get_custom_param("baselead"))
  local count_summon=math.ceil(lead_attack/Attack.atom_getpar(unit_summon,"leadership"))
    
  -- дополнительно включим ящеров...

	local egg=Attack.atom_spawn(target, Attack.aseq_time(0), "alienegg", Attack.angleto(0,target))
	--Attack.resort(a)

	local spawnegg = Attack.aseq_time(0,"spawnegg")
	local b=Attack.atom_spawn(target, spawnegg, "fxm_alienegg_appear", Attack.angleto(0,target))
	Attack.val_store(egg, "count", count_summon)
	Attack.val_store(egg, "unit", unit_summon)
	Attack.val_store(egg, "belligerent", 1) -- чтобы ИИ считал его за своего
	
	Attack.act_aseq(b, "idle")
  Attack.aseq_timeshift( b, spawnegg )
	Attack.log_label("use_pet_egg_")

    pet_after_hit()

	return true

end

function alienegg_pip()
	
	local name = Attack.get_caa(0)
	Attack.act_kill(0,true)
	local unit = Attack.val_restore("unit")
	local count = Attack.val_restore("count")
	Attack.act_spawn(0, 1, unit, 0, count)
	local caa = Attack.get_caa(Attack.get_cell(0))
	local delay = 0
	local endt = delay + 5./25
	Attack.act_fadeout(caa, 0, delay, 0.01, 0)
	Attack.act_fadeout(caa, delay, endt, 1)
    Attack.act_teleport(caa, caa, endt)
    Attack.act_animate(caa, "damage", 0)
    Attack.resort( caa )
	if count == 1 then 
		Attack.log("add_blog_summon_egg_1","name",blog_side_unit(name,1,Attack.act_belligerent(caa)),"special2",blog_side_unit(caa,0)) -- работает
	else
		Attack.log("add_blog_summon_egg_2","name",blog_side_unit(name,1,Attack.act_belligerent(caa)),"special2",blog_side_unit(caa,0),"special",count) -- работает
	end 
	
	return true

end

-----------------
--- Energetic ---
-----------------

function pet_energetic()

	local target = Attack.get_target()

	local startpos,startdir = Attack.get_spirit_cell()
------------------------ camera block --------------
	local photo = Attack.photogenic(target)

	if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
	  if math.random(100) < 80 then
	    if photo == 1 then
              Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg_calm.track" )
	    end
	    if photo == 0 then
	      if Game.ArenaShape() ~= 1 then
		if math.random(100) < 50 then
	          Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg_calm.track" )
		else
		  Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg.track" )
		end
	      end
	    end
	  end
	end
------------------------ end of camera -------------

	Attack.act_aseq( 0, "attack_energ" )
	Attack.act_rotate( Attack.aseq_time(0,"rs1"), Attack.aseq_time(0,"re1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms1"), Attack.aseq_time(0,"me1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms2"), Attack.aseq_time(0,"me2"), 0, startpos )
	Attack.act_rotate( Attack.aseq_time(0,"rs4"), Attack.aseq_time(0,"re4"), 0, startdir )

	local spawnenerg = Attack.aseq_time(0,"spawnenerg")
	local a=Attack.atom_spawn(target, spawnenerg, "energ", Attack.angleto(0,target))
	Attack.act_aseq(a, "appear")
	Attack.aseq_timeshift(a, spawnenerg)

	Attack.val_store(a, "val", tonumber(Attack.get_custom_param("mana")))
	Attack.val_store(a, "name", "mana")
	Attack.val_store(a, "ap", tonumber(Attack.get_custom_param("ap")))
	Attack.cell_bonus(target, a)
	
	Attack.log_label("use_pet_egg_")
    pet_after_hit()

	return true

end

----------------
---   Wall   ---
----------------

function petwall_2nd_cell(target, dir)
	return Attack.cell_adjacent(target, math.mod(dir+1, 6))
end

function petwall_3rd_cell(target, dir)
	return Attack.cell_adjacent(target, math.mod(dir+5, 6))
end

function calccells_petwall()

	Attack.direction(true)
	for i=0, Attack.cell_count()-1 do
		local c = Attack.cell_get(i)
		if empty_cell(c) then
			for dir=0,5 do -- смотрим, можно ли поставить стену хотя бы по одной из ориентаций
				if empty_cell(petwall_2nd_cell(c, dir)) and empty_cell(petwall_3rd_cell(c, dir)) then
					Attack.marktarget(c)
					break
				end
			end
		end
	end
	return true

end

function correct_wall_dir(target, idir)
	for k,d in ipairs({0,1,-1,2,-2,3}) do
		local dir = math.mod(idir + d + 6, 6)
		if empty_cell(petwall_2nd_cell(target, dir)) and empty_cell(petwall_3rd_cell(target, dir)) then
			return dir -- нашли подходящее направление
		end
	end
	return idir -- ???
end

function petwall_highlight()

	local target = Attack.get_target()
	Attack.cell_select(target, "destination")
	local dir = correct_wall_dir(target, Attack.direction())
	Attack.cell_select(petwall_2nd_cell(target, dir), "destination")
	Attack.cell_select(petwall_3rd_cell(target, dir), "destination")
	return true

end

function pet_wall()

	local target = Attack.get_target()
	local dir = correct_wall_dir(target, Attack.direction())
	local ang = Game.Dir2Ang(dir) + math.rad(90)

	local startpos,startdir = Attack.get_spirit_cell()
------------------------ camera block --------------
	local photo = Attack.photogenic(target)

	if (Game.ArenaShape() ~= 5) or (Game.ArenaShape() ~= 2) then
	  if math.random(100) < 80 then
	    if photo == 1 then
              Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg_calm.track" )
	    end
	    if photo == 0 then
	      if Game.ArenaShape() ~= 1 then
		if math.random(100) < 50 then
	          Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg_calm.track" )
		else
		  Attack.cam_track(0, 34, 57, 0, target, "cam_pet_attack_alienegg.track" )
		end
	      end
	    end
	  end
	end
------------------------ end of camera -------------

	Attack.act_aseq( 0, "attack_petwall" )
	Attack.act_rotate( Attack.aseq_time(0,"rs1"), Attack.aseq_time(0,"re1"), 0, target )
	Attack.act_move  ( Attack.aseq_time(0,"ms1"), Attack.aseq_time(0,"me1"), 0, target )
	Attack.act_rotate( Attack.aseq_time(0,"rs2"), Attack.aseq_time(0,"re2"), 0, ang )
	Attack.act_rotate( Attack.aseq_time(0,"rs3"), Attack.aseq_time(0,"re3"), 0, Attack.angleto(0, target) )
	Attack.act_move  ( Attack.aseq_time(0,"ms2"), Attack.aseq_time(0,"me2"), 0, startpos )
	Attack.act_rotate( Attack.aseq_time(0,"rs4"), Attack.aseq_time(0,"re4"), 0, startdir )

	local spawnwall = Attack.aseq_time(0,"spawnwall")
	local wall=Attack.atom_spawn(target, spawnwall, "petwall", ang)
	Attack.act_aseq(wall, "appear")
	Attack.aseq_timeshift(wall, spawnwall)

	local health = tonumber( "0" .. Attack.get_custom_param("health") )
	-- local ttl = tonumber( "0" .. Attack.get_custom_param("ttl") )
	Attack.act_hp( wall, health )
	Attack.act_set_par( wall, "health", health )
	Attack.act_set_par( wall, "defense", tonum(Attack.get_custom_param("defense")) )
	-- Attack.val_store( wall, "moves", ttl )
	Attack.log_label("use_pet_wall_")
    pet_after_hit()

	return true

end
