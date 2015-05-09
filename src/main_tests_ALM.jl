######################################################################
### Dependencies
######################################################################
workspace()
require("alm_all_includes.jl")

######################################################################
### Initialization of main data structures
######################################################################

### Load the initial contracts, cashFlows and balanceSheet objects
contracts = create_contracts_example()
cashFlows = DataFrame()
update_cashFlows(cashFlows, contracts, ALM_DEFAULT_DEST_ACCOUNT_ID)
balanceSheet = create_and_load_balance_sheet()

### Load the start values of risk factors in a appropriate order (Exemplo: [TJLP, SELIC])
index_order = ["TJLP" "IPCA"]
p = create_values_and_params_example()
value = p[:value]; params = p[:params]

### Build the tree and apply the "petelecos"
root = PathsTree(value, 1, contracts, cashFlows, balanceSheet) 
add_childs(root, ALM_NUMBER_OF_CHILDS, multivariate_gbm, params)
lots_of_petelecos(root, 100000, ALM_NUMBER_OF_CHILDS, multivariate_gbm, params, normalized_euclidean_distance);

### Run ALM Simulation Test
#run_alm_simulation(node::PathsTree, strategy)
croot = deepcopy(root);
run_alm_simulation(croot, [1])
