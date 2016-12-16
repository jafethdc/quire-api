class ProductImage < ApplicationRecord
  before_validation :parse_image
  attr_accessor :img_base

  belongs_to :product, inverse_of: :product_images

  has_attached_file :img, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validate :img_base_existence, if: :new_record?
  validates :img, attachment_presence: true
  do_not_validate_attachment_file_type :img

  validates :product, presence: true

  private
    def parse_image
      image = Paperclip.io_adapters.for(img_base)
      image.original_filename = self.img_file_name
      self.img = image
    end

    def img_base_existence
      unless self.img_base
        self.errors.add(:img, 'not provided')
      end
    end
end
