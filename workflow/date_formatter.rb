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

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  if ARGV.length == 0
    now = gen_now_t
    fb.add_item(title: now[:second], subtitle: '10位秒级别时间戳')
    fb.add_item(title: now[:millisecond], subtitle: '13位毫秒级别时间戳')
  end

  puts fb.to_alfred(ARGV)
end
