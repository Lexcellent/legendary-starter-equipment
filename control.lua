local STARTER_ITEMS = {
  {name = "mech-armor", count = 1, quality = "legendary"},
  {name = "construction-robot", count = 300, quality = "normal"},
  {name = "solar-panel-equipment", count = 1, quality = "legendary"},
  {name = "fusion-reactor-equipment", count = 2, quality = "legendary"},
  {name = "battery-mk3-equipment", count = 7, quality = "legendary"},
  {name = "belt-immunity-equipment", count = 1, quality = "legendary"},
  {name = "exoskeleton-equipment", count = 7, quality = "legendary"},
  {name = "personal-roboport-mk2-equipment", count = 5, quality = "legendary"},
  {name = "night-vision-equipment", count = 1, quality = "legendary"},
  {name = "toolbelt-equipment", count = 5, quality = "legendary"},
  {name = "energy-shield-mk2-equipment", count = 14, quality = "legendary"},
  {name = "personal-laser-defense-equipment", count = 14, quality = "legendary"}
}

local RESEARCH_SETTINGS = {
  {
    setting = "legendary-starter-equipment-worker-robot-cargo-level",
    technology = "worker-robots-storage-",
    maximum_level = 3
  },
  {
    setting = "legendary-starter-equipment-worker-robot-speed-level",
    technology = "worker-robots-speed-",
    maximum_level = 6
  }
}

local function ensure_storage()
  storage.granted_players = storage.granted_players or {}
  storage.pending_players = storage.pending_players or {}
end

local function queue_player(player_index)
  ensure_storage()

  if not storage.granted_players[player_index] then
    storage.pending_players[player_index] = true
  end
end

local function apply_configured_research(player)
  local player_settings = settings.get_player_settings(player)

  for _, research in ipairs(RESEARCH_SETTINGS) do
    local configured_level = tonumber(player_settings[research.setting].value) or 0

    for level = research.maximum_level, configured_level + 1, -1 do
      local technology_name = research.technology .. level
      local technology = player.force.technologies[technology_name]

      if technology then
        technology.researched = false
      else
        log("[Legendary Starter Equipment] Missing technology prototype: " .. technology_name)
      end
    end

    for level = 1, math.min(configured_level, research.maximum_level) do
      local technology_name = research.technology .. level
      local technology = player.force.technologies[technology_name]

      if technology then
        technology.researched = true
      else
        log("[Legendary Starter Equipment] Missing technology prototype: " .. technology_name)
      end
    end
  end
end

local function initialize_mod()
  ensure_storage()

  for _, player in pairs(game.players) do
    apply_configured_research(player)
    queue_player(player.index)
  end
end

local function give_item(player, inventory, item)
  if not prototypes.item[item.name] then
    log("[Legendary Starter Equipment] Missing item prototype: " .. item.name)
    player.print({"legendary-starter-equipment.missing-item", item.name})
    return
  end

  local inserted = inventory.insert(item)
  local remaining = item.count - inserted

  if remaining > 0 then
    log("[Legendary Starter Equipment] Main inventory is full; could not insert " .. remaining .. " x " .. item.name)
    player.print({"legendary-starter-equipment.inventory-full", remaining, item.name})
  end
end

local function give_starter_items(player)
  ensure_storage()

  if storage.granted_players[player.index] then
    return true
  end

  if player.controller_type == defines.controllers.cutscene then
    return false
  end

  apply_configured_research(player)

  local inventory = player.get_main_inventory()
  if not inventory then
    return false
  end

  for _, item in ipairs(STARTER_ITEMS) do
    give_item(player, inventory, item)
  end

  storage.granted_players[player.index] = true
  player.print({"legendary-starter-equipment.items-granted"})
  return true
end

script.on_init(initialize_mod)

script.on_configuration_changed(initialize_mod)

script.on_event({defines.events.on_player_created, defines.events.on_cutscene_cancelled}, function(event)
  queue_player(event.player_index)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting_type ~= "runtime-per-user" or not event.player_index then
    return
  end

  for _, research in ipairs(RESEARCH_SETTINGS) do
    if event.setting == research.setting then
      local player = game.get_player(event.player_index)

      if player and player.valid then
        apply_configured_research(player)
      end

      return
    end
  end
end)

script.on_event(defines.events.on_tick, function()
  for player_index in pairs(storage.pending_players) do
    local player = game.get_player(player_index)

    if not player or not player.valid then
      storage.pending_players[player_index] = nil
    elseif give_starter_items(player) then
      storage.pending_players[player_index] = nil
    end
  end
end)
