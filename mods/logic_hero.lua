function scn_hero_magic ( param )
    if (param == nil) then
      Scenario.animate("magic","magic")
      Scenario.playcamtrack("bigfishship_free.track", 60)
    elseif (param == "magic") then
        return true
    end
    return false
end
function scn_hero_cast ( param )
    if (param == nil) then
      Scenario.stop( true )
      Scenario.animate("cast","cast")
    elseif (param == "cast") then
        return true
    end
    return false
end

function scn_hero_stop ( param )

    if (param == nil) then

        Scenario.stop()
        Scenario.delay( 1, "hero_000" )

    elseif (param == "hero_000") then
        return true
    end

    return false
end

function scn_hero_takebox ( param )

    Scenario.stop()
    return true
end

function scn_hero_entercastle ( param )

    Scenario.stop()
    return true
end

function scn_hero_enterboat ( param )

    Scenario.stop()
    return true

end

function scn_hero_teleport1 ( param )

    local teletarget = "dev_map_0.start"

    if (param == nil) then

      -- начнемс...
      Scenario.formsolo( "map" )         -- оставить только map интерфейс
      Scenario.delay( 0.1, "hero_001" )  -- подождать 0.1 сек

    elseif (param == "hero_001") then

      -- подождали. продолжаем....
      if not Atom.is_onboat() then
        Scenario.animate("telein","hero_002")  -- анимация ухода в иную реальность
      else
        Scenario.teleport( teletarget, "hero_003" ) -- реально перерубаем локацию
      end

    elseif (param == "hero_002") then
      -- анимация завершена
      Scenario.teleport( teletarget, "hero_003" ) -- реально перерубаем локацию

    elseif (param == "hero_003") then

      Scenario.animate("teleout","hero_004")  -- анимация выхода из телепорта

    elseif (param == "hero_004") then
        -- анимация завершена, больше делать нечего
        return true
    end

    return false
end

function hero_scenario ( scn, param ) --ftag:mascn

    local scenario_handlers = {
        stop = scn_hero_stop,
        hero_cast = scn_hero_cast,
        hero_magic = scn_hero_magic,
        takebox = scn_hero_takebox,
        entercastle = scn_hero_entercastle,
        enterboat = scn_hero_enterboat,
        teleport1 = scn_hero_teleport1
    }

    local f = scenario_handlers[ scn ]

    if (f ~= nil) then
        return f(param)
    end

end

function from_big_fish () --ftag:action

  Game.GVStr("afterswitch", "hero_magic")
  return false

end


