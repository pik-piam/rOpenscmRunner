"""Add a mock model to openscm_runner for testing"""

import openscm_runner
import openscm_runner.adapters
import openscm_runner.adapters.base
import scmdata


class MockModel(openscm_runner.adapters.base._Adapter):
    model_name = "Mock"

    def _init_model(self):
        pass

    def _run(self, scenarios:scmdata.ScmRun, cfgs, output_variables, output_config):
        df = scenarios.meta.drop(columns=["unit", "variable"]).drop_duplicates()
        df["climate_model"] = "Mock"
        df["variable"] = output_variables[0]
        df["unit"] = "degC"
        for year in scenarios.time_points.years():
            df[year] = 0.
        return scmdata.ScmRun(df)


openscm_runner.adapters.register_adapter_class(MockModel)
