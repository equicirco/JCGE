using Test
using JCGERuntime

@testset "JCGERuntime" begin
    ctx = KernelContext()
    report = validate_model(ctx)
    @test report.ok
end
