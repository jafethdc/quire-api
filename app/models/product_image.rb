class ProductImage < ApplicationRecord
  before_validation :parse_image, if: :new_record?

  attr_accessor :img_base

  belongs_to :product, inverse_of: :images

  has_attached_file :img, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates :img, attachment_presence: true
  do_not_validate_attachment_file_type :img

  validates :product, presence: true
  validate :product_accepts_more_images

  private
    def parse_image
      # img is nil if img_base is nil
      self.img = Paperclip.io_adapters.for(img_base)
    end

    def product_accepts_more_images
      if product
        # Currently, I've recognized two scenarios:
        # When you're creating the image from the model and just setting a product_id
        # i.e. ProductImage.create(product_attributes+product_id)

        # When you're creating the image from an association
        # i.e. a_product.images.create(product_attributes)

        # To get to know which one the current instance is in, we just check with the following
        from_association = product.images.include? self

        if from_association
          # In this case the product could have many pending-to-save images.
          if product.images.size > 5
            errors.add(:product, 'has too many images')
          end
        else
          # In this case, we only care about the already persisted ones
          persisted_count = product.images.select{ |i| i.persisted? }.size
          if persisted_count >= 5
            errors.add(:product, 'hast too many images')
          end
        end
      end
    end
end
