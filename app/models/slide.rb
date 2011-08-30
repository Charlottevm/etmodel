# == Schema Information
#
# Table name: slides
#
#  id              :integer(4)      not null, primary key
#  controller_name :string(255)
#  action_name     :string(255)
#  name            :string(255)
#  order_by        :integer(4)
#  image           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  sub_header      :string(255)
#  complexity      :integer(4)      default(1)
#  sub_header2     :string(255)
#  subheader_image :string(255)
#  key             :string(255)
#

class Slide < ActiveRecord::Base
  has_paper_trail

  has_one :description, :as => :describable
  has_many :input_elements, :order => "order_by"

  validates :key, :presence => true, :uniqueness => true

  scope :controller, lambda {|controller| where(:controller_name => controller) }
  scope :action, lambda {|action| where(:action_name => action) }
  scope :max_complexity, lambda {|complexity| where("complexity <= #{complexity}") }
  
  accepts_nested_attributes_for :description

  def search_result
    SearchResult.new(name, description)
  end

  define_index do
    indexes name
    indexes description(:content_en), :as => :description_content_en
    indexes description(:content_nl), :as => :description_content_nl
    indexes description(:short_content_en), :as => :description_short_content_en
    indexes description(:short_content_nl), :as => :description_short_content_nl
  end

  def parsed_name_for_admin
    "#{action_name.andand[0..30]} | #{name}"
  end
  
  def image_path
    "/images/layout/#{image}" if image.present? 
  end

  def title_for_description
    "slidetitle.#{name}"
  end

end
