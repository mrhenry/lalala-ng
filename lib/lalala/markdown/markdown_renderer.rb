class Lalala::Markdown::MarkdownRenderer < Redcarpet::Render::Base

  NEW_BLOCK = "\n\n"

  def initialize(options)
    super()

    @list_items       = []

    @table_cell_index = 0
    @table_cells      = []
    @table_rows       = []
    @table_alignments = []
  end

  # ```ruby
  # 1 + 2 # => 3
  # ```
  def block_code(code, language)
    "```#{language}\n#{code.strip}\n```" + NEW_BLOCK
  end

  # > quote
  # > new line
  def block_quote(quote)
    "> " + quote.strip.gsub("\n", "\n> ") + NEW_BLOCK
  end

  def block_html(html)
    html.strip + NEW_BLOCK
  end

  def header(text, level)
    ("#" * level) + " " + text.strip + NEW_BLOCK
  end

  def hrule
    "---" + NEW_BLOCK
  end

  def list(content, type)
    case type
    when :ordered
      ordered_list
    when :unordered
      unordered_list
    end

  ensure
    @list_items = []
  end

  def unordered_list
    items = @list_items.map do |item|
      "- " + item.gsub("\n", "\n  ")
    end

    items.join("\n") + NEW_BLOCK
  end

  def ordered_list
    items = []
    width = @list_items.size.to_s.size + 2

    @list_items.each_with_index do |item, idx|
      prefix = (idx + 1).to_s + ". "

      if prefix.size < width
        prefix += (" " * (width - prefix.size))
      end

      item = item.gsub("\n", "\n" + (" " * width))

      item = prefix + item
      items << item
    end

    items.join("\n") + NEW_BLOCK
  end

  def list_item(content, type)
    @list_items << content.strip
    content
  end

  def paragraph(content)
    content.strip + NEW_BLOCK
  end

  def table(header, body)
    column_count = @table_rows.first.size
    widths       = Array.new(column_count, 0)

    # determine the maximum widths of all the columns
    @table_rows.each do |row|
      row.each_with_index do |cell, idx|
        w = cell.size
        if widths[idx] < w
          widths[idx] = w
        end
      end
    end

    rows       = @table_rows
    alignments = @table_alignments

    delimiter_row = Array.new(column_count, "")
    alignments.each_with_index do |_, idx|
      width = widths[idx]

      case alignments[idx]
      when :right
        cell = ("-" * (width - 1)) + ":"
      when :center
        cell = ":" + ("-" * (width - 2)) + ":"
      else
        cell = ("-" * width)
      end

      delimiter_row[idx] = cell
    end

    Rails.logger.debug alignments.inspect

    if header.size > 0
      rows.insert(1, delimiter_row)
    else
      rows.insert(0, delimiter_row)
    end

    rows = rows.map do |row|
      cells = []
      row.each_with_index do |cell, idx|
        width = widths[idx]

        case alignments[idx]
        when :right
          cell = (" " * (width - cell.size)) + cell
        when :center
          half_width = (width - cell.size) / 2.0
          cell = (" " * half_width.floor) + cell + (" " * half_width.ceil)
        else
          cell = cell + (" " * (width - cell.size))
        end

        cell = " " + cell + " "

        cells << cell
      end

      "|" + cells.join("|") + "|"
    end

    rows.join("\n") + NEW_BLOCK

  ensure
    @table_rows = []
    @table_alignments = []
  end

  def table_row(content)
    if @table_alignments_builder
      @table_alignments = @table_alignments_builder
    end

    @table_rows.push(@table_cells)

    content
  ensure
    @table_cells = []
    @table_cell_index = 0
  end

  def table_cell(content, alignment)
    @table_cells << content

    if @table_cell_index >= @table_alignments.size
      @table_alignments.push(nil)
    end

    if alignment
      @table_alignments[@table_cell_index] = alignment
    end

    content

  ensure
    @table_cell_index += 1
  end

  def autolink(link, link_type)
    link
  end

  def codespan(code)
    "`" + code + "`"
  end

  def double_emphasis(text)
    "**" + text + "**"
  end

  def emphasis(text)
    "*" + text + "*"
  end

  def image(link, title, alt_text)
    if title.blank?
      "![#{alt_text}](#{link})"
    else
      "![#{alt_text}](#{link} \"#{title}\")"
    end
  end

  def linebreak()
    "  \n"
  end

  def link(link, title, content)
    if title.blank?
      "[#{content}](#{link})"
    else
      "[#{content}](#{link} \"#{title}\")"
    end
  end

  def raw_html(raw_html)
    raw_html
  end

  def triple_emphasis(text)
    "***" + text + "***"
  end

  def strikethrough(text)
    "~~~" + text + "~~~"
  end

  def superscript(text)
    "^" + text
  end

  def entity(text)
    text
  end

  def normal_text(text)
    text
  end

end
