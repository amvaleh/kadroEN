class FreeTime < ApplicationRecord

  after_save :log_it
  default_scope -> { order(start: :asc) }

  validates :day,   inclusion: {in: 1..8}, presence: true, numericality: true # '1' for Saturday and '7' for Friday
  validates :start, presence: true
  validates :end,   presence: true
  validates :photographer_id, presence: true
  validate :start_range
  validate :end_range
  belongs_to :photographer

  after_update :photographer_update
  before_create :create_full_day
  before_create :remove_olders

  def create_full_day
    if self.day == 8
      (1..6).each do |day|
        FreeTime.create(:day => day , :photographer_id => self.photographer_id , :start => self.start , :end => self.end)
      end
      self.day = self.day - 1
    end
  end

  def remove_olders
    olders = FreeTime.where(:day => self.day , :photographer_id => self.photographer_id)
    if olders.any?
      olders.each do |older|
        if times_overlap?(older.start.strftime("%H:%M"),older.end.strftime("%H:%M"),self.start.strftime("%H:%M"),self.end.strftime("%H:%M"))
          older.destroy
        end
      end
    end
  end

  def photographer_update
    photographer.update(:updated_at => Time.now)
  end


  private
  def log_it
    log = FreeTimesHistory.new(day: self.day, start: self.start, end: self.end, photographer_id: self.photographer.id)
    log.save
  end

  def start_range
    unless self.start.to_formatted_s(:time).to_time.between?('1:00am'.to_time, '9:30pm'.to_time)
      errors.add(:start, "زمان شروع باید در بازه مجاز باشد")
    end
  end

  def end_range
    unless self.end.to_formatted_s(:time).to_time.between?('1:00am'.to_time, '12:30am'.to_time+1.day)
      errors.add(:end, "زمان پایان باید در بازه مجاز باشد")
    end
  end

  def times_overlap?(start_time, end_time, start_bound, end_bound)
    start_time.between?(start_bound, end_bound) || end_time.between?(start_bound, end_bound) || start_bound.between?(start_time , end_time) || end_bound.between?(start_time , end_time)
  end

end
