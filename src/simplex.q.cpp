#include "stdafx.h"

#include <cassert>
#include <algorithm>
#include <iterator>
#include <string>
#include <vector>
#include <sstream>

#include "simplex.q.h"

SIMPLEXQ_API K K_DECL version(K _) {
	std::string const id("$Id: 3c55ad290fc538332e942dc9cac1dbfbe684ce41 $");
	return kp(const_cast<S>((id + " @ " __DATE__ " " __TIME__).c_str()));
}

enum OPT_DIR {
	MINIMIZE = 1,
	MAXIMIZE = -1
};

struct RowConstraint {
	double const* coeffs;
	double lb, ub;
};

struct Solution {
	double objective;
	std::vector<double> variables;
};

ClpSimplex& createModel(ClpSimplex &model,
	OPT_DIR optDirection,
	size_t nVariables, double const* objCoefficients,
	std::vector<std::pair<double, double> > const& varBounds,
	std::vector<RowConstraint> const& constraints)
{
	model.resize(0, nVariables);
	model.setOptimizationDirection(static_cast<double>(optDirection));
	std::vector<int> colIdx(nVariables);
	for (size_t v = 0; v < nVariables; ++v) {
		model.setObjectiveCoefficient(v, objCoefficients[v]);
		model.setColumnBounds(v, varBounds[v].first, varBounds[v].second);
		colIdx[v] = v;
	}
	CoinBuild builder;
	std::for_each(constraints.cbegin(), constraints.cend(), [&](RowConstraint const& constraint) {
		builder.addRow(nVariables, &colIdx[0], constraint.coeffs, constraint.lb, constraint.ub);
	});
	model.addRows(builder);
	return model;
}

#pragma warning(disable: 4290)
Solution getSolution(ClpSimplex& model) throw(std::string) {
#pragma warning(default: 4290)
	// Verify solution status
	switch (model.status()) {
	case 0:
		break;	// optimal
	case 1:
		throw std::string("primal infeasible");
	case 2:
		throw std::string("dual infeasible");
	case 3:
		throw std::string("too many iterations");
	case 4:
		throw std::string("simplex error");
	default:
		std::ostringstream buffer;
		buffer << "unexpected simplex error: " << model.status();
		throw buffer.str();
	}

	// Extract solution data
	Solution solution;
	solution.objective = model.objectiveValue();
	size_t count = static_cast<size_t>(model.numberColumns());
	double const* variables = model.primalColumnSolution();
	solution.variables.resize(count);
	std::copy(variables, variables + count, solution.variables.begin());
	return solution;
}

SIMPLEXQ_API K K_DECL solveCpp(K maximize, K objective, K bounds, K constraints) {
	assert(maximize && objective && bounds && constraints);

	// Validate `maximize'
	OPT_DIR optDirection = MINIMIZE;
	if (-KB != maximize->t) {
		return krr("invalid optimization direction");
	}
	else {
		optDirection = maximize->g ? MAXIMIZE : MINIMIZE;
	}

	// Validate `objective'
	size_t nVariables = 0;
	double const* objCoefficients = NULL;
	if (KF != objective->t) {
		return krr("invalid objective coefficients");
	}
	else if (0 >= objective->n) {
		return krr("empty objective");
	}
	else {
		nVariables = static_cast<size_t>(objective->n);
		objCoefficients = kF(objective);
	}
	assert((nVariables > 0) && (objCoefficients != NULL));

	// Validate `bounds'
	std::vector<std::pair<double, double> > varBounds(nVariables);
	if (101 == bounds->t) {
		if (0 == bounds->g) {
			varBounds.assign(nVariables, std::pair<double, double>{ 0, wf });
		}
		else {
			return krr("unknown variable bounds");
		}
	}
	else if (0 != bounds->t) {
		return krr("invalid variable bounds");
	}
	else if (nVariables != static_cast<size_t>(bounds->n)) {
		return krr("incorrect variable bounds count");
	}
	else {
		for (int v = 0; v < bounds->n; ++v) {
			K const pair = kK(bounds)[v];
			assert(NULL != pair);
			if (KF != pair->t) {
				return krr("incorrect variable bounds type");
			}
			else if (2 != pair->n) {
				return krr("incorrect variable bounds pair");
			}
			else {
				varBounds.push_back(std::pair<double, double>{kF(pair)[0], kF(pair)[1]});
			}
		}
	}

	// Validate `constraints'
	std::vector<RowConstraint> rowConstraints;
	if (XT != constraints->t) {
		return krr("invalid constraints table");
	}
	else {
		assert((NULL != constraints->k) && (2 == constraints->k->n));
		K const keys = kK(constraints->k)[0];
		assert((KS == keys->t) && (0 < keys->n));
		K const vals = kK(constraints->k)[1];
		assert((0 == vals->t) && (0 < vals->n));
		assert(keys->n == vals->n);
		assert(0 <= kK(vals)[0]->n);
		for (int r = 0; r < kK(vals)[0]->n; ++r) {
			RowConstraint constraint;
			for (int c = 0; c < keys->n; ++c) {
				std::string col = kS(keys)[c];
				K const val = kK(vals)[c];
				if (col == "coeffs") {
					if (0 != val->t) {
						return krr("invalid constraint coefficients");
					}
					K const coeffs = kK(val)[r];
					if (KF != coeffs->t) {
						return krr("incorrect constraint coefficients type");
					}
					else if (nVariables != static_cast<size_t>(coeffs->n)) {
						return krr("inconsistent constraint coefficients count");
					}
					else {
						assert(NULL != kF(coeffs));
						constraint.coeffs = kF(coeffs);
					}
				}
				else if (col == "lb") {
					if (KF != val->t) {
						return krr("invalid constraint lower bounds");
					}
					else {
						constraint.lb = kF(val)[r];
					}
				}
				else if (col == "ub") {
					if (KF != val->t) {
						return krr("invalid constraint upper bounds");
					}
					else {
						constraint.ub = kF(val)[r];
					}
				}
				else {
					return krr("unknown constraint column");
				}
			}
			rowConstraints.push_back(constraint);
		}
	}

	// Create & solve simplex model
	Solution solution;
	try {
		ClpSimplex model;
		createModel(model, optDirection, nVariables, objCoefficients, varBounds, rowConstraints);

		model.primal();

		solution = getSolution(model);
		assert(solution.variables.size() == nVariables);
	}
	catch (std::string const& ex) {
		return krr(const_cast<S>(ex.c_str()));
	}
	catch (...) {
		return orr("unexpected solver error");
	}

	// Construct results for q
	K obj = kf(solution.objective);
	K var = ktn(KF, nVariables);
	std::copy(solution.variables.cbegin(), solution.variables.cend(),
		stdext::make_checked_array_iterator(kF(var), nVariables));
	return knk(2, obj, var);
}