	.data
	.align 0
	
wellcomeMessage:	.asciiz "Enter an integer: "
binaryString:		.asciiz "00000000000000000000000000000000"

	.text
	.globl main

# Procedimento principal
main:
	# Impress�o da mensagem inicial
	li $v0, 4
	la $a0, wellcomeMessage
	syscall
	
	# Leitura do inteiro
	li $v0, 5
	syscall
	
	# Convers�o inteiro-bin�rio
	move $a0, $v0
	la $a1, binaryString
	jal int_to_bin_str
	
	# Impress�o da string bin�ria
	li $v0, 4
	la $a0, binaryString
	syscall
	
	# Sa�da do programa
	li $v0, 10
	syscall
			
# Converte um valor inteiro para uma string bin�ria
# Par�metros:
#	$a0: valor inteiro a ser convertido
#	$a1: endere�o inicial da string contendo 5 caracteres
#	$ra: endere�o de retorno
int_to_bin_str:
	
	# Armazena os argumentos na pilha
	addi $sp, $sp, -12
	sw $a0, 0 ($sp)
	sw $a1, 4 ($sp)
	sw $ra, 8 ($sp)
	
	# Constante 2
	li $s0, 2
	
	# Impede que o la�o seja percorrido mais do que 32 vezes
	li $s1, 32
	
	# Itera enquanto o valor inteiro n�o for igual a 1
	int_to_bin_str_loop:
		
		# Divide o valor inteiro por 2
		# M�dulo salvo em $t1
		lw $t0, 0 ($sp)
		divu $t0, $s0
		mflo $t0
		mfhi $t1
		sw $t0, 0 ($sp)
		
		# Altera o m�dulo para valor de caractere
		addi $t1, $t1, '0'
		
		# Recupera o endere�o da string da pilha
		lw $t0, 4 ($sp)
		
		# Atualiza o byte da string para o m�dulo da divis�o
		sb $t1, 31 ($t0)
		
		# Decrementa o endere�o da string
		addi $t0, $t0, -1
		
		# Empilha o endere�o da string
		sw $t0, 4 ($sp)
		
		# Valida��o do la�o: iterador igual a 0
		beq $s1, $zero, int_to_bin_str_loop_exit
		
		# Decrementa o iterador
		addi $s1, $s1, -1
		
		# Valida��o do la�o: inteiro igual a 0
		lw $t0, 0 ($sp)
		beq $t0, $zero, int_to_bin_str_loop_exit	
		
		# Retorno do la�o
		j int_to_bin_str_loop	
	
	# Sa�da do la�o
	int_to_bin_str_loop_exit:
		
		# Desempilhamento
		lw $ra, 8 ($sp)
		addi $sp, $sp, 12
		
		# Retorno da fun��o
		jr $ra
	