using Test
using JCGELibrary
using JCGELibrary.StandardCGE
using JCGELibrary.SimpleCGE
using JCGEKernel
using JuMP
using Ipopt

@testset "JCGELibrary" begin
    sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
    spec = StandardCGE.model(sam_path=sam_path)
    @test spec.name == "StandardCGE"
end

if get(ENV, "JCGE_SOLVE_TESTS", "0") == "1"
    @testset "JCGELibrary.Solve" begin
        sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
        spec = StandardCGE.model(sam_path=sam_path)
        result = JCGEKernel.run!(spec; optimizer=Ipopt.Optimizer, dataset_id="standard_cge_test")
        @test result.summary.count > 0

        spec_simple = SimpleCGE.model()
        result_simple = JCGEKernel.run!(spec_simple; optimizer=Ipopt.Optimizer, dataset_id="simple_cge_test")
        @test result_simple.summary.count > 0
    end
end

if get(ENV, "JCGE_COMPARE_STANDARD", "0") == "1"
    @testset "JCGELibrary.Compare.StandardCGE" begin
        using Pkg
        Pkg.add("StandardCGE")
        import StandardCGE as StdCGE

        sam_path = joinpath(StandardCGE.datadir(), "sam_2_2.csv")
        sam_table = StdCGE.load_sam_table(sam_path)
        std_model, _, _ = StdCGE.solve_model(sam_table; optimizer_attributes=Dict("print_level" => 0))
        std_obj = JuMP.objective_value(std_model)
        std_Xp = JuMP.value.(std_model[:Xp])

        spec = StandardCGE.model(sam_path=sam_path)
        result = JCGEKernel.run!(spec; optimizer=Ipopt.Optimizer, dataset_id="standard_cge_compare")
        ours_model = result.context.model
        ours_obj = JuMP.objective_value(ours_model)
        ours_Xp = JuMP.value.(ours_model[:Xp])

        @test isfinite(std_obj)
        @test isfinite(ours_obj)
        @test isapprox(ours_obj, std_obj; rtol=1e-5, atol=1e-6)
        @test isapprox.(ours_Xp, std_Xp; rtol=1e-5, atol=1e-6) |> all
    end
end
