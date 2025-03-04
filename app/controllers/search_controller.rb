require 'roo'

class SearchController < ApplicationController
  def search
    query = params[:q].to_s.strip  # Ensure the query is stripped of leading/trailing spaces
    results = search_products_from_excel(query)
    render json: { query: query, results: results }
  end

  private

  def search_products_from_excel(query)
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

      results = []

      data_rows.each do |row_num|
        row = sheet.row(row_num)

        product_data = {}
        header_row.each_with_index do |header_cell, index|
          data_cell = row[index]
          product_data[header_cell] = data_cell.nil? ? '' : data_cell.to_s.strip
        end

        Rails.logger.info "Row #{row_num} data: #{product_data.inspect}"

        # Skip this row if any value is nil or empty
        next if product_data.values.any? { |v| v.to_s.strip.empty? }

        # Check if any field contains the query (case-insensitive)
        if product_data.values.any? { |value| value.downcase.include?(query.downcase) }
          # Build a hash containing only the desired keys, e.g., brand, owner, and ownership type.
          filtered = {
            brand: product_data['brand'],
            owner: product_data['owner'],
            ownership_type: product_data['ownership type'] || product_data['ownership_type']
          }
          results << filtered
          Rails.logger.info "Match found in row #{row_num}: #{filtered.inspect}"
        end
      end

      Rails.logger.info "Total results found: #{results.count}"
      results

    rescue => e
      Rails.logger.error "Error processing Excel file: #{e.message}"
      return []
    end
  end
  
end
