require 'roo'

class SuggestionsController < ApplicationController
  def index
    query = params[:q].to_s.strip.downcase
    Rails.logger.info "Suggestions query: '#{query}'"
    suggestions = suggestions_from_excel(query)
    render json: { suggestions: suggestions }
  end

  private

  def suggestions_from_excel(query)
    excel_file_path = Rails.root.join('lib', 'data', 'testdata.xls').to_s
    Rails.logger.info "Excel file path: #{excel_file_path}"

    unless File.exist?(excel_file_path)
      Rails.logger.error "Error: Excel file not found at path #{excel_file_path}"
      return []
    end

    begin
      workbook = Roo::Excel.new(excel_file_path)
      sheet = workbook.sheet(0)
      
      if sheet.last_row < 2
        Rails.logger.error "Error: Not enough data in the Excel file."
        return []
      end

      header_row = sheet.row(1).map(&:to_s).map(&:downcase)
      data_rows = (2..sheet.last_row)
      suggestions = []

      data_rows.each do |row_num|
        row = sheet.row(row_num)
        product_data = {}
        header_row.each_with_index do |header_cell, index|
          data_cell = row[index]
          product_data[header_cell] = data_cell.nil? ? '' : data_cell.to_s.strip
        end

        # Skip rows with any empty values.
        next if product_data.values.any? { |v| v.to_s.strip.empty? }

        # Only add the suggestion if the brand starts with the query.
        if product_data['brand'].downcase.start_with?(query)
          filtered = {
            brand: product_data['brand'],
            owner: product_data['owner'],
            'ownership type': product_data['ownership type'] || product_data['ownership_type']
          }
          suggestions << filtered
        end
      end

      Rails.logger.info "Suggestions found: #{suggestions.inspect}"
      suggestions

    rescue => e
      Rails.logger.error "Error reading Excel file for suggestions: #{e.message}"
      []
    end
  end
end
