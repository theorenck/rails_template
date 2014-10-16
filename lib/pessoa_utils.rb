module PessoaUtils

	CPF_LENGTH  = 11
	CNPJ_LENGHT = 14

	CPF_WEIGHTS  = [11,10,9,8,7,6,5,4,3,2]
	CNPJ_WEIGHTS = [6,5,4,3,2,9,8,7,6,5,4,3,2];

	def valid_cpf?(cpf)
		if cpf == nil or cpf.length != CPF_LENGTH 
			return false
		end
		(0..9).each do |e|
  		return false if e.to_s * CPF_LENGTH == cpf 
  	end	
		cpf == calculate_verification_digits(cpf[0..8])
	end

	def valid_cnpj?(cnpj)
		if cnpj == nil or cnpj.length != CNPJ_LENGHT 
			return false
		end
		cnpj == calculate_verification_digits(cnpj[0..11],CNPJ_WEIGHTS)
	end 

	def valid_cpf_or_cnpj?(value)
		if value != nil and value.length > 11
			valid_cnpj? value
		else
			valid_cpf? value
		end
	end 

	def calculate_verification_digit(value, weights = CPF_WEIGHTS)
		sum = 0
		index = value.length - 1
		value.reverse.each_char do | digit |
			sum += digit.to_i * weights[weights.length - value.length + index]
			index -= 1
		end
		sum = 11 - sum % 11
		sum > 9 ? "0" : sum.to_s
	end

	def calculate_verification_digits(value, weights = CPF_WEIGHTS)
		vd1 = calculate_verification_digit value, weights
		vd2 = calculate_verification_digit value + vd1, weights
		value + vd1 + vd2
	end

	def generate_cpf
		cpf_base = ""
		9.times do 
			cpf_base += rand(10).to_s 
		end
		calculate_verification_digits(cpf_base)
	end

	def generate_cnpj(subsidiary = "0001")
		cnpj_root = ""
		8.times do 
			cnpj_root += rand(10).to_s 
		end
		cnpj_base = cnpj_root + subsidiary
		calculate_verification_digits(cnpj_base,CNPJ_WEIGHTS)
	end
end
