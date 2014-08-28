class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  include Filters
  before_filter :authenticate_user!

  # GET /tasks
  # GET /tasks.json
  def index
    filter_all
    
    @tasks = Task.roots
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    filter_all
    
    @tasks = Task.roots
    @task = Task.find(params['id'])
    
    ### 
    ### Try taking this part out and replacing with index view
    ###
    respond_to do |format|
      format.html {render 'index', locals: {task: @task, show_children: true, depth: 0}}
      format.json {''}
    end
    
    ###
    ### respond_to do |format|
    ###   format.html { render 'show', locals: {task: @task, show_children: true, depth: 0}}
    ###   format.json { render partial: 'show_content', locals: {task: @task, show_children: true}}
    ### end
  end

  # GET /tasks/new
  def new
    @task = Task.new(parent_params)
    @task.master = current_user
    
    render :partial => 'form', locals: {task: @task}
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params['id'])
    render partial: 'form', locals: {task: @task}
  end

  # POST /tasks
  # POST /tasks.json
  def create
        
    @task = Task.new(task_params)
    @task.master = current_user
    if params.has_key?('parent_id')
      @task.parent = Task.find(params['parent_id'])
    else
      @task.teammates = [current_user]
    end
        
    respond_to do |format|
      if @task.save
        if @task.team
          format.json { render partial: 'show', locals: {task: @task, depth: 0, show_children: false}}
        else
          format.json { render partial: 'show', locals: { task: @task, show_children: true}, notice: 'Task was successfully created.' }
        #format.json { render partial: 'show', locals: { task: @task, show_children: true}, status: :created, location: @task }
        end
      else
        #format.html { render partial: 'form' }
        format.json { render partial: 'form', locals: {task: @task, show_children: true}, notice: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render partial: 'show_content', locals: {task: @task, show_children: true}} 
      else
        format.html { render action: 'edit' }
        format.json { render partial: 'form',locals: {task: @task, show_children: true}, notice: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parent_params
      params.permit(:parent_id)
    end
    
    def task_params
      params.require(:task).permit(:statement, :next_action, :status, :master_id, {:teammate_ids => []})      
    end
end
