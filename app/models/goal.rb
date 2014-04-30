class Goal < ActiveRecord::Base
	belongs_to :user

	scope :waters, -> { where(type: 'Water') }
	scope :yogas, -> { where(type: 'Yoga') }
	scope :exercises, -> { where(type: 'Exercise') }
	scope :runs, -> { where(type: 'Run') }
	scope :meditates, -> { where(type: 'Meditate') }
	scope :journals, -> { where(type: 'Journal') }

	validates :user_id, :type, :target, :measure, presence: true

	has_many :phases, dependent: :destroy
	has_many :records, :through => :phases

	accepts_nested_attributes_for :phases
	accepts_nested_attributes_for :records

	after_create :start_baseline

	def start_baseline
		if self.starting == true
			self.phases.create!(:subgoal => 0, :baseline => true, :goal_id => self.id)
		else
			self.phases.create!(:subgoal => 0, :baseline => false, :goal_id => self.id)
#			 self.phases.create!(:subgoal => 0, :baseline => true, :goal_id => self.id)
		end
	end

	def most_recent_update
		if self.records.count > 0
			self.records.last.created_at
		else
			self.created_at
		end
	end

#		if @goal.starting == true
#			create scores for past week and set all scores to zero
#		else
#			 ask them to input score for today
#		end

	def self.most_recent
		order('created_at DESC').limit(1).first
	end

	def self.current=(u)
		@current_goal = u
	end

	def self.current
		@current_goal
	end

	def contract_amount
		5000
	end

	class << self
		def types
			%w(water yoga exercise run journal meditate)
		end

		def water_cups_options
			%w(4 6 8)
		end

		def water_ounces_options
			%w(36 48 64 96 128)
		end

		def water_measures
			%w(ounces)
		end

		def minutes_options
			%w(10 15 30 45 60)
		end

		def minutes_measures
			%w(minutes)
		end
	end
end
