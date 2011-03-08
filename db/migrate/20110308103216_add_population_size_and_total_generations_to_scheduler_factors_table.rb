class AddPopulationSizeAndTotalGenerationsToSchedulerFactorsTable < ActiveRecord::Migration
  def self.up
    add_column :scheduler_factors_tables, :population_size, :integer
    add_column :scheduler_factors_tables, :total_generations, :integer
  end

  def self.down
    remove_column :scheduler_factors_tables, :population_size
    remove_column :scheduler_factors_tables, :total_generations
  end
end
