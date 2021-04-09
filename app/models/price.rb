class Price < ApplicationRecord

  belongs_to :room

  default_scope { order(:start_date) }

  validates :start_date, :end_date, :day_cost, presence: true
  # проверка разницы начала и конца периода
  validate  :period_check

private

  def period_check
    errors.add(:end_date, "- должен быть позже начала") if end_date < start_date
  end

end
