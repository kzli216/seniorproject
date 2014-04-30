class Record < ActiveRecord::Base
	belongs_to :phase, :touch => true
#	belongs_to :goal, :touch => true

	validates :score, :easiness, :phase_id, :date, :sub_goal, presence: true
	
	before_create :set_attributes
	after_create :check_entries

	def check_entries
		@phase = Phase.find(self.phase_id)
		@goal = Goal.find(@phase.goal_id)

		if @phase.records.count > 6
			@phase_average = @phase.records.sum(:score)/@phase.records.count
			if @phase_average > @goal.target
				new_sg = @phase_average * 5 / 4
				#YOU'VE ACCOMPLISHED YOUR  GOAL! CONGRATS!

			elsif @goal.type != "Water" #then we are dealing with a minutes-based goal
				#if the baseline data is below 5, set it to 5 minutes
				if @phase.subgoal == 0 && @phase_average < 5
					new_sg = 5
				#if the subgoal is not consistently met, do not increase the subgoal
				elsif @phase.subgoal > @phase_average
					new_sg = @phase.subgoal
				#create new subgoal based on old average
				else
					if @phase_average > 45 
						new_sg = 60
					elsif @phase_average > 35
						new_sg = 45
					elsif @phase_average > 25
						new_sg = 35
					elsif @phase_average > 20
						new_sg = 25
					elsif @phase_average > 15
						new_sg = 20
					elsif @phase_average > 10
						new_sg = 15
					elsif @phase_average >= 5
						new_sg = 10
					end
				end
			else
				#water subgoal
				if @phase.subgoal == 0 && @phase_average < 36
					new_sg = 36
				elsif @phase.subgoal > @phase_average
					new_sg = @phase.subgoal
				else
					if @phase_average > 96
						new_sg = 128
					elsif @phase_average > 64
						new_sg = 96
					elsif @phase_average > 48
						new_sg = 64
					elsif @phase_average >= 36
						new_sg = 48
					end
				end
			end
			@goal.phases.create!(:subgoal => new_sg, :baseline => false, :goal_id =>@phase.goal_id)
			if new_sg > @phase.subgoal
				@goal.money_earned += (@goal.contract_amount / 20)
				if (@phase_average / @goal.target) >= (@goal.money_earned / @goal.contract_amount)
					@goal.money_earned = (@phase_average * @goal.contract_amount / @goal.target)
				end
				if (@goal.money_earned > @goal.contract_amount)
					@goal.money_earned = @goal.contract_amount
				end
				@goal.save
			end
		end
	end

	  def self.from_users_followed_by(user)
	    followed_user_ids = "SELECT followed_id FROM relationships
	                         WHERE follower_id = :user_id"
	    goals = where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
	          user_id: user.id)
	  end	

	def set_attributes
		@phase = Phase.find(self.phase_id)
		@goal = Goal.find(@phase.goal_id)
		@user = User.find(@goal.user_id)

		if self.score >= @phase.subgoal
			self.color = "#25D500"
		elsif self.score >= (8 * @phase.subgoal/ 10 )
			self.color = "#FFFF00"
		else
			self.color = "#FF6666"
		end

		self.user_id = @user.id

		if @phase.baseline == false
			@goal.money_earned = @goal.money_earned + (@goal.contract_amount / 200)
			if self.score >= @phase.subgoal
				@goal.money_earned = @goal.money_earned + (@goal.contract_amount / 200)
			end
			
			if @goal.records.count > 0
				@last_record = @goal.records[-2] #the last record before the one we're making

				if @goal.records.count == 1
					time_since_last_record = self.date - @goal.records.most_recent.date
				else
					time_since_last_record = @goal.records.most_recent.date - @last_record.date
				end
				
				if time_since_last_record.to_i == 1
					@goal.consecutive = @goal.consecutive + 1
					if @goal.consecutive > 2
						@goal.money_earned = @goal.money_earned + (@goal.contract_amount / 100)
					end
				else 
					@goal.consecutive = 1
				end
			else
				@goal.consecutive = 1
			end

			@goal.save
		end
	end

	def self.most_recent
		order('created_at DESC').limit(1).first
	end

	class << self
		def easiness_options
		%w(1 2 3 4 5 6 7)
		end	
	end
end
