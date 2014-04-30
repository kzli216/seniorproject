class GoalsController < ApplicationController
    before_filter :authenticate_user!
    before_action :set_goal, only: [:show, :edit, :update, :destroy]
    before_action :set_type
    before_action :set_measure
    
    def index
        @goals = type_class.all

        respond_to do |format|
            format.html 
            format.json { render json: @goals }
        end
    end

    def show
        @records = @goal.records.all.sort_by(&:date)
    end

    def new
        @goal = type_class.new

        respond_to do |format|
            format.html    # new.html.erb
            format.json    { render :json => @goal }
        end
    end

    def edit
    end

    def create
        @goal = current_user.goals.build(goal_params)

        respond_to do |format|
            if @goal.save
                format.html { redirect_to @goal, notice: "#{type} was successfully created." }
                format.js
                format.json {render json: @goal, status: :Created, location: @goal }
            else
                format.html {render action: 'new'}
                format.json {render json: @goal.errors, status: :unprocessable_entity}
            end
        end
    end

    def update
        respond_to do |format|
            if @goal.update_attributes(params[:goal])
                format.html { redirect_to @goal, notice: '#{type} was successfully updated.' }
                format.json { head :no_content }
           else
                format.html { render action: "edit" }
                format.json { render json: @goal.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @goal.destroy
        respond_to do |format|
            format.html { redirect_to sti_goal_path(@goal.type) }
            format.js
            format.json { head :no_content }
        end
    end

    def dashboard
        @records = @goal.records.all
    end

    def inactivate
        @goal = Goal.find(params[:id])
        @goal.commitment_contract = false 
        @goal.save
        redirect_to @goal
    end

private

    def accepted_type
        (AcceptedModels & params[:type]).first
    end

    AcceptedMeasures = ["ounces", "minutes"]

    def accepted_measures
        (AcceptedMeasures & params[:measure]).first
    end

    def set_type
        @type = type
    end

    def type
        params[:type] || "Goal"
    end

    def set_measure
        if @type == "Water"
            @measure = "ounces"
        else
            @measure = "minutes"
        end
    end

    def type_class
        type.constantize
    end

    def type_classes
        type.pluralize.constantize
    end

    def set_goal
        @goal = type_class.find(params[:id])
        Rails.cache.write("current_goal", @goal)
    end

    def sti_goal_path(type = "goal", goal = nil, action = nil)
        Rails.logger.info "FIFOU #{format_sti(action, type, goal)}_path"
        send "#{format_sti(action, type, goal)}_path", goal
    end

    def format_sti(action, type, goal)
        action || goal ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
    end

    def format_action(action)
        action ? "#{action}_" : ""
    end

    def goal_params
        params.require(type.downcase.to_sym).permit(:type, :target, :user_id, :measure, :starting, :customer_id, :commitment_contract, :money_earned)
    end

    def record_params
        params.require(:record).permit(:score, :phase_id, :easiness, :date)
    end
end