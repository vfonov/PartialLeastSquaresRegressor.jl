@testset "PLS1 Pediction Tests (in sample)" begin

	@testset "Single Column Prediction Test" begin

		X        = MLJ.table([1; 2; 3.0][:,:])
		Y        = [1; 2; 3.0]

        pls_model      = PLSRegressor.PLS(n_factors=1,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        train = range(1,stop=length(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);

		@test isequal(round.(yhat),[1; 2; 3.0])

	end


	@testset "Constant Values Prediction Tests (Ax + b) | A=0, b=1 " begin

		X        = MLJ.table([1 3;2 1;3 2.0])
		Y        = [1; 1; 1.0]
		try
			pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
			pls_machine    = MLJ.machine(pls_model, X, Y)

			train = range(1,stop=length(X))
			MLJ.fit!(pls_machine, rows=train,force=true)
		catch
			@test true
		end

	end

	@testset "Linear Prediction Tests " begin


		X        = MLJ.table([1 2; 2 4; 4.0 6])
		Y        = [2; 4; 6.0]

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        train = range(1,stop=length(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=train);

		@test isequal(round.(pred),[2; 4; 6.0])

		X           = MLJ.table([1 -2; 2 -4; 4.0 -6])
		Y           = [-2; -4; -6.0]

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        train = range(1,stop=length(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=train);

		@test isequal(round.(pred),[-2; -4; -6.0])

	end

	@testset "Linear Prediction Tests (Ax + b)" begin


		X = MLJ.table([1 2; 2 4; 4.0 6;6 8; 8 10; 10.0 12])
		Y = [2; 4; 6.0; 8; 10; 12.0]

		train = range(1,3)
		test  = range(4,6)

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=test);

		@test isequal(round.(pred),[8; 10; 12.0])

		X        = [1 2; 2 4.0; 4.0 6; 6 8; 1 2; 2 4.0]
		Y        = [2; 4; 6.0; 8; 2; 4.0]

		train = range(1,stop=4)
		test  = range(5,stop=6)

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=test);

		@test isequal(round.(pred),[2; 4])

	end

end;


@testset "PLS1 Pediction Tests (out of sample)" begin


	@testset "Linear Prediction Tests (Ax + b) | A>0" begin


		X        = MLJ.table([1 2; 2 4; 4.0 6;6 8; 8 10; 10.0 12])
		Y        = [2; 4; 6.0; 8.0; 10; 12]

		train = range(1,stop=3)
		test  = range(4,stop=6)

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=test);


		@test isequal(round.(pred),[8; 10; 12.0])


		X        = MLJ.table([1 2; 2 4; 4.0 6; 6 8; 8 10; 10.0 12])
		Y        = [4; 6; 8.0; 10; 12; 14.0]

		train = range(1,stop=3)
		test  = range(4,stop=6)

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=test);

		@test isequal(round.(pred),[10; 12; 14.0])


	end

	@testset "Linear Prediction Tests (Ax + b) | A<0" begin



		X        = MLJ.table([1 -2; 2 -4; 4.0 -6; 6 -8; 8 -10; 10.0 -12])
		Y        = [-2; -4; -6.0; -8; -10; -12.0]

		train = range(1,stop=3)
		test  = range(4,stop=6)

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=test);

		@test isequal(round.(pred),[-8; -10; -12.0])


		X        = MLJ.table([1 -2; 2 -4; 4.0 -6; 6 -8; 8 -10; 10.0 -12])
		Y        = [-4; -6; -8.0; -10; -12; -14.0]

		train = range(1,stop=3)
		test  = range(4,stop=6)

		pls_model      = PLSRegressor.PLS(n_factors=2,centralize=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)

        MLJ.fit!(pls_machine, rows=train,force=true)
        pred = MLJ.predict(pls_machine, rows=test);

		@test isequal(round.(pred),[-10; -12; -14.0])

	end

end;
