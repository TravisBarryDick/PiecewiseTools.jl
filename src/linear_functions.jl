import Base: +, -

"""
Represents linear functions mapping real numbers to real numbers. Each has
an `intercept` and a `slope`. They can be evaluated as functions, added, and
subtracted.
"""
struct LinearFunction
    intercept::Float64
    slope::Float64
end

"Evaluates the linear function `lf` at the point `x`."
(lf::LinearFunction)(x::Number) = return lf.intercept + x*lf.slope


@enum IntersectionKind everywhere nowhere atpoint

struct LinearIntersection
    kind::IntersectionKind
    location::Float64
end

LinearIntersection(kind::IntersectionKind) = LinearIntersection(kind, NaN)

"Finds the intersection of two linear functions."
function intersectionof(f::LinearFunction, g::LinearFunction)
    if abs(f.slope - g.slope) < 1e-10
        if abs(f.intercept - g.intercept) < 1e-10
            return LinearIntersection(everywhere)
        else
            return LinearIntersection(nowhere)
        end
    end
    location = (g.intercept - f.intercept) / (f.slope - g.slope)
    return LinearIntersection(atpoint, location)
end

function +(lfs::Vararg{LinearFunction})
    intercept = sum(lf.intercept for lf in lfs)
    slope = sum(lf.slope for lf in lfs)
    LinearFunction(intercept, slope)
end

function -(a::LinearFunction, b::LinearFunction)
    LinearFunction(a.intercept - b.intercept, a.slope - b.slope)
end
