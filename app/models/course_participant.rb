class CourseParticipant < Participant
  belongs_to :course, class_name: 'Course', foreign_key: 'parent_id'
  # Copy this participant to an assignment
  def copy(assignment_id)
    part = AssignmentParticipant.where(user_id: self.user_id, parent_id: assignment_id).first
    if part.nil?
      part = AssignmentParticipant.create(user_id: self.user_id, parent_id: assignment_id)
      part.set_handle
      return part
    else
      return nil # return nil so we can tell a copy is not made
    end
  end

  # provide import functionality for Course Participants
  # if user does not exist, it will be created and added to this assignment
  def self.import(row_hash, _row_header = nil, session, id)
    raise ArgumentError, "The record containing #{row_hash[:name]} does not have enough items." if row_hash.length < self.required_import_fields.length
    user = User.find_by(name: row_hash[:name])
    return unless user.nil?
    user = User.import(row_hash, session, nil)
    course = Course.find_by(id)
    raise ImportError, "The course with the id \"" + id.to_s + "\" was not found." if course.nil?
    unless CourseParticipant.exists?(user_id: user.id, parent_id: id)
      CourseParticipant.create(user_id: user.id, parent_id: id)
    end
  end

  def self.required_import_fields
    {"name" => "Name",
     "fullname" => "Full Name",
     "email" => "Email"}
  end

  def self.optional_import_fields(id=nil)
    {}
  end

  def self.import_options
    {}
  end

  def path
    Course.find(self.parent_id).path + self.directory_num.to_s + "/"
  end
end
