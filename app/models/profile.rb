class Profile < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  belongs_to :library, :validate => true
  belongs_to :user_group
  belongs_to :required_role, :class_name => 'Role', :foreign_key => 'required_role_id' #, :validate => true

  validates_associated :user_group, :library #, :agent
  validates_presence_of :user_group, :library, :locale #, :user_number
  validates :user_number, :uniqueness => true, :format => {:with => /\A[0-9A-Za-z_]+\Z/}, :allow_blank => true

  index_name "#{name.downcase.pluralize}-#{Rails.env}"

  after_commit on: :create do
    index_document
  end

  after_commit on: :update do
    update_document
  end

  after_commit on: :destroy do
    delete_document
  end

  settings do
    mappings dynamic: 'false', _routing: {required: true, path: :required_role_id} do
      indexes :user_number
      indexes :full_name
      indexes :note
    end
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  user_group_id    :integer
#  library_id       :integer
#  locale           :string(255)
#  user_number      :string(255)
#  full_name        :text
#  note             :text
#  keyword_list     :text
#  required_role_id :integer
#  state            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#
