class Phase < ActiveRecord::Base
	belongs_to :goal, :touch => true

	has_many :records, dependent: :destroy

	after_create :set_baseline_scores

	def set_baseline_scores
		@goal = Goal.find(self.goal_id)
		target = @goal.target
		if self.baseline == true
			(1..7).each do |i|
				self.records.create!(:score => 0, :phase_id => self.id, :easiness => 1, :date => i.day.ago, :color => "#99FF99", :sub_goal => self.subgoal, :user_id => User.find(@goal.user_id).id)
			end
		end
	end

	validates :goal_id, :subgoal, presence: true

	def self.most_recent
		order('created_at DESC').limit(1).first
	end
end