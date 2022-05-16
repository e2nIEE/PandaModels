@testset "test for voltage deviation" begin
    @testset "case_vstab: cigre mv" begin
        result = run_pandamodels_vstab(case_vstab)
        pm = _PdM.load_pm_from_json(case_vstab)
        params = _PdM.extract_params!(pm)

        @test string(result["termination_status"]) == "LOCALLY_SOLVED"
        @test string(result["dual_status"]) == "FEASIBLE_POINT"
        @test string(result["primal_status"]) == "FEASIBLE_POINT"

        bus = result["solution"]["bus"]
        for (idx, bus) in result["solution"]["bus"]
            if idx in keys(params[:setpoint_v])
                @test isapprox(bus["vm"], params[:setpoint_v][idx]["value"], atol=1e-1)
            end
        end

        @test isapprox(result["objective_lb"], -Inf)
        @test isapprox(result["objective"], 0.000453688; atol = 1e-8)
        @test result["solve_time"] > 0.0

    end

    @testset "case_qflex: cigre mv" begin
        result = run_pandamodels_qflex(case_qflex)
        pm = _PdM.load_pm_from_json(case_qflex)
        params = _PdM.extract_params!(pm)

        @test string(result["termination_status"]) == "LOCALLY_SOLVED"
        @test string(result["dual_status"]) == "FEASIBLE_POINT"
        @test string(result["primal_status"]) == "FEASIBLE_POINT"

        for (idx, br) in result["solution"]["branch"]
            if idx in keys(params[:setpoint_q])
                @test isapprox(br["qf"], params[:setpoint_q][idx]["value"], atol=1e-1)
            end
        end
        @test isapprox(result["objective_lb"], -Inf)
        @test result["solve_time"] > 0.0
    end

    @testset "case_multi_vstab: cigre mv" begin
        result = run_pandamodels_multi_vstab(case_multi_vstab)
        pm = _PdM.load_pm_from_json(case_multi_vstab)
        params = _PdM.extract_params!(pm)

        @test string(result["termination_status"]) == "LOCALLY_SOLVED"
        @test string(result["dual_status"]) == "FEASIBLE_POINT"
        @test string(result["primal_status"]) == "FEASIBLE_POINT"

        # bus = result["solution"]["bus"]
        # for (idx, bus) in result["solution"]["bus"]
        #     if idx in keys(params[:setpoint_v])
        #         @test isapprox(bus["vm"], params[:setpoint_v][idx]["value"], atol=1e-1)
        #     end
        # end

        @test result["solve_time"] > 0.0
    end
end
