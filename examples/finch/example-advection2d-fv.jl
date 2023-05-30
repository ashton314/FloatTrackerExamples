#=
2D advection using higher order FV or structured or unstructured mesh
=#

### If the Finch package has already been added, use this line #########
using Finch # Note: to add the package, first do: ]add "https://github.com/paralab/Finch.git"

using Dates
using FloatTracker: TrackedFloat64, write_log_to_file, set_injector_config!, set_logger_config!, set_exclude_stacktrace!, enable_injection_recording!, FunctionRef

set_logger_config!(filename="adv2d", buffersize=20, cstg=true, cstgArgs=false, cstgLineNum=true)
fns::Array{FunctionRef} = [] ##[FunctionRef(:run_simulation, Symbol("nbody_simulation_result.jl"))]
libs::Array{String} = [] ##["NBodySimulator", "OrdinaryDiffEq"]
now_str = Dates.format(now(), "yyyymmddHHMMss")
recording_file = "adv2d_recording_$now_str"
println("Recording to $recording_file...")
set_exclude_stacktrace!([:prop])
set_injector_config!(odds=2, n_inject=1, functions=fns, libraries=libs)
enable_injection_recording!(recording_file)

### If not, use these four lines (working from the examples directory) ###
# if !@isdefined(Finch)
#     include("../Finch.jl");
#     using .Finch
# end
##########################################################################

initFinch("FVadvection2d", TrackedFloat64);
useLog("FVadvection2dlog", level=3)

# Configuration setup
domain(2)
solverType(FV)

#timeStepper(EULER_IMPLICIT)
# original timestepper

timeStepper(EULER_EXPLICIT,cfl=20000)
# NaN-making timestepper

use_unstructured=false;
if use_unstructured
    # Using an unstructured mesh of triangles or irregular quads
    # This is a 0.1 x 0.3 rectangle domain
    mesh("src/examples/utriangle.msh")
    mesh("src/examples/uquad.msh")

    add_boundary_ID(2, (x,y) -> (x >= 0.1));
    add_boundary_ID(3, (x,y) -> (y <= 0));
    add_boundary_ID(4, (x,y) -> (y >= 0.3));

else
    # a uniform grid of quads on a 0.1 x 0.3 rectangle domain
    mesh(QUADMESH, elsperdim=[15, 45], bids=4, interval=[0, 0.1, 0, 0.3])
end

# Variables and BCs
u = variable("u", location=CELL)
boundary(u, 1, FLUX, "(abs(y-0.06) < 0.033 && sin(3*pi*t)>0) ? 1 : 0") # x=0
boundary(u, 2, NO_BC) # x=0.1
boundary(u, 3, NO_BC) # y=0
boundary(u, 4, NO_BC) # y=0.3

# Time interval and initial condition
#T = 1.3;
T=200
timeInterval(T)
initial(u, "0")

# Coefficients
coefficient("a", ["0.1*cos(pi*x/2/0.1)","0.3*sin(pi*x/2/0.1)"], type=VECTOR) # advection velocity
coefficient("s", ["0.1 * sin(pi*x)^4 * sin(pi*y)^4"]) # source

# The "upwind" function applies upwinding to the term (a.n)*u with flow velocity a.
# The optional third parameter is for tuning. Default upwind = 0, central = 1. Choose something between these.
conservationForm(u, "s + surface(upwind(a,u))");

#exportCode("fvad2dcodeout") # uncomment to export generated code to a file
# importCode("fvad2dcode") # uncomment to import code from a file

solve(u)

# outputValues(u, "fvad2d", format="vtk");

finalizeFinch()

###### Uncomment below to plot
#
## xy = Finch.fv_info.cellCenters
#
## using Plots
## pyplot();
## display(plot(xy[1,:], xy[2,:], u.values[:], st=:surface))

write_log_to_file()
