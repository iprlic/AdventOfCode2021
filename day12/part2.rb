#!/usr/bin/env ruby
# frozen_string_literal: true

class String
  def is_small?
    self == downcase
  end
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field =  input.split("\n").map { |c| c.split('-') }

paths = []
nexts = ['start']
more = true
cnt = 0

while more
  new_nexts = []
  new_paths = paths.select { |p| p.last == 'end' }
  field.each do |f|
    if nexts.include?(f[0])
      new_nexts.push(f[1])
      if nexts == ['start']
        new_paths.push(f)
      else
        ends = paths.clone.map(&:clone).select { |p| p.last == f[0] }

        if %w[start end].include?(f[1])
          ends = ends.select { |p| p.include?(f[1]) == false }
        elsif f[1].is_small?
          ends = ends.select do |p|
            smalls = p.select(&:is_small?)

            smalls.uniq.size == smalls.size or !smalls.include?(f[1])
          end
        end

        ends.each do |e|
          e.push(f[1])
        end

        new_paths += ends
      end
    end

    next unless nexts.include?(f[1])

    new_nexts.push(f[0])
    if nexts == ['start']
      new_paths.push(f.reverse)
    else
      ends = paths.clone.map(&:clone).select { |p| p.last == f[1] }

      if %w[start end].include?(f[0])
        ends = ends.select { |p| p.include?(f[0]) == false }
      elsif f[0].is_small?
        ends = ends.select do |p|
          smalls = p.select(&:is_small?)

          smalls.uniq.size == smalls.size or !smalls.include?(f[0])
        end
      end

      ends.each do |e|
        e.push(f[0])
      end

      new_paths += ends
    end
  end
  nexts = new_nexts.uniq.reject { |n| n == 'end' }
  paths = new_paths.clone

  more = false if paths.reject { |p| p.last == 'end' }.size.zero?
  cnt += 1

end

puts paths.size

# paths.each do |p|
# print p.join(',')
# puts
# end