-- изменение маны я ярости
function change_manarage (event) --ftag:action

  local max_rage = Logic.cur_lu_item( "rage", "limit" )
  local rage = Logic.cur_lu_item( "rage", "count" )
  local sk_level = Logic.hero_lu_skill("blood_lust")
  local rage_min = 0
  if sk_level > 0 then
    rage_min = math.floor(skill_power("blood_lust", 1, sk_level-1)*max_rage/100)
  end

  if event == "" then
    local diff = Game.HSP_difficulty()
    local par_mana = Game.Config("difficulty_k/manarage")
    local par_rage = Game.Config("difficulty_k/manarage")
    par_mana = string.gsub(par_mana, "|", ",")
    par_rage = string.gsub(par_rage, "|", ",")
    local k_mana_dif = tonumber(text_dec(par_mana, diff+1))
    local k_rage_dif = tonumber(text_dec(par_rage, diff+1))
    local max_mana = Logic.cur_lu_item( "mana", "limit" )
    local mana = Logic.cur_lu_item( "mana", "count" )
    local mana_add = 5   --сколько давать за период в % от максимума
    local rage_sub = 5   --сколько отнимать за период в % от максимума
  -- бонус от навыка и предметов, в % на который домножим mana_add
    local skill_bonus = Logic.hero_lu_item("sp_mana_map_prc", "count") -- бонус от предметов
    local skill_lvl_count = tonumber(Logic.hero_lu_skill("meditation"))
    if skill_lvl_count > 0 then -- пока не взято умение Медитация, прибавок от умений нет
      skill_lvl_count = skill_lvl_count + tonumber(Logic.hero_lu_skill("wizdom")) + tonumber(Logic.hero_lu_skill("linguistic")) + tonumber(Logic.hero_lu_skill("order")) + tonumber(Logic.hero_lu_skill("alchemist")) + tonumber(Logic.hero_lu_skill("dist")) + tonumber(Logic.hero_lu_skill("rune")) + tonumber(Logic.hero_lu_skill("transmutate")) + tonumber(Logic.hero_lu_skill("chaos")) + tonumber(Logic.hero_lu_skill("accuracy")) + tonumber(Logic.hero_lu_skill("initiation")) + tonumber(Logic.hero_lu_skill("concentration")) + tonumber(Logic.hero_lu_skill("creator")) + tonumber(Logic.hero_lu_skill("hi_magic")) + tonumber(Logic.hero_lu_skill("destroyer"))
      skill_bonus = skill_bonus + skill_power("meditation", 1) + skill_power("meditation", 3)*skill_lvl_count
    end

    if rage > rage_min then
      local tmp_rage = max_rage*(rage_sub/100)*(1-Logic.hero_lu_item("sp_rage_map", "count")/100)/k_rage_dif
      if tmp_rage < 1 then
        tmp_rage = 1
      end
      rage = rage - tmp_rage
      if rage < 0 then
        rage = 0
      end
    end
    --if mana < max_mana then
      local tmp_mana = (max_mana*(mana_add/100)*(1 + skill_bonus/100) + Logic.hero_lu_item("sp_mana_map_val", "count"))*k_mana_dif
      if rage == 0 then
        tmp_mana = tmp_mana * Game.Config("mana_gain_k_when_no_rage")
      end
      if tmp_mana < 1 then
        tmp_mana = 1
      end
      local new_mana = mana + tmp_mana
      if new_mana > max_mana then
        new_mana = max_mana
      end
      Logic.cur_lu_item( "mana", "count", new_mana)
      Game.ClearEffect( "mana" )
    --end
  end
  Logic.cur_lu_item( "rage", "count", math.max(rage, rage_min) )
  Game.ClearEffect( "rage" )

  return false
end

function decrease_rage () --ftag:action
  local rage = Logic.cur_lu_item( "rage", "count" )
  if rage > 0 then
    rage = rage - 1
    Logic.cur_lu_item( "rage", "count", rage )
    Game.ClearEffect( "rage" )
  end

  return false
end

function increase_mana () --ftag:action
  local mana_add = 1   --сколько давать за период
  local time_period = 10  -- на сколько периодов делится минута

  local max_mana = Logic.cur_lu_item( "mana", "limit" )
  local mana = Logic.cur_lu_item( "mana", "count" )
  if mana < max_mana then
    local skill_bonus = 0
    local skill_lvl_count = tonumber(Logic.hero_lu_skill("meditation"))
    if skill_lvl_count > 0 then -- пока не взято умение Медитация, прибавок от умений нет
      skill_lvl_count = skill_lvl_count + tonumber(Logic.hero_lu_skill("wizdom")) + tonumber(Logic.hero_lu_skill("linguistic")) + tonumber(Logic.hero_lu_skill("meditation")) + tonumber(Logic.hero_lu_skill("order")) + tonumber(Logic.hero_lu_skill("alchemist")) + tonumber(Logic.hero_lu_skill("dist")) + tonumber(Logic.hero_lu_skill("rune")) + tonumber(Logic.hero_lu_skill("transmutate")) + tonumber(Logic.hero_lu_skill("chaos")) + tonumber(Logic.hero_lu_skill("accuracy")) + tonumber(Logic.hero_lu_skill("initiation")) + tonumber(Logic.hero_lu_skill("concentration")) + tonumber(Logic.hero_lu_skill("creator")) + tonumber(Logic.hero_lu_skill("hi_magic")) + tonumber(Logic.hero_lu_skill("destroyer"))
      skill_bonus = skill_power("meditation", 1) + skill_power("meditation", 3)*skill_lvl_count
      if skill_bonus == nil then
        skill_bonus = 0
      end
    end
    mana = mana + skill_bonus/time_period + mana_add
    Logic.cur_lu_item( "mana", "count", mana )
    Game.ClearEffect( "mana" )
  end

  return false
end


function restore_mana () --ftag:action


  local max_mana = Logic.hero_lu_item( "mana", "limit" )
  Logic.hero_lu_item( "mana", "count", max_mana  )

  return false

end

