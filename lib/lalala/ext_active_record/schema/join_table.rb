module Lalala::ExtActiveRecord::Schema::JoinTable
  extend ActiveSupport::Concern

  # Create a join table
  #
  # @example
  #   create_table(:posts, :comments)
  #   create_table({:users => :author_id, :comments => :comment_id})
  #   create_table(:comments_authors, [:user_id, :comment_id])
  def create_join_table(*args)
    table_name, columns, options = _ng_normalize_options(args)

    create_table table_name, :id => false do |t|
      columns.each do |column|
        t.send(options[:type], column)
      end
    end

    if index_options = options[:index]
      add_index(table_name, columns, index_options)
    end
  end

  def drop_join_table(*args)
    table_name, columns, options = _ng_normalize_options(args)
    drop_table table_name
  end

private

  def _ng_stringish?(a)
    Symbol === a or String === a
  end

  def _ng_validate_hash_options(options)
    unless options.size == 2
      raise ArgumentError, "expected arguments of format { :table_a => :fk_a, :table_b => :fk_b }"
    end

    unless options.keys.all? { |v| _ng_stringish?(v) }
      raise ArgumentError, "expected arguments of format { :table_a => :fk_a, :table_b => :fk_b }"
    end

    unless options.values.all? { |v| _ng_stringish?(v) }
      raise ArgumentError, "expected arguments of format { :table_a => :fk_a, :table_b => :fk_b }"
    end
  end

  def _ng_normalize_options(args)
    options = args.extract_options!

    if args.size == 0
      args << options
      options = {}
    end

    options = {
      type:  :integer,
      index: {}
    }.merge(options)

    options[:index] = {
      unique: true
    }.merge(options[:index])

    if args.size == 2 and _ng_stringish?(args[0]) and _ng_stringish?(args[1])
      a = args[0].to_s
      b = args[1].to_s
      args = [{ a => a.singularize + "_id", b => b.singularize + "_id" }]
    end

    if args.size == 1 and Hash === args[0] and args[0].size == 2
      _ng_validate_hash_options(args[0])

      columns = args[0].values.map(&:to_s).sort
      keys    = args[0].keys.map(&:to_s).sort

      table_name = keys.join('_')

      args = [table_name, columns]
    end

    unless args.size == 2 and _ng_stringish?(args[0]) and Array === args[1]
      raise ArgumentError, "invalid arguments for create_join_table()"
    end

    table_name = args[0]
    columns    = args[1]

    [table_name, columns, options]
  end

end

