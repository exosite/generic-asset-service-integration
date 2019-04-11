--#ENDPOINT POST /insights
-- listInsights

local insightsByGroup = {}
local emptyList = {}
setmetatable(emptyList, {['__type']='slice'})

local healthSwitch = {
  id = "healthSwitch",
  name = "Health Switch",
  description = "Switch a flag based on health comparison",
  constants = {
    {
      name = "threshold",
      type = "number"
    },
    {
      name = "data_out_ids",
      type = "string"
    }
  },
  inlets = {
    {
      primitive_type = "NUMERIC",
      description = "Input Signal 1"
    }
  },
  outlets = {
    primitive_type = "NUMERIC"
  }
}

local healthReset = {
  id = "healthReset",
  name = "Reset Health",
  description = "Send command to reset health status",
  constants = {
    {
      name = "data_out_ids",
      type = "string"
    }
  },
  inlets = {
    {
      primitive_type = "NUMERIC",
      description = "Input Signal 1"
    }
  },
  outlets = {
    primitive_type = "NUMERIC"
  }
}

local healthCommand = {
  id = "healthCommand",
  name = "Command Device",
  description = "Send command to notify of health change",
  constants = {
    {
      name = "data_out_ids",
      type = "string"
    }
  },
  inlets = {
    {
      primitive_type = "NUMERIC",
      description = "Input Signal 1"
    }
  },
  outlets = {
    primitive_type = "NUMERIC"
  }
}

local healthStatus = {
  id = "healthStatus",
  name = "Generate Health Status",
  description = "Generate health status from input of data",
  constants = {
    {
      name = "threshold",
      type = "number"
    }
  },
  inlets = {
    {
      data_type = "NUMBER",
      description = "Input"
    }
  },
  outlets = {
    data_type = "NUMBER"
  }
}

local healthScore = {
  id = "healthScore",
  name = "Generate Health Score",
  description = "Generate health score from input of vibration data",
  inlets = {
    {
      data_type = "ACCELERATION",
      data_unit = "METERS_PER_SEC2",
      description = "Vibration of asset"
    }
  },
  outlets = {
    data_type = "PERCENTAGE",
    data_unit = "PERCENT"
  }
}

local healthAction = {
  id = "healthAction",
  name = "Generate Health Action",
  description = "Generate health action from input of health score",
  inlets = {
    {
      data_type = "PERCENTAGE",
      data_unit = "PERCENT",
      description = "Health score percentage"
    }
  },
  outlets = {
    data_type = "STRING"
  }
}

functions = {healthSwitch, healthReset, healthCommand, healthStatus, healthScore, healthAction}

local count = table.getn(functions)
local total = table.getn(functions)

return {
  count = count,
  total = total,
  insights = functions
}