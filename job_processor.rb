# frozen_string_literal: true
module Mediators
  class Base
    def self.run(jobs_string)
      new(jobs_string).call
    end
  end
  class JobProcessor < Base
    def initialize(jobs_string)
      @reverse_dependencies = {}
      @parsed_jobs = parse_jobs(jobs_string)
      @dependency_hash = generate_dependency_hash(@parsed_jobs)
    end

    # Sorts jobs into their dependencies
    # Params:
    # +jobs_string+:: a multiline string that has job dependencies
    def call
      jobs_list = @parsed_jobs.flatten.uniq # Vertex Set
      # Add the jobs with no dependencies first
      final_jobs = @parsed_jobs.select { |jobs| jobs.count == 1 }.flatten
      dependent_jobs = jobs_list - final_jobs
      dependent_jobs.each do |job|
        next if final_jobs.include? job
        return false if cycle? job
        dependencies = @reverse_dependencies[job].reject do |dependent_job|
          final_jobs.include? dependent_job
        end
        final_jobs += dependencies
      end
      final_jobs.join
    end

    def parse_jobs(jobs_string)
      jobs_string.split("\n").map { |job| trim_all(job).split('=>') }
    end

    # Remove all whitespace from string (not carriage return)
    def trim_all(string_with_whitespace)
      string_with_whitespace.delete(' ')
    end

    def generate_dependency_hash(jobs_array)
      # Remove all of the elements without a dependency
      jobs_array.reject { |jobs_list| jobs_list.count == 1 }.map.to_h
    end

    def cycle?(vertex)
      previous_verticies = [vertex]
      previous_vertex = vertex
      while @dependency_hash.key? previous_vertex
        current_vertex = @dependency_hash[previous_vertex]
        # If the list of previous verticies includes the current vertex, there's a
        # cycle in our graph
        if previous_verticies.include? current_vertex
          if previous_vertex == vertex
            puts "A job can't depend on itself."
          else
            puts 'Circular dependencies are not allowed.'
          end
          return true
        else
          previous_verticies += [current_vertex]
          previous_vertex = current_vertex
        end
        # Skip the last dependency because it was already added
        @reverse_dependencies[vertex] = previous_verticies[0..-2].reverse
        false # If we get here, the graph has no dependencies from this vertex
      end
    end
  end
end
