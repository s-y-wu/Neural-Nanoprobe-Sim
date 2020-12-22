"true when inside parylene walls"
function inwalls(x::Float64, y::Float64)::Bool
    withinx = !incentersensorx(x) && !ininnersensorx(x) && !inoutersensorx(x)
    withiny = y <= WALL_Y
    return withinx && withiny
end

"true when outside sensors ppd and enzyme layers"
function inwater(xy::Array{Float64,1})::Bool
    x, y = xy
    inadjacentwell = PPD_MAX_Y < y <= WALL_Y && (ininnersensorx(x) || inoutersensorx(x))
    inwaterabovewalls = y > WALL_Y && inescapebounds(x, y) && !inoverflowenz(x, y)
    return inadjacentwell || inwaterabovewalls
end

function inenz(xy::Array{Float64,1})::Bool
    x, y = xy
    if PPD_MAX_Y < y <= WALL_Y
        return incentersensorx(x)
    else
        return inoverflowenz(x, y)
    end
end

"true when inside the 150 nm thick layer of m-phenylendiamine (PPD) on each sensor pads"
function inppd(xy::Array{Float64,1})::Bool
    x,y = xy
    withinx = incentersensorx(x) || ininnersensorx(x) || inoutersensorx(x)
    withiny = PPD_MIN_Y < y <= PPD_MAX_Y
    return withinx && withiny
end


function inoverflowenz(x::Float64, y::Float64)::Bool
    withinx = ENZYME_LEFT_X <= x <= ENZYME_RIGHT_X
    withiny = WALL_Y < y <= ENZYME_MAX_Y
    return withinx && withiny
end

function incentersensorx(x::Float64)::Bool
    return abs(x) < SENSOR_CENTER_MAX_X
end

function ininnersensorx(x::Float64)::Bool
    return SENSOR_INNER_ADJ_MIN_X < abs(x) < SENSOR_INNER_ADJ_MAX_X
end

function inoutersensorx(x::Float64)::Bool
    return SENSOR_OUTER_ADJ_MIN_X < abs(x) < SENSOR_OUTER_ADJ_MAX_X
end

function insensor(xy::Array{Float64,1})::Bool
    y = xy[2]
    return y <= 0
end

function sensorcases(initx::Float64)::String
    if incentersensorx(initx)
        return "center sensor"
    elseif initx < 0
        position = "left"
    else
        position = "right"
    end

    if ininnersensorx(initx)
        return position * " inner sensor"
    elseif inoutersensorx(initx)
        return position * " outer sensor"
    else
        println("sensorCases error ", initx)
        return "sensorCases error"
    end
end

function wallcases(initxy::Array{Float64,1},
                   dx::Float64,
                   dy::Float64,
                   ending_step_size::Float64)
    if !CATALASE_ON_WALLS
        return approach_wall!(initxy, dx, dy, ending_step_size), "no collision"
    end

    if sortwall(initxy) == "side wall"
        return approach_wall!(initxy, dx, dy, ending_step_size), "side wall"
    else
        return undef, "top wall"
    end
end

function sortwall(initxy::Array{Float64,1})::String
    initx, inity = initxy
    if inity <= WALL_Y      # from between walls
        return "side wall"
    elseif inity > WALL_Y   # from above walls
        if incenterwallsx(initx)
            return "top wall"
        elseif ininnerwallsx(initx)
            return "top wall"
        elseif inouterwallsx(initx)
            return "top wall"
        end
    end
    # ambiguous corner case:
    #   in sensor region, above wall height -- coinflip
    if rand(Float64) > 0.5
        return "side wall"
    else
        return "top wall"
    end
end
