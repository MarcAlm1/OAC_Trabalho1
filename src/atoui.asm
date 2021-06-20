	.data
	.align 0

# Inteiro sem sinal m�ximo para palavras de 32 bits
MAX_UNSIGNED_INTEGER_WORD: .asciiz "4294967295"

	.text
	.globl atoui
	
# Obt�m um inteiro sem sinal de uma string em codifica��o ASCII e pr�-validada.
#
# Par�metros: 
#	- $a0: endere�o do primeiro byte da string
#	- $a1: comprimento efetivo da string
#	- $ra: endere�o de retorno para o local de chamada
# Retorno: 
#	- $v0: inteiro de sa�da. Retornar� 0 se n�o suportar o tamanho do inteiro representado
atoui:
	# Verifica o comprimento (se > 10, ent�o � inv�lida: n�mero m�ximo = 4,294,967,295)
	bgt $a1, 10, max_atoui_invalidation
	
	# Posiciona-se ao final da string
	add $a0, $a0, $a1
	addi $a0, $a0, -1
	
	# Calcular� o inteiro
	li $s0, 0
	
	# Far�o a adapta��o decimal
	li $s1, 1
	li $s2, 10
	
	# Caso de verifica��o do inteiro m�ximo
	beq $a1, 10, max_atoui
	
	atoui_start_loop:
	
		# Verifica a perman�ncia na string
		beq $a1, $zero, atoui_exit_loop
	
		# Acessa o caractere atual
		lb $t0, 0 ($a0)
		
		# C�lculo
		addi $t0, $t0, -48
		mul $t0, $t0, $s1
		mul $s1, $s1, $s2
		add $s0, $s0, $t0
		
		# Avan�a na leitura
		addi $a0, $a0, -1
		addi $a1, $a1, -1
		
		# Volta para o in�cio do la�o
		j atoui_start_loop
	
	max_atoui:
		# Carrega o endere�o do �ltimo caractere efetivo da string constante
		la $s3, MAX_UNSIGNED_INTEGER_WORD + 9		
	
	max_atoui_start_loop:
	
		# Verifica a perman�ncia na string
		beq $a1, $zero, atoui_exit_loop

		# Acessa caractere atual de ambas as strings e as compara
		lb $t0, 0 ($a0)
		lb $t1, 0 ($s3)
		bgt $t0, $t1, max_atoui_invalidation
		
		# C�lculo
		addi $t0, $t0, -48
		mul $t0, $t0, $s1
		mul $s1, $s1, $s2
		add $s0, $s0, $t0
		
		# Avan�a na leitura
		addi $a0, $a0, -1
		addi $a1, $a1, -1
		addi $s3, $s3, -1
		
		# Volta para o in�cio do la�o
		j atoui_start_loop
	
	max_atoui_invalidation:
		li $s0, 0
	
	atoui_exit_loop:
	
	# Retorno
	move $v0, $s0
	jr $ra
