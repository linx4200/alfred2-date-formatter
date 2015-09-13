#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require './bundle/bundler/setup'
require 'alfred'

def gen_now_t
  now = Time.now
  {
    millisecond: (now.to_f * 1000).to_i.to_s,
    second: (now.to_i).to_s
  }
end

def parse_time_stamp(ts)
  ts = ts[0..9] if ts.length === 13
  Time.at(ts.to_i)
end

def date_formate(time)
  time.strftime('%Y-%m-%d %T').to_s
end

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  # puts ARGV.length
  if ARGV.length == 0
    now = gen_now_t
    fb.add_item(title: now[:second], subtitle: '10位秒级别时间戳')
    fb.add_item(title: now[:millisecond], subtitle: '13位毫秒级别时间戳')
  end

  if ARGV[0] && (ARGV[0].length === 10 || ARGV[0].length === 13)
    args = ARGV[0];
    time = date_formate(parse_time_stamp(args.to_s))
    fb.add_item(title: time, subtitle: '解析时间戳')
  end

  puts fb.to_alfred
end
