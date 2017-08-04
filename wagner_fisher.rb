#!/usr/bin/env ruby

require 'ostruct'

str1 = 'omas'
str2 = 'ouma'

char = OpenStruct.new(type: nil)

# implements  Wagner-Fisher algorithm
class WagerFisher
  def initialize
    @matrix = []
    @len1 = 0
    @len2 = 0
  end

  def run(str1, str2)
    @len1 = str1.size
    @len2 = str2.size
    populate_matrix
    edit_distance(str1, str2)
    show_matrix(str1, str2)
    trace_back
  end

  private

  def edit_distance(str1, str2)
    (1..@len2).each do |i|
      (1..@len1).each do |j|
        no_change(i, j) && next if str2[i - 1] == str1[j - 1]
        @matrix[i][j] = [del(i, j), ins(i, j), subst(i, j)].min + 1
      end
    end
  end

  def trace_back
    res = []
    cell = [@len2, @len1]
    while cell != [0, 0]
      current = @matrix[cell[0]][cell[1]]
      val = [[ins(*cell), 'ins', [cell[0], cell[1] - 1]],
             [del(*cell), 'del', [cell[0] - 1, cell[1]]],
             [subst(*cell), 'subst', [cell[0] - 1, cell[1] - 1]]]
            .sort_by(&:first).first
      require "byebug"; byebug
      if val[1] == "subst" and val[0] == current
        val[1] = "same"
      end
      res << val
      cell = val.last
    end
    res
  end

  def del(i, j)
    @matrix[i - 1][j]
  end

  def ins(i, j)
    @matrix[i][j - 1]
  end

  def subst(i, j)
    @matrix[i - 1][j - 1]
  end

  def no_change(i, j)
    @matrix[i][j] = @matrix[i - 1][j - 1]
  end

  def populate_matrix
    @matrix = []
    @matrix << (0..@len1).to_a
    @len2.times do |i|
      ary = [i + 1] + (1..@len1).map { nil }
      @matrix << ary
    end
  end

  def show_matrix(str1, str2)
    puts '|   |   | ' + str1.split('').join(' | ') + ' | '
    @matrix.each_with_index do |ary, i|
      letter = i.zero? ? '|   | ' : '| ' + str2[i - 1] + ' | '
      puts letter + ary.join(' | ') + ' |'
    end
  end
end

wf = WagerFisher.new
puts wf.run(str1, str2)
