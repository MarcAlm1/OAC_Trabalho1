	.data
	.align 0

# Strings de entrada
wellcomeMessage:	.asciiz "Wellcome to Base Converter.\nWhen a base is requested, consider \'B\', \'D\' and \'H\' as binary, decimal and hexadecimal bases respectively."
inputBaseRequest:	.asciiz "\nEnter input base: "
inputBinNumRequest:	.asciiz "\nEnter binary number: "
inputDecNumRequest:	.asciiz "\nEnter decimal number: "
inputHexNumRequest:	.asciiz "\nEnter hexadecimal number: "
outputBaseRequest:      .asciiz "\nEnter output base: "

# Strings de sa�da
outputNumMessage:	.asciiz "\nYour final number is: "
invalidBaseMessage:	.asciiz "\nInformed base is invalid."

	.text
	.globl main

# Procedimento principal
main:
	# Impress�o da mensagem inicial
	li $v0, 4
	la $a0, wellcomeMessage
	syscall
	
	# Impress�o da solicita��o de base de entrada
	li $v0, 4
	la $a0, inputBaseRequest
	syscall
	
	# L� a base de entrada e a empilha
	addi $sp, $sp, -2
	li $v0, 8
	la $a0, 0 ($sp)
	li $a1, 2
	syscall
	
	# Recupera o primeiro caractere da string e a desempilha
	lb $t0, 0 ($sp)
	addi $sp, $sp, 2
	
	# Chaveia em rela��o � base selecionada
	beq $t0, 'B', bin_input_base
	beq $t0, 'D', dec_input_base
	beq $t0, 'H', hex_input_base
	j invalid_base_exception
	
	# Base de entrada bin�ria
	bin_input_base:
	
		# Impress�o da mensagem de inser��o do n�mero
		li $v0, 4
		la $a0, inputBinNumRequest
		syscall
		
		# Leitura da string bin�ria
		addi $sp, $sp, -33
		li $v0, 8
		la $a0, 33 ($sp)
		li $a1, 33
		syscall
		
		# C�lculo do tamanho efetivo da string bin�ria e remo��o do terminador de linha se ele existir
		la $a0, 33 ($sp)
		jal get_strlen_and_cut_endline
		
		# Gera o decimal intermedi�rio
		la $a0, 33 ($sp)
		move $a1, $v0
		jal TODO
		move $t0, $v0
		
		# Desempilha a string e empilha o decimal intermedi�rio
		addi $sp, $sp, 33
		addi $sp, $sp, -4
		sw $t0, 0 ($sp)
		
		j main_output_base_select
	
	# Base de entrada decimal
	dec_input_base:
	
		# Impress�o da mensagem de inser��o do n�mero
		li $v0, 4
		la $a0, inputDecNumRequest
		syscall
		
		# Obten��o e empilhamento do decimal de entrada
		addi $sp, $sp, -4
		li $v0, 5
		syscall
		sw $v0, 0 ($sp)
	
		j main_output_base_select
	
	# Base de entrada hexadecimal
	hex_input_base:
	
		# Impress�o da mensagem de inser��o do n�mero
		li $v0, 4
		la $a0, inputHexNumRequest
		syscall
		
		# Leitura da string hexadecimal
		addi $sp, $sp, -9
		li $v0, 8
		la $a0, 9 ($sp)
		li $a1, 9
		syscall
		
		# C�lculo do tamanho efetivo da string bin�ria e remo��o do terminador de linha se ele existir
		la $a0, 9 ($sp)
		jal get_strlen_and_cut_endline
		
		# Gera o decimal intermedi�rio
		la $a0, 9 ($sp)
		move $a1, $v0
		jal TODO
		move $t0, $v0
		
		# Desempilha a string e empilha o decimal intermedi�rio
		addi $sp, $sp, 9
		addi $sp, $sp, -4
		sw $t0, 0 ($sp)
		
		j main_output_base_select
	
	# Sele��o da base de sa�da
	main_output_base_select:
	
		# Impress�o da mensagem de solicita��o
		li $v0, 4
		la $a0, outputBaseRequest
		syscall
		
		# L� a base de sa�da e a empilha
		addi $sp, $sp, -2
		li $v0, 8
		la $a0, 0 ($sp)
		li $a1, 2
		syscall
	
		# Recupera o primeiro caractere da string e a desempilha
		lb $t0, 0 ($sp)
		addi $sp, $sp, 2
		
		# Impress�o da mensagem final
		li $v0, 4
		la $a0, outputNumMessage
		syscall
		
		# Chaveia em rela��o � base selecionada
		beq $t0, 'B', bin_output_base
		beq $t0, 'D', dec_output_base
		beq $t0, 'H', hex_output_base
		j invalid_base_exception
	
	# Base de sa�da bin�ria
	bin_output_base:
		lw $a0, 0 ($sp)
		li $a1, 2
		jal TODO2
		j main_exit
	
	# Base de sa�da decimal
	dec_output_base:
		li $v0, 1
		lw $a0, 0 ($sp)
		syscall
		j main_exit
	
	# Base de sa�da hexadecimal
	hex_output_base:
		lw $a0, 0 ($sp)
		li $a1, 16
		jal TODO2
		j main_exit
		
	# Exce��o de base inv�lida
	invalid_base_exception:
		li $v0, 4
		la $a0, invalidBaseMessage
		syscall
		li $v0, 10
		syscall
	
	# Sa�da do procedimento principal
	main_exit:
		addi $sp, $sp, 4
		li $v0, 10
		syscall


# Calcula o tamanho de uma string e remove o terminador de linha se ele existir
# Par�metros: 
#	- $a0: endere�o do primeiro byte da string
#	- $ra: endere�o de retorno para o local de chamada
# Retorno: 
#	- $v0: comprimento efetivo da string informada
get_strlen_and_cut_endline:
	
	# Registro que calcular� o tamanho da string
	move $s0, $zero
	
	# Usado para verificar final de linha
	li $s1, '\n'
	
	strlen_start_loop:

		# Acessa o caractere atual e o verifica
		lb $t0, 0 ($a0)
		beq $t0, $zero, strlen_exit_loop
		beq $t0, $s1, strlen_cut_endline
		
		# Avan�a na leitura
		addi $a0, $a0, 1
		addi $s0, $s0, 1
		
		# Volta para o in�cio do la�o
		j strlen_start_loop
		
		# Remo��o do caractere terminador de linha
		strlen_cut_endline:
			li $t0, 0
			sb $t0, 0 ($a0)
	
	strlen_exit_loop:
	
	# Retorno
	move $v0, $s0
	jr $ra


# CONVERS�O PARA DECIMAL INTERMEDI�RIO
TODO:
	li $v0, 100
	jr $ra
	
# IMPRESS�O NA BASE SOLICITADA
TODO2:
	li $v0, 1
	li $a0, 99999
	syscall
	jr $ra
