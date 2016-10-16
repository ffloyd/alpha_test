module HumanReaders
  extend ActiveSupport::Concern

  class_methods do
    def currency_human_reader_for(*fields)
      fields.each do |field|
        define_method "#{field}_human" do
          value = public_send(field)
          value.round(4)
        end
      end
    end

    def percent_human_reader_for(*fields)
      fields.each do |field|
        define_method "#{field}_human" do
          value = public_send(field)
          "#{(value * 100).round(2)}%"
        end
      end
    end
  end
end
