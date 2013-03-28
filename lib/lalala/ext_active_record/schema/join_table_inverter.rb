module Lalala::ExtActiveRecord::Schema::JoinTableInverter
  extend ActiveSupport::Concern

  def invert_create_join_table(*args)
    [:drop_join_table, args]
  end

end
