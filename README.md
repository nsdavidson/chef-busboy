### Description
Busboy provides a way to take certain actions on sets of nodes that match a search
result.  Assumes a workstation with Knife already configured as Busboy will use existing
knife config.

### Usage
```
Commands:
  busboy help [COMMAND]                                                               # Describe available commands or one specific command
  busboy node_env_change --environment=ENVIRONMENT --search-string=SEARCH_STRING      # Move nodes to new environment
  busboy node_search --search-string=SEARCH_STRING                                    # Search for nodes based on supplied search query
  busboy run_list_add --recipe-string=RECIPE_STRING --search-string=SEARCH_STRING     # Add recipes the run list for all nodes matching a search
  busboy run_list_delete --recipe-string=RECIPE_STRING --search-string=SEARCH_STRING  # Add recipes the run list for all nodes matching a search
```
Examples:
```
busboy node_search --search-string="chef_environment:Prod AND NOT run_list:*chef-client*"
busboy run_list_add --search-string="chef_environment:Prod AND NOT run_list:*chef-client*" --recipe-string="chef-client"
```
