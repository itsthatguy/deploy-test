#!/usr/bin/env coffee
fs    = require('fs')
path  = require('path')
spawn = require('child_process').spawn
exec  = require('child_process').exec

arr = []

tree = spawn('git', ['ls-tree', 'other:source', '-r', '--name-only'])

tree.stdout.on 'data', (data) ->
  arr = data.toString().split('\n').filter (f) -> return f if f != ''
  return arr.sort (a, b) -> return a.length-b.length

tree.on 'close', (code) ->
  listFiles(arr) if code == 0

listFiles = (arr) ->
  for value, i in arr
    file = "source/#{value}"
    dir = path.dirname(file)
    fs.mkdirSync(dir) unless fs.existsSync(dir)
    exec "git show other:#{file} >#{file}", (err, stdout, stderr) ->
      console.log stdout
