# Monitors the state of the tweet form while the user is typing into it. The
# form counts down the number of characters remaining. If the user types more
# than 140 characters, the form displays a warning and disables the submit
# button.
class TweetForm
  MAX = 140

  # Create a new form and start watching the tweet input box for changes.
  constructor: ->
    @form   = $ '#tweet-form'
    @input  = $ '#tweet-form textarea'
    @count  = $ '#tweet-form .count'
    @submit = $ '#tweet-form input[type="submit"]'
    @input.keyup @validate.bind this

  # Returns the number of characters remaining in the composed tweet.
  remaining: ->
    MAX - @input.val().length

  # Updates the state of the form with warning indicators and/or disabling the
  # submit button.
  #
  # options - The options Hash of state changes:
  #  :warn    - Displays the character counter in red if true.
  #  :disable - Disables the submit button if true.
  #
  # Returns nothing.
  state: (options) ->
    @count.toggleClass 'warn', options.warn
    @submit.prop 'disabled', options.disable

  # Changes the state of the form based on the length of the tweet. This should
  # be called each time the user changes the tweet input.
  #
  # Returns nothing.
  validate: ->
    left = @remaining()
    @count.text left
    if left == MAX
      @state warn: false, disable: true
    else if left >= 0
      @state warn: false, disable: false
    else if left < 0
      @state warn: true, disable: true

$ ->
  # Start watching the form when the page loads.
  new TweetForm()
