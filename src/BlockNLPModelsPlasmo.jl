module BlockNLPModelsPlasmo

import Plasmo, BlockNLPModels, NLPModelsJuMP, SparseArrays

"""
    BlockNLPModels.BlockNLPModel(graph::OptiGraph)

Creates a BlockNLPModel from OptiGraph
"""
function BlockNLPModels.BlockNLPModel(graph::Plasmo.OptiGraph)
    if Plasmo.has_objective(graph)
        error("BlockNLPModels does not support graph objective")
    end
    
    blk = BlockNLPModels.BlockNLPModel()

    for node in Plasmo.optinodes(graph)
        if Plasmo.objective_sense(node) == Plasmo.MAX_SENSE
            error("Maximization is not supported")
        end
        BlockNLPModels.add_block(blk,NLPModelsJuMP.MathOptNLPModel(node.model))
    end

    for edge in Plasmo.optiedges(graph)
        m = Plasmo.num_link_constraints(edge)
        A = Dict(graph.node_idx_map[node] => SparseArrays.spzeros(m,Plasmo.num_variables(node)) for node in edge.nodes)
        c = zeros(m)
        for (i,link) in enumerate(Plasmo.linkconstraints(edge))
            for (var,coef) in link.func.terms
                id = graph.node_idx_map[var.model.ext[:optinode]]
                A[id][i,var.index.value] = coef
            end
            if !(link.set isa Plasmo.MathOptInterface.EqualTo)
                error("Only equality link constraints are supported")
            end
            c[i] = link.set.value
        end
        BlockNLPModels.add_links(blk,length(c),A,c)
    end

    return blk
end

export BlockNLPModel

end # module
