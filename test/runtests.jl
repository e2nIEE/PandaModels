# using Pkg
# Pkg.activate(".")

using Test
using PyCall
using PandaModels

const _PdM = PandaModels


# py"""
# from pandapower import pp_dir
# import os
# import pytest
# test_dir=os.path.join(pp_dir, "test")
# sta = pytest.main([test_dir])
# """

# @testset "PandaModels.jl" begin
#     status = py"sta.value"
#     @test status == 0
# end

# test_path = abspath(joinpath(pathof(_PdM),"..","..","test"))
test_path = joinpath(pwd(), "test")

if ! occursin(".julia/dev/PandaModels", pathof(_PdM))
        include(joinpath(test_path, "create_test_json.jl")) #TODO:should produce following files
        json_path = tempdir()
else
        json_path = joinpath(test_path, "data")
end

test_pm = joinpath(json_path, "test_pm.json") # 1gen, 82bus, 116branch, 177load, DCPPowerModel, solver:Ipopt
test_powerflow = joinpath(json_path, "test_powerflow.json")
test_powermodels = joinpath(json_path, "test_powermodels.json")
test_custom = joinpath(json_path, "test_powermodels_custom.json")
test_ots = joinpath(json_path, "test_ots.json")
test_tnep = joinpath(json_path, "test_tnep.json")
test_gurobi = joinpath(json_path, "test_gurobi.json")
test_mn_storage = joinpath(json_path, "test_mn_storage.json")
time_series = joinpath(json_path, "timeseries.json")
# #
@testset "PandaModels.jl" begin
        @testset "test internal functions" begin
                # simbench grid 1-HV-urban--0-sw with ipopt solver
                pm = _PdM.load_pm_from_json(test_pm)

                @test length(pm["bus"]) == 4
                @test length(pm["gen"]) == 3
                @test length(pm["branch"]) == 3
                @test length(pm["load"]) == 3

                model =_PdM.get_model(pm["pm_model"])
                @test string(model) == "PowerModels.DCPPowerModel"

                solver = _PdM.get_solver(pm["pm_solver"], pm["pm_nl_solver"], pm["pm_mip_solver"],
                pm["pm_log_level"], pm["pm_time_limit"], pm["pm_nl_time_limit"], pm["pm_mip_time_limit"])

                @test string(solver.optimizer_constructor) == "Ipopt.Optimizer"

        end

        @testset "test exported executive functions" begin
                @testset "test for run_powermodels" begin
                        result=run_powermodels(test_powermodels)
                        @test isa(result, Dict{String,Any})
                        @test string(result["termination_status"]) == "LOCALLY_INFEASIBLE"
                        @test isapprox(result["objective"], 401.96; atol = 1e0)
                        @test result["solve_time"] > 0
                end
                @testset "test for run_powermodels_powerflow" begin
                        result=run_powermodels_powerflow(test_powerflow)
                        @test isa(result, Dict{String,Any})
                        @test string(result["termination_status"]) == "LOCALLY_SOLVED"
                        @test isapprox(result["objective"], 0; atol = 1e0)
                        @test result["solve_time"] > 0
                end
                @testset "test for powermodels_custom" begin
                        result=run_powermodels_custom(test_custom)
                        @test isa(result, Dict{String,Any})
                        @test string(result["termination_status"]) == "LOCALLY_INFEASIBLE"
                        # @test isapprox(result["objective"], 0; atol = 1e0)
                        @test result["solve_time"] > 0
                end
                @testset "test for powermodels_tnep" begin
                        result=run_powermodels_tnep(test_tnep)
                        @test isa(result, Dict{String,Any})
                        @test string(result["termination_status"]) == "LOCALLY_SOLVED"
                        @test isapprox(result["objective"], 0; atol = 1e0)
                        @test result["solve_time"] > 0
                end
                if Base.find_package("Gurobi") != nothing
                        @testset "test for Gurobi" begin
                                result=run_powermodels_tnep(test_gurobi)
                                @test isa(result, Dict{String,Any})
                                @test string(result["termination_status"]) == "OPTIMAL"
                                @test isapprox(result["objective"], 0; atol = 1e0)
                                @test result["solve_time"] > 0
                        end
                end
                @testset "test for powermodels_ots" begin
                        result=run_powermodels_ots(test_ots)
                        @test isa(result, Dict{String,Any})
                        @test string(result["termination_status"]) == "LOCALLY_SOLVED"
                        @test isapprox(result["objective"], 14810.0; atol = 100)
                        @test result["solve_time"] > 0
                end
                @testset "test for powermodels_mn_storage" begin
                        result=run_powermodels_mn_storage(test_mn_storage, time_series)
                        @test isa(result, Dict{String,Any})
                        @test string(result["termination_status"]) == "OPTIMAL"
                        # @test isapprox(result["objective"], 0; atol = 1e0)
                        @test result["solve_time"]>=0
                end
        end
        if ! occursin(".julia/dev/PandaModels", pathof(_PdM))
                files = [test_pm, test_powerflow, test_powermodels, test_custom, test_ots, test_tnep, test_mn_storage]
                @testset "remove temp files" begin
                        for fl in files
                                rm(fl, force=true)
                                @test !isfile(fl)
                        end
                end
        end

end
