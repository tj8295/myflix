class Admin::TodosController < ApplicationController
  def index
    @todos = Todo.all
  end
end
