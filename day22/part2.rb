#!/usr/bin/env ruby
# frozen_string_literal: true
require 'set'

file_path = File.expand_path('input.txt', __dir__)

steps = File.read(file_path).split("\n").map do |a| 
    on = a.split(' ').first == 'on'

    c = a.split(' ').last.split(',').map { |b|
        b.slice(2, b.size-1).split('..').map(&:to_i)
    }

    x1 = c[0][0]
    x2 = c[0][1]

    y1 = c[1][0]
    y2 = c[1][1]

    z1 = c[2][0]
    z2 = c[2][1]

    {
        'x1' => x1,
        'x2' => x2,
        'y1' => y1,
        'y2' => y2,
        'z1' => z1,
        'z2' => z2,
        'on' => on
    }
end

def overlap(c1, c2)
    c = {
        'x1' => [c2['x1'],c1['x1']].max,
        'x2' => [c2['x2'],c1['x2']].min,
        'y1' => [c2['y1'],c1['y1']].max,
        'y2' => [c2['y2'],c1['y2']].min,
        'z1' => [c2['z1'],c1['z1']].max,
        'z2' => [c2['z2'],c1['z2']].min
    }

    return c if c['x1'] <= c['x2'] and c['y1'] <= c['y2'] and c['z1'] <= c['z2']
    nil
end


def area(c)
    (c['x2'] - c['x1'] + 1) * (c['y2'] - c['y1'] + 1) * (c['z2'] - c['z1'] + 1)
end

done = []
cnt = 0

steps.each do |s|
    overlaps = []

    overlaps.push(s) if s['on']
    
    done.each do |d|
        c = overlap(d,s)
        next if c.nil?
        c['on'] = !d['on']
        overlaps.push(c)
    end
    done += overlaps
end


puts done.reduce(0) { |s,c|  s + area(c) * (c['on'] ? 1 : -1)}