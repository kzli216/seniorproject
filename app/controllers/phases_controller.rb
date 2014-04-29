class PhasesController < ApplicationController
	def index
			@phases = Phase.all
	end

	def show
	end

	def new
		@phase = Phase.new
	end

	def edit
	end

	def create
		@goal = Goal.find(params[:id])

		@phase = @goal.build(phase_params)

		if @phase.save
			redirect_to @goal, notice: "@phase was successfully created."
		else
			render action: 'new'
		end
	end
end
