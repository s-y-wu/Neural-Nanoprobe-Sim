"Simulation Controls"
const NUMBER_OF_WALKS = 1000
const MAX_STEPS_PER_WALK = 3*1485604
const FLOW_OFF = false
const THICK_ENZ = true  # thin enzyme == false

"Solvent Diffusion Step Sizes (microns per 2.7 microseconds)"
const SECONDS_PER_STEP = 0.0000027077
const WATER_STEP_SIZE = 0.1
const PPD_STEP_SIZE = 0
# varying "enz" step size
global STEP_SIZE_DICT = Dict("water" => WATER_STEP_SIZE, "enz" => 0.005, "ppd" => 0)
global ENZ_STEP_SIZE = 0.005

"Sensor/Walls Coordinates"
const SENSOR_HALF_WIDTH = 0.5 * 280
const WALL_Y = 0

"Enzyme Layer Dimensions"
const ENZYME_RIGHT_X = 150
const ENZYME_LEFT_X = -150
if THICK_ENZ    # thin wall 0.2, thick wall 2
    const ENZYME_MAX_Y = 2
    const ENZYME_MAX_Y_FROM_WALL = 2
else
    const ENZYME_MAX_Y_FROM_WALL = 0.2
    const ENZYME_MAX_Y = 0.2
end


"Spawn Inside Enzyme Layer"
const BORDER_CORRECTION = 0.001
const SPAWN_LEFT_X = ENZYME_LEFT_X + BORDER_CORRECTION
const SPAWN_RIGHT_X = ENZYME_RIGHT_X - BORDER_CORRECTION
const SPAWN_ENZYME_MAX_Y = ENZYME_MAX_Y - BORDER_CORRECTION

"Enzyme-Water Corners"
const CORNER_CUT_IN_ENZ = sqrt(2) * ENZ_STEP_SIZE
const CORNER_CUT_IN_WATER = sqrt(2) * WATER_STEP_SIZE
# test set: locationbools here
const WATER_TO_ENZ_NORTHEAST = [ENZYME_RIGHT_X - CORNER_CUT_IN_ENZ, ENZYME_MAX_Y - CORNER_CUT_IN_ENZ]
const WATER_TO_ENZ_NORTHWEST = [ENZYME_LEFT_X + CORNER_CUT_IN_ENZ, ENZYME_MAX_Y - CORNER_CUT_IN_ENZ]
const ENZ_TO_WATER_NORTHEAST = [ENZYME_RIGHT_X + CORNER_CUT_IN_WATER, ENZYME_MAX_Y + CORNER_CUT_IN_WATER]
const ENZ_TO_WATER_NORTHWEST = [ENZYME_LEFT_X - CORNER_CUT_IN_WATER, ENZYME_MAX_Y + CORNER_CUT_IN_WATER]

"Escape Bound Limits"
const ESCAPE_X = 3 * ENZYME_RIGHT_X
const ESCAPE_Y = ESCAPE_X

"Safe Bound Limits"
const MARGIN_OF_COLLISION = 2 * WATER_STEP_SIZE
const SAFE_MIN_Y = ENZYME_MAX_Y + MARGIN_OF_COLLISION
const SAFE_MAX_Y = ESCAPE_Y - MARGIN_OF_COLLISION
const SAFE_MAX_X = ESCAPE_X - MARGIN_OF_COLLISION