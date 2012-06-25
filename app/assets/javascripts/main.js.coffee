# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  input = $('#tweet-form textarea')
  count = $('#tweet-form .count')
  input.keyup ->
    left = 140 - input.val().length
    if left < 0
      count.addClass 'warn'
    else
      count.removeClass 'warn'
    count.text left
