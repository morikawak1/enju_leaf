class AddAttachmentToContentType < ActiveRecord::Migration
  def change
    add_column :content_types, :attachment_id, :string
    add_column :content_types, :attachment_file_name, :string
    add_column :content_types, :attachment_size, :integer
    add_column :content_types, :attachment_content_type, :string
  end
end