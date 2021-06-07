	.text
	.globl validate_and_preprocess_binary
	
# Valida uma string contendo caracteres bin�rios e remove o terminador de linha 
# se ele existir. Todavia, se a string informada for inv�lida em rela��o � base 
# bin�ria, retornar� 0 como comprimento.
#
# Par�metros: 
#	- $a0: endere�o do primeiro byte da string
#	- $ra: endere�o de retorno para o local de chamada
# Retorno: 
#	- $v0: comprimento efetivo da string ou 0 se ela for inv�lida
validate_and_preprocess_binary:
	
	# Registro que calcular� o tamanho da string
	move $s0, $zero
	
	validate_and_preprocess_binary_start_loop:

		# Acessa o caractere atual e o verifica
		lb $t0, 0 ($a0)
		beq $t0, $zero, validate_and_preprocess_binary_exit_loop
		beq $t0, '\n', validate_and_preprocess_binary_cut_endline
		bne $t0, '0', validate_and_preprocess_binary_check_one
		
		# Avan�a na leitura
		addi $a0, $a0, 1
		addi $s0, $s0, 1
		
		# Volta para o in�cio do la�o
		j validate_and_preprocess_binary_start_loop
		
		# Verifica validade do caractere
		validate_and_preprocess_binary_check_one:
			bne $t0, '1', validate_and_preprocess_binary_invalidation
			addi $a0, $a0, 1
			addi $s0, $s0, 1
			j validate_and_preprocess_binary_start_loop
		
		# Aplica a invalida��o da string se necess�rio
		validate_and_preprocess_binary_invalidation:
			li $s0, 0
			j validate_and_preprocess_binary_exit_loop
		
		# Remo��o do caractere terminador de linha
		validate_and_preprocess_binary_cut_endline:
			li $t0, 0
			sb $t0, 0 ($a0)
	
	validate_and_preprocess_binary_exit_loop:
	
	# Retorno
	move $v0, $s0
	jr $ra
