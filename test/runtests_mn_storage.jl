# import Pkg
# Pkg.activate(".")
using Test
using PandaModels; const _PdM = PandaModels
import PowerModels; const _PM = PowerModels
import JSON
import JuMP


_PM.silence()
pdm_path = joinpath(dirname(pathof(PandaModels)), "..")
data_path = joinpath(pdm_path, "test", "data")
case_ots_dc = joinpath(data_path, "test_mn_storage_1.json")
case_ots_dc100 = joinpath(data_path, "test_mn_storage_100.json")

pm = _PdM.load_pm_from_json(case_ots_dc)
pm1 = _PdM.load_pm_from_json(case_ots_dc)
pm1["baseMVA"] = 100
pm100 = _PdM.load_pm_from_json(case_ots_dc100)

pmc = _PdM.check_powermodels_data!(pm1)


## storage
# _PM.silence()
# pdm_path = joinpath(dirname(pathof(PandaModels)), "..")
# data_path = joinpath(pdm_path, "test", "data")
# case_ts = joinpath(data_path, "test_mn_storage.json")
#
# pm = _PdM.load_pm_from_json(case_ts)
# _PdM.active_powermodels_silence!(pm)
# pm = _PdM.check_powermodels_data!(pm)
# model = _PdM.get_model(pm["pm_model"])
# solver = _PdM.get_solver(pm)
# mn = _PdM.set_pq_values_from_timeseries(pm)
#
# result = _PM.solve_mn_opf_strg(mn, model, solver,
#     setting = Dict("output" => Dict("branch_flows" => true)),
# )
#
#
#
# string(result["termination_status"]) == "LOCALLY_SOLVED"
# string(result["dual_status"]) == "FEASIBLE_POINT"
# string(result["primal_status"]) == "FEASIBLE_POINT"
# string(result["optimizer"]) == "Juniper"
# result["solve_time"] > 0.0
