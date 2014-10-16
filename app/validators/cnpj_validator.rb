#encoding: utf-8
require 'pessoa_utils'

class CnpjValidator < ActiveModel::EachValidator
  
  include PessoaUtils  
  
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "não é um número de CNPJ válido") unless
      value.present? and valid_cnpj? value
  end
end