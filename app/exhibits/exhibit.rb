# An Exhibit is a specialized decorator that pairs a model class with a view
# context. It decorates the model with view specific methods so the model
# can focus on business logic.
#
# The exhibit delegates all method calls to the decorated model object, but
# subclasses are free to intercept methods and add their own behavior before
# or after passing the method call to the model.
#
# This pattern is a cleaner alternative to procedural Rails helper methods.
# If a view template needs a URL or calculated value from the model, it's better
# to decorate the model with an exhibit rather than writing a helper function.
class Exhibit < SimpleDelegator

  # Decorate a list of model objects with an exhibit view.
  #
  # models - An Array of objects to decorate. Nil entries are ignored and not
  #          included in the returned Array.
  # view   - The mustache view context.
  #
  #   UserExhibit.wrap(users, view)
  #
  # Returns an Array of exhibits.
  def self.wrap(*models, view)
    models.flatten.compact.map {|obj| new(obj, view) }
  end

  attr_reader :model, :view

  # Wrap a model object with an exhibit decorator that adds behavior needed
  # for view generation.
  #
  # model - The ActiveModel object to decorate.
  # view  - The mustache view context used to generate URLs.
  def initialize(model, view)
    @model, @view = model, view
    super(model)
  end

  # Override the class method to return the wrapped model's class, so Rails
  # believes it's dealing directly with the model, not the decorator.
  def class
    __getobj__.class
  end
end

