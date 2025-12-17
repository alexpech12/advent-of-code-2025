# Pretty much all authored by Copilot
# 1. My linear algebra is pretty rusty
# 2. Ruby really isn't the tool for the job here!
#
# I didn't feed Copilot the problem directly, but I knew I had a system of linear equations to solve,
# and I've asked Copilot to write the algorithm for me given the solution needs to be a set of integers.

require "numo/narray"
require "numo/linalg/linalg"

# Load OpenBLAS (includes LAPACKE)
openblas_path = "/opt/homebrew/opt/openblas/lib/libopenblas.dylib"
Numo::Linalg::Blas.dlopen(openblas_path)
Numo::Linalg::Lapack.dlopen(openblas_path)

def find_minimum_integer_solution(a, b, search_range: -50..50)
  # Get a particular solution using least squares
  x_particular = Numo::Linalg.lstsq(a, b)[0]

  # Find the null space to generate all possible solutions
  null_space = Numo::Linalg.null_space(a)
  num_null_vectors = null_space.shape[1]

  best_solution = nil
  best_sum = Float::INFINITY

  # Try different integer combinations of null space vectors
  if num_null_vectors == 3
    # Use step to reduce search space for 3D
    step = [1, (search_range.size / 100).ceil].max
    search_range.step(step).each do |t1|
      search_range.step(step).each do |t2|
        search_range.step(step).each do |t3|
          candidate = x_particular + t1 * null_space[true, 0] + t2 * null_space[true, 1] + t3 * null_space[true, 2]
          candidate_int = candidate.round

          # Check if it satisfies the equation
          result = a.dot(candidate_int)
          if (result - b).abs.max < 0.001
            sum = candidate_int.to_a.map(&:abs).sum
            if sum < best_sum
              best_sum = sum
              best_solution = candidate_int.to_a
            end
          end
        end
      end
    end
  elsif num_null_vectors == 2
    search_range.each do |t1|
      search_range.each do |t2|
        candidate = x_particular + t1 * null_space[true, 0] + t2 * null_space[true, 1]
        candidate_int = candidate.round

        # Check if it satisfies the equation
        result = a.dot(candidate_int)
        if (result - b).abs.max < 0.001
          sum = candidate_int.to_a.map(&:abs).sum
          if sum < best_sum
            best_sum = sum
            best_solution = candidate_int.to_a
          end
        end
      end
    end
  elsif num_null_vectors == 1
    search_range.each do |t1|
      candidate = x_particular + t1 * null_space[true, 0]
      candidate_int = candidate.round

      result = a.dot(candidate_int)
      if (result - b).abs.max < 0.001
        sum = candidate_int.to_a.map(&:abs).sum
        if sum < best_sum
          best_sum = sum
          best_solution = candidate_int.to_a
        end
      end
    end
  else
    # No null space, just round the particular solution
    candidate_int = x_particular.round
    result = a.dot(candidate_int)
    if (result - b).abs.max < 0.001
      best_solution = candidate_int.to_a
      best_sum = candidate_int.to_a.map(&:abs).sum
    end
  end

  [best_solution, best_sum]
end
