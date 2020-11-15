class CaseAssignment < ApplicationRecord
  has_paper_trail

  belongs_to :casa_case
  belongs_to :volunteer, class_name: "User", inverse_of: "case_assignments"

  validates :casa_case_id, uniqueness: {scope: :volunteer_id} # only 1 row allowed per case-volunteer pair
  validates :volunteer, presence: true
  validates :casa_case, has_shared_attribute: {shared_attribute: :casa_org, shared_with: :volunteer}
  validate :assignee_must_be_volunteer

  scope :is_active, -> { where(is_active: true) }

  private

  def assignee_must_be_volunteer
    errors.add(:volunteer, "Case assignee must be a volunteer") unless volunteer.is_a?(Volunteer) && volunteer.active?
  end
end

# == Schema Information
#
# Table name: case_assignments
#
#  id           :bigint           not null, primary key
#  is_active    :boolean          default(TRUE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  casa_case_id :bigint           not null
#  volunteer_id :bigint           not null
#
# Indexes
#
#  index_case_assignments_on_casa_case_id  (casa_case_id)
#  index_case_assignments_on_volunteer_id  (volunteer_id)
#
# Foreign Keys
#
#  fk_rails_...  (casa_case_id => casa_cases.id)
#  fk_rails_...  (volunteer_id => users.id)
#
