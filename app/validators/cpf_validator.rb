#encoding: utf-8
require 'pessoa_utils'

class CpfValidator < ActiveModel::EachValidator

  include PessoaUtils
  
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "não é um número de CPF válido") unless
      value.present? and valid_cpf? value
  end
end