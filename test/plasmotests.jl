module PlasmoTests

using Plasmo

const PLASMO_MODEL = Dict()

PLASMO_MODEL[1] = function ()
    graph = OptiGraph()

    #Add nodes to graph
    n1 = @optinode(graph)
    n2 = @optinode(graph)

    #Node 1 Model
    @variable(n1,0 <= x <= 2)
    @variable(n1,0 <= y <= 3)
    @variable(n1, z >= 0)
    @constraint(n1,x+y+z >= 4)
    @objective(n1,Min,y+z)

    #Node 2 Model
    @variable(n2,x)
    @variable(n2,z >= 0)
    @constraint(n2,z + x >= 4)
    @objective(n2,Min,x)

    #Link constraints take the same expressions as the JuMP @constraint macro
    @linkconstraint(graph,n1[:x] == n2[:x])
    @linkconstraint(graph,n1[:z] == n2[:z])

    #Objective function
    
    return graph
end

PLASMO_MODEL[2] = function ()
    graph = OptiGraph()

    #Add nodes to a Graph
    @optinode(graph,nodes[1:4])

    @variable(nodes[1],0 <= x <= 2)
    @variable(nodes[1],0 <= y <= 3)
    @variable(nodes[1], 0 <= z <= 2)
    @constraint(nodes[1],x+y+z >= 4)
    @objective(nodes[1],Min,y)

    @variable(nodes[2],x >= 0)
    @NLconstraint(nodes[2],ref,exp(x) >= 2)
    @variable(nodes[2],0 <= z <= 2)
    @constraint(nodes[2],z + x >= 4)
    @objective(nodes[2],Min,x)

    @variable(nodes[3],x[1:3] >= 0)
    @NLconstraint(nodes[3],nlcon,exp(x[3]) >= 5)
    @constraint(nodes[3],conref,sum(x[i] for i = 1:3) == 10)
    @objective(nodes[3],Min,-(x[1] + x[2] + x[3]))

    @variable(nodes[4],x[1:2] >= 0)
    @constraint(nodes[4],sum(x[i] for i = 1:2) >= 10)
    @NLconstraint(nodes[4],ref,exp(x[2]) >= 4)
    @NLobjective(nodes[4],Min,x[2]^3)

    #Link constraints take the same expressions as the JuMP @constraint macro
    @linkconstraint(graph,link1,nodes[1][:x] == nodes[2][:x])
    @linkconstraint(graph,link2,nodes[2][:x] == nodes[3][:x][3])
    @linkconstraint(graph,link3,nodes[3][:x][1] == nodes[4][:x][1])
    
    return graph
end

PLASMO_MODEL[3] = function ()
    graph = OptiGraph()

    #Add nodes to graph
    n1 = @optinode(graph)
    n2 = @optinode(graph)

    #Node 1 Model
    @variable(n1,0 <= x <= 2)
    @variable(n1,0 <= y <= 3)
    @variable(n1, z >= 0)
    @constraint(n1,x+y+z >= 4)
    @objective(n1,Min,y+z)

    #Node 2 Model
    @variable(n2,x)
    @variable(n2,z >= 0)
    @constraint(n2,z + x >= 4)
    @objective(n2,Min,x)

    #Link constraints take the same expressions as the JuMP @constraint macro
    @linkconstraint(graph,n1[:x] == n2[:x])
    @linkconstraint(graph,n1[:z] == n2[:z])

    #Objective function
    return graph
end

PLASMO_MODEL[4] = function ()
    graph = OptiGraph()
    @optinode(graph,nodes[1:4])

    #node 1
    @variable(nodes[1],0 <= x <= 2)
    @variable(nodes[1],0 <= y <= 3)
    @constraint(nodes[1],x+y <= 4)
    @objective(nodes[1],Min,x)

    #node 2
    @variable(nodes[2],x >= 1)
    @variable(nodes[2],0 <= y <= 5)
    @NLconstraint(nodes[2],exp(x)+y <= 7)
    @objective(nodes[2],Min,x)

    #node 3
    @variable(nodes[3],x >= 0)
    @variable(nodes[3],y >= 0)
    @constraint(nodes[3],x + y == 2)
    @objective(nodes[3],Min,-x)

    #node 4
    @variable(nodes[4],0 <= x <= 1)
    @variable(nodes[4],y >= 0)
    @constraint(nodes[4],x + y <= 3)
    @objective(nodes[4],Min,-y)

    #Link constraints take the same expressions as the JuMP @constraint macro
    @linkconstraint(graph,nodes[1][:x] == nodes[2][:x])
    @linkconstraint(graph,nodes[2][:y] == nodes[3][:x])
    @linkconstraint(graph,nodes[3][:x] == nodes[4][:x])

    return graph
end

end
