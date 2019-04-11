insightModule = {}

local emptyList = {}
setmetatable(emptyList, {['__type']='slice'})

local function splitter(input, delim)
  local t = {}
  for str in string.gmatch(input, "([^"..delim.."]+)") do
    table.insert(t, str)
  end
  return t
end

function insightModule.healthSwitch(body)
  local dataIN = body.data
  local constants = body.args.constants
  local data_out_ids = splitter(body.args.constants.data_out_ids, ",")
  local data_out_value
  local dataOUT = {}

-- dataIN is a list of datapoints
  for _, dp in pairs(dataIN) do

    local channel_map = splitter(dp.origin, ".")
    local serial_number = channel_map[2]
    
    for _, dp in pairs(dataIN) do
      healthSwitch = 0
      if dp.value > constants.threshold then
        healthSwitch = 1
      end
      dp.value = healthSwitch
      table.insert(dataOUT, dp)
    end

    if healthSwitch ~= nil then
      data_out_payload = {}
      for _, id in pairs(data_out_ids) do
        data_out_payload[id] = healthSwitch
        Gartneriiotdemo.setIdentityState({
          identity=serial_number,
          data_out=to_json(data_out_payload)
        })
      end
    end
    table.insert(dataOUT, dp)
  end
  return dataOUT

end

function insightModule.healthReset(body)
  local dataIN = body.data
  local constants = body.args.constants
  local data_out_ids = splitter(body.args.constants.data_out_ids, ",")
  local data_out_value
  local dataOUT = {}

-- dataIN is a list of datapoints
  for _, dp in pairs(dataIN) do

    local channel_map = splitter(dp.origin, ".")
    local serial_number = channel_map[2]
    -- Each signal value in dataOUT should keep the incoming metadata
    if dp.value == true then
      red_light_status = Keystore.get({key="red_light"})
      if tonumber(red_light_status.value) == 1 then 
        print("Turning off the red light")
        -- TURN OFF THE RED LIGHT
        data_out_value = 0
        Keystore.set({ key = "red_light", value = 0 })
      end
    end

    if data_out_value ~= nil then
      data_out_payload = {}
      for _, id in pairs(data_out_ids) do
        data_out_payload[id] = data_out_value
        Gartneriiotdemo.setIdentityState({
          identity=serial_number,
          data_out=to_json(data_out_payload)
        })
      end
    end
    table.insert(dataOUT, dp)
  end
  return dataOUT

end

function insightModule.healthCommand(body)
  local dataIN = body.data
  local constants = body.args.constants
  local data_out_ids = splitter(body.args.constants.data_out_ids, ",")
  local data_out_value
  local dataOUT = {}

  print("DATA IN: \n" .. to_json(dataIN))

-- dataIN is a list of datapoints
  for _, dp in pairs(dataIN) do

    local channel_map = splitter(dp.origin, ".")
    local serial_number = channel_map[2]
    print("DP Value: \n" .. to_json(dp))
    -- Keystore.set({ key = "red_light", value = 0 })
    -- Each signal value in dataOUT should keep the incoming metadata
    if dp.value == 1 then
      red_light_status = Keystore.get({key="red_light"})
      print("red light status: " .. red_light_status.value)
      print("red light type: " .. type(red_light_status.value))
      if tonumber(red_light_status.value) == 0 then 
        print("Turning on the red light")
        -- TURN ON THE RED LIGHT
        data_out_value = 1
        Keystore.set({ key = "red_light", value = 1 })
      end

    end

    if data_out_value ~= nil then

      data_out_payload = {}

      for _, id in pairs(data_out_ids) do
        data_out_payload[id] = data_out_value
        Gartneriiotdemo.setIdentityState({
          identity=serial_number,
          data_out=to_json(data_out_payload)
        })

      end

    end

    table.insert(dataOUT, dp)

  end

  return dataOUT

end

function insightModule.healthStatus(body)
  local dataIN = body.data
  local constants = body.args.constants
  dataOUT = emptyList

  -- healthStatus is 0 when no works is needed
  for _, dp in pairs(dataIN) do
    healthStatus = 0
    if dp.value > constants.threshold then
      -- value is greater than our threshold level
      -- set healthStatus to 1 for service indication
      healthStatus = 1
    end
    dp.value = healthStatus
    table.insert(dataOUT, dp)
  end

  return dataOUT
end

function insightModule.healthScore(body)
  local dataIN = body.data
  dataOUT = emptyList
  for _, dp in pairs(dataIN) do
    if dp.value >= 0.30 then
      healthScore = 0
    elseif dp.value >= 0.20 then
      healthScore = 10
    elseif dp.value >= 0.10 then
      healthScore = 30
    elseif dp.value >= 0.05 then
      healthScore = 50
    elseif dp.value >= 0.01 then
      healthScore = 80
    elseif dp.value >= 0.00 then
      healthScore = 100
    end

    dp.value = healthScore
    table.insert(dataOUT, dp)
  end
  
  return dataOUT
end

function insightModule.healthAction(body)
  local dataIN = body.data
  dataOUT = emptyList
  for _, dp in pairs(dataIN) do
    if dp.value <= 10 then
      -- TODO: Make this a real endpoint and alter the parameters to make sense
      -- TODO: This should actually order a replacement part for something
      -- TODO: How to use the asynchronous mode? Solz or Tilstra
      -- local data = MyCustomService.orderPart({["id"]=dp.tags.pid})
      orderNumber = "010394AD12"
      dp.value = orderNumber
      table.insert(dataOUT, dp)
    end
  end
  
  return dataOUT
end