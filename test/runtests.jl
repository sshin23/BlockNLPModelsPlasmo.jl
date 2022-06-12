using BlockNLPModels, Plasmo, BlockNLPModelsPlasmo, NLPModelsIpopt, Test, LinearAlgebra, Ipopt
include("plasmotests.jl")

const atol = 1e-8

exclude = [
]

@testset "NLPModelsPlasmo test" begin
    for i in 1:length(PlasmoTests.PLASMO_MODEL)
        i in exclude && continue
        result = ipopt(FullSpaceModel(BlockNLPModel(PlasmoTests.PLASMO_MODEL[i]())))
        
        graph = PlasmoTests.PLASMO_MODEL[i]()
        set_optimizer(graph,Ipopt.Optimizer)
        optimize!(graph)

        @testset "$i" begin
            @test norm(value.(all_variables(graph)) - result.solution, Inf) < atol
            @test abs(objective_value(graph) - result.objective) < atol
        end
    end
end
