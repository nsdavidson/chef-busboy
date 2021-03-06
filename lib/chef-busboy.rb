require 'thor'
require 'ridley'

Ridley::Logging.logger.level = Logger.const_get 'FATAL'

class ChefBusBoy < Thor
  @@chef_server = ''

  desc "run_list_add", "Add recipes the run list for all nodes matching a search"
  option :search_string, :required => true
  option :recipe_string, :required => true
  def run_list_add()
    results = search(options[:search_string])
    if results.empty?
      puts "No nodes match this search string"
    else
      print_nodes(results)
      answer = get_user_confirmation("These are the nodes that matched your search and will be updated.  Would you like to continue? y/n")
      if answer
        puts "Selections confirmed...updating run lists now..."
        results.each do |node|
          puts "Updating #{node.name}'s run list with #{options[:recipe_string]}"
          full_node = get_connection.node.find("#{node.name}")
          full_node.run_list << "#{options[:recipe_string]}"
          get_connection.node.update(full_node)
        end
      else
        puts "Transaction cancelled.  Not updating any nodes"
      end
    end
  end

  desc "run_list_delete", "Add recipes the run list for all nodes matching a search"
  option :search_string, :required => true
  option :recipe_string, :required => true
  def run_list_delete()
    results = search(options[:search_string])
    if results.empty?
      puts "No nodes match this search string"
    else
      print_nodes(results)
      answer = get_user_confirmation("These are the nodes that matched your search and will be updated.  Would you like to continue? y/n")
      if answer
        puts "Selections confirmed...updating run lists now..."
        results.each do |node|
          puts "Updating #{node.name}'s run list with #{options[:recipe_string]}"
          full_node = get_connection.node.find("#{node.name}")
          full_node.run_list.delete("#{options[:recipe_string]}")
          get_connection.node.update(full_node)
        end
      else
        puts "Transaction cancelled.  Not updating any nodes"
      end
    end
  end

  desc "node_env_change", "Move nodes to new environment"
  option :search_string, :required => true
  option :environment, :required => true
  def node_env_change
    results = search(options[:search_string])
    if results.empty?
      puts "No nodes match this search string"
    else
      print_nodes(results)
      answer = get_user_confirmation("These are the nodes that matched your search and will be updated.  Would you like to continue? y/n")
      if answer
        puts "Selections confirmed...updating environments now..."
        update_node_list(results)
        results.each do |node|
          puts "Changing #{node.name}'s environment to #{options[:environment]}"
          full_node = @@chef_server.node.find("#{node.name}")
          full_node.chef_environment = "#{options[:environment]}"
          @@chef_server.node.update(full_node)
        end
      else
        puts "Transaction cancelled.  Not updating any nodes"
      end
    end
  end

  desc "node_search", "Search for nodes based on supplied search query"
  option :search_string, :required => true
  def node_search
    results = search(options[:search_string])
    if results.empty?
      puts "No nodes matched this search"
    else
      print_nodes(results)
      puts "#{results.length} nodes found"
    end
  end


  no_commands {
    def get_connection
      @@chef_server = Ridley.from_chef_config(nil, {:ssl => {:verify => false}})
    end

    def search(string)
      chef_server = get_connection
      results = chef_server.partial_search(:node, "#{options[:search_string]}", "", {:rows => 5000})
      #results = chef_server.search(:node, "#{options[:search_string]}", {:rows => 5000})
    end

    def print_nodes(nodes)
      nodes.each do |node|
        puts "#{node.name}"
      end
    end

    def get_user_confirmation(prompt)
      answer = ask(prompt).to_s.downcase
      if (answer == "y" ||  answer == "yes")
        return true
      else
        return false
      end
    end
  }
end