function set_hero_rank ( varname ) --ftag:vv

    local HR = "<label=hero_rank_"
    local c =  Logic.cur_lu_var( "hrank" )

    HR=HR..c..">"

    return HR

end

function gen_hero_class()

  local hclass = Game.HSP_class()
  if hclass == nil or hclass < 0 then
    hclass = 0
  end

  local hero = Game.Config("heroclasses/" .. tostring(hclass) )

  return "<label=hero_class_" .. hero .. ">"
end

function hero_rebirth(par) --ftag:action

  local hclass = Game.HSP_class()
  if hclass == nil or hclass < 0 then
    hclass = 0
  end

  local hero = Game.Config("heroclasses/" .. tostring(hclass) )
  local hero_cfg="hero_"..hero
  local army = Game.Config(hero_cfg.."/start/army")

  Logic.hero_lu_army( army )

  return false
end

function add_hero_spell(path, spellname, spellparam)
  if spellparam ~= nil then
    local level = tonumber( spellparam )
    if level < 0 then
      Logic.hero_add_spell( spellname, 0, -level )
    else
      Logic.hero_add_spell( spellname, level )
    end
  end
  return true
end

function add_hero_item(path, itemname, countpar)
  if countpar ~= nil then
    local count = tonumber( countpar )
    Logic.hero_add_item( itemname, count )
  end
  return true
end

rune_war={"6,4,2","5,5,2","6,3,3","7,4,1"}
rune_pal={"3,6,3","2,7,3","3,5,4","4,6,2"}
rune_mag={"2,4,6","1,5,6","2,3,7","3,4,5"}

function generation_hero(par) --ftag:action

  Game.GVNum("game",1)

  local hclass = Game.HSP_class()
  if hclass == nil or hclass < 0 then
    hclass = 0
  end

  Game.CutScene( "mega_epic_intro" )

  local hero = Game.Config("heroclasses/" .. tostring(hclass) )

  if par ==nil or par == "" then hero = par end
  local hero_cfg="hero_"..hero
  Logic.hero_lu_var("class",hclass)
  Logic.hi_slots( hero_cfg.."/slots" )

  local   leadership=tonumber(Game.Config(hero_cfg.."/start/leadership"))
  local   attack=tonumber(Game.Config(hero_cfg.."/start/attack"))
  local   defense=tonumber(Game.Config(hero_cfg.."/start/defense"))
  local   intellect=tonumber(Game.Config(hero_cfg.."/start/intellect"))
  local   mana=tonumber(Game.Config(hero_cfg.."/start/mana"))
  local   rage=tonumber(Game.Config(hero_cfg.."/start/rage"))
  local   gold=tonumber(Game.Config(hero_cfg.."/start/gold"))
  local   crystals=tonumber(Game.Config(hero_cfg.."/start/crystals"))
  local   rune_might=tonumber(Game.Config(hero_cfg.."/start/rune_might"))
  local   rune_mind=tonumber(Game.Config(hero_cfg.."/start/rune_mind"))
  local   rune_magic=tonumber(Game.Config(hero_cfg.."/start/rune_magic"))
  local   book=tonumber(Game.Config(hero_cfg.."/start/book"))

  local rindex=Game.Mutate(table.getn(rune_war)-1)+1 -- индекс начала выдачи рун
  local rside=Game.Mutate(2) -- направление отсчета
  Logic.hero_lu_var("rindex",rindex)
  Logic.hero_lu_var("rside",rside)

  local diff = Game.HSP_difficulty()
  local function diff_k(par)
    return tonumber(text_dec(Game.Config('difficulty_k/'..par), diff+1, '|'))
  end
  local start_gold=diff_k("start_gold")
  local start_crystals=diff_k("start_crystals")
  local start_mana=diff_k("start_mana")
  local start_rage=diff_k("start_rage")
  local start_rune_might=diff_k("start_rune_might")
  local start_rune_mind=diff_k("start_rune_might")
  local start_rune_magic=diff_k("start_rune_magic")
  local start_book=diff_k("start_book")

  gold=math.ceil(gold*start_gold)
  crystals=math.ceil(crystals*start_crystals)
  mana=math.ceil(mana*start_mana)
  rage=math.ceil(rage*start_rage)
  rune_might=math.ceil(rune_might*start_rune_might)
  rune_mind=math.ceil(rune_mind*start_rune_mind)
  rune_magic=math.ceil(rune_magic*start_rune_magic)
  book=math.ceil(book*start_book)

