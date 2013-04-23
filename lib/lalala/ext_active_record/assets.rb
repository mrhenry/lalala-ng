module Lalala::ExtActiveRecord::Assets
  extend ActiveSupport::Concern

  module ClassMethods

    def has_many_assets(name, options={})
      class_name = options.delete(:class_name)
      class_name ||= if name.to_s.include?("image") then "::ImageAsset" else "::FileAsset" end

      attr_accessible :"#{name}_attributes"
      has_many name, class_name: class_name, as: :asset_owner, dependent: :destroy, conditions: { asset_owner_section: name.to_s }
      accepts_nested_attributes_for name, allow_destroy: true
    end

    def has_one_asset(name, options={})
      class_name = options.delete(:class_name)
      class_name ||= if name.to_s.include?("image") then "::ImageAsset" else "::FileAsset" end

      attr_accessible :"#{name}_attributes"
      has_one name, class_name: class_name, as: :asset_owner, dependent: :destroy, conditions: { asset_owner_section: name.to_s }
      accepts_nested_attributes_for name, allow_destroy: true
    end

  end
end
