class RecordsController < ApplicationController
	before_action :set_record, only: [:show, :edit, :update, :destroy]

	# GET /records
	# GET /records.json
	def index
		@records = Record.all
	end

	# GET /records/1
	# GET /records/1.json
	def show

	end

	# GET /records/new
	def new
		session[:return_to] ||= request.referer
		@goal = Goal.find(params[:goal_id])
		@phase = @goal.phases.most_recent
		@record = Record.new

		respond_to do |format|
		 format.html	# new.html.erb
		 format.json	{ render :json => @record }
	 end
	end

	# GET /records/1/edit
	def edit
	end

	# POST /records
	# POST /records.json
	def create
		@record = Record.new(record_params)

		respond_to do |format|

			if @record.save
				goal_id = Goal.find(Phase.find(@record.phase_id).goal_id)
				@goal_id = Goal.find(goal_id)
				ModelMailer.new_record_notification(@record).deliver
				format.html { redirect_to '/', notice: 'Record was successfully created.' }
				format.json { render action: 'show', status: :created, location: @record }
			else
				format.html { redirect_to :back }
				format.json { render json: @record.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /records/1
	# PATCH/PUT /records/1.json
	def update
		respond_to do |format|
			if @record.update(record_params)
				format.html { redirect_to @record, notice: 'Record was successfully updated.' }
				format.json { render action: 'show', status: :ok, location: @record }
			else
				format.html { render action: 'edit' }
				format.json { render json: @record.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /records/1
	# DELETE /records/1.json
	def destroy
		@record.destroy
		respond_to do |format|
			format.html { redirect_to records_url }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_record
			@record = Record.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def record_params
			params.require(:record).permit(:score, :phase_id, :easiness, :date, :color, :sub_goal, :user_id)
		end
end