--    if diff==0 then -- легкий уровень
--       gold=gold*5
--        crystals=crystals*5
--        mana=math.ceil(mana*1.5)
--        rage=math.ceil(rage*1.5)
--        rune_might=rune_might+8
--        rune_mind=rune_mind+8
--        rune_magic=rune_magic+8
--        book=math.ceil(book*2)
--    end
--    if diff==1 then -- нормальный уровень
--        gold=gold*2
--        crystals=crystals*2
--        mana=math.ceil(mana*1.25)
--        rage=math.ceil(rage*1.25)
--        rune_might=rune_might+2
--        rune_mind=rune_mind+2
--        rune_magic=rune_magic+2
--        book=math.ceil(book*1.5)
--    end

  Logic.hero_lu_item("money","count",gold)
  Logic.hero_lu_item("leadership","count",leadership)
  Logic.hero_lu_item("attack","count",attack)
  Logic.hero_lu_item("defense","count",defense)
  Logic.hero_lu_item("intellect","count",intellect)
  Logic.hero_lu_item("mana","limit",mana)
  Logic.hero_lu_item("mana","count",mana)
  Logic.hero_lu_item("rage","limit",rage)
  Logic.hero_lu_item("rage","count",0)
  Logic.hero_lu_item("crystals","count",crystals)
  Logic.hero_lu_item("rune_mind","count",rune_mind)
  Logic.hero_lu_item("rune_might","count",rune_might)
  Logic.hero_lu_item("rune_magic","count",rune_magic)
  Logic.hero_lu_item("booksize","count",book)

  local army = Game.Config(hero_cfg.."/start/army")
  Logic.hero_lu_army( army )

  Game.ConfigEnum(hero_cfg.."/start/spells", "add_hero_spell")
  Game.ConfigEnum(hero_cfg.."/start/items", "add_hero_item")

  -- apply skill after! params
  local skill_off=Game.Config(hero_cfg.."/start/skills_off")
  local skill_off_count=text_par_count(skill_off)
  for i=1,skill_off_count do
      Logic.hero_lu_skill(text_dec(skill_off,i),-1)
  end
  local skill_on=Game.Config(hero_cfg.."/start/skills_open")
  local skill_on_count=text_par_count(skill_on)
  for i=1,skill_on_count do
      Logic.hero_lu_skill(text_dec(skill_on,i),1)
  end

  return false
end

-- Повышение уровня героя
function calc_levelup()

  local hclass = Game.HSP_class()
  if hclass == nil or hclass < 0 then
    hclass = 0
  end
  local hero = Game.Config("heroclasses/" .. tostring(hclass) )
  local hero_cfg="hero_"..hero
  local level=tonumber(Logic.hero_lu_var("level"))
  local leadership=tonumber(text_dec(Game.Config(hero_cfg.."/level_up/leadership"),1))

   local   book=tonumber(text_dec(Game.Config(hero_cfg.."/level_up/book"),1))
   local   book_rnd=tonumber(text_dec(Game.Config(hero_cfg.."/level_up/book"),2))

    if math.mod(level+1,book_rnd)==0 then Levelup.add( 0, "booksize", book ) end

-- новый способ выдаи рун
  local max_var=table.getn(rune_war)

        local rindex=Logic.hero_lu_var("rindex")
        if rindex==nil or rindex=="" then
            rindex=Game.Mutate(table.getn(rune_war)-1)+1
        else
          rindex=tonumber(rindex)
        end
    local rside=Logic.hero_lu_var("rside") -- 0 <- назад, 1 -> вперед
        if rside==nil or rside=="" then
            rside=Game.Mutate(2)
            Logic.hero_lu_var("rside",rside)
        else
         rside=tonumber(rside)
        end


    local   might,mind,magic=0,0,0
    local tmp_mas

    if hclass==0 then
         tmp_mas=rune_war
         if Game.HSP_difficulty()==0 then
           might=might+1
         end
    end
    if hclass==1 then
         tmp_mas=rune_pal
         if Game.HSP_difficulty()==0 then
           mind=mind+1
         end
    end
    if hclass==2 then
         tmp_mas=rune_mag
         if Game.HSP_difficulty()==0 then
           magic=magic+1
         end
    end
    
    if rindex > max_var then rindex = max_var end

    might=might+tonumber(text_dec(tmp_mas[rindex],1))
    mind=mind+tonumber(text_dec(tmp_mas[rindex],2))
    magic=magic+tonumber(text_dec(tmp_mas[rindex],3))

    if level > 50 then
      might=math.floor(might/2)
      mind=math.floor(mind/2)
      magic=math.floor(magic/2)
    end 
    
    if rside==0 then
        rindex=rindex-1
    else
        rindex=rindex+1
    end
    if rindex==0 then
        rindex=max_var
    end
    if rindex>(max_var) then
        rindex=1
    end
    Logic.hero_lu_var("rindex",rindex)
	
	 ------------------------------------
    -- корона совершенства
    local rune_lvl_up_bonus = hero_item_count("sp_levelup_rune_bonus","count")
    if rune_lvl_up_bonus > 0 then
      while rune_lvl_up_bonus > 0 do
        local rnd = Game.Random(100)
        --if rnd <= 33 t
        if rnd <= 33 then might = might + 1 end
        if rnd > 33 and rnd <= 66 then mind = mind + 1 end
        if rnd > 66 then magic = magic + 1 end
        rune_lvl_up_bonus = rune_lvl_up_bonus - 1
      end
    end
    ------------------------------------

  Levelup.add( 0, "rune_might", might )
  Levelup.add( 0, "rune_mind", mind )
  Levelup.add( 0, "rune_magic", magic )
   -- add items to left button

  if level < 51 then
    Levelup.add( 0, "leadership", leadership*(level))
  else
    Levelup.add( 0, "leadership", leadership*25)
  end 
  return false
end

function diap(str,instr,par)

  local number=text_par_count(str)
  local sum=0
  local result1=0
  local result2=0
  for i=1,number do
    sum=sum+tonumber(text_dec(str,i))
  end
  local level=tonumber(Logic.hero_lu_var("level"))
    local rnd=0
    if par==nil then
        rnd=math.floor(Game.Random(1,sum+0.45))
    end
    if par=="box" then
    rnd=Game.Mutate(sum,par)+1
  end
  if par~=nil and par~="box" then
    rnd=Game.Mutate(sum,par)+1
  end

  local tmp=0

  for i=1,number do
    if rnd > tmp and rnd <=(tmp+tonumber(text_dec(str,i))) then
        result1 = i
        break
    else
        tmp=tmp+tonumber(text_dec(str,i))
    end
  end

  if instr==nil or instr==0 then
    return result1
  else
--      local dec=text_dec(str,result1)
    str=text_replace(str,result1,0)
        local number=text_par_count(str)

      local sum=0
      for i=1,number do
        sum=sum+tonumber(text_dec(str,i))
    end

    local rnd=Game.Mutate(sum,par,sum)+1
    local tmp=0

    for i=1,number do
        if rnd > tmp and rnd <=(tmp+tonumber(text_dec(str,i))) and number~=0 then
            result2 = i
            break
        else
            tmp=tmp+tonumber(text_dec(str,i))
        end
    end

    return result1,result2
  end

  return sum
end

function gen_diap()
    local res1,res2 = diap("10,25,20,20,43,50,45,10",1)
    --local rnd=Game.Random(5,10)--math.floor(Game.Random(5,10))

    return res1.."-"..res2

end

function text_replace(str,num,repl)
    local number=text_par_count(str)
    local result=""
    if text_instr(str) then result=result..text_dec(str,0).."=" end
    for i=1,number do
        if i==num then
            result=result..repl
        else
            result=result..text_dec(str,i)
        end
        if i~=number then result=result.."," end
    end

    return result
end

function com_gold_calc() --ftag:vv

    local k=tonumber(Game.Config("companion_gold_k"))
    local gold = tonumber(Logic.hero_lu_item("money","count"))

    return tostring(math.floor(gold*k/100))

end

function hero_companion_compensation () --ftag:action

    local k=tonumber(Game.Config("companion_gold_k"))
    local gold = tonumber(Logic.hero_lu_item("money","count"))

    Logic.hero_lu_item("money","count", math.floor(gold*(100-k)/100))
    return false

end

function demonis_visited () --ftag:action

  Game.GVNum("demonis_visited", 1)
  return true;

end

function add_rare_item( name )
	Game.AddRareItem( name )
	return true;
end