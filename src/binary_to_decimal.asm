	.text
	.globl binary_to_decimal
	
# Par�metros: 
#	- $a0: endere�o do primeiro byte da string binaria
#	- $a1: comprimento da string binaria
#	- $ra: endere�o de retorno para o local de chamada
#
# Retorno:
#	- $v0: endere�o do primeiro byte da string decimal
#	- $v1: comprimento da string decimal


#$t0 - valor
#$t1 carregado
#$t2 endere�o relativo
#$t3 multi
#$t4 valor binario
#$t5 multi 2
binary_to_decimal :
	move $t0, $zero 
	move $v1, $zero
	mul $t2, $a1, 4 # endere�o final da string binaria em rela��o ao inicio dela	
	addu $t3, $zero, 1 #$t3 � usado como valor da multiplicador da base binaria
	add $t5, $zero , 1
	add $t6, $zero , 10
	
	binary_register:#passa o valor binaria da string para um registrador($t0) em unsigned int 32
		
		addu $t1,$a0,$t2 #passa para $t1 o endere�o da posi��o de menor valor ainda n�o computada da string binaria
		lw $t4,($t1)
		mul $t4, $t4,$t3
 		addu $t0, $t0, $t4
 		
		beq $a0, $t1, register_decimal #se o ender�o computado for o mesmo do inicio da string, sai do loop
		
		add $t2, $t2, -4
		#usar 1 shift para esquerda em $t5
		
		j binary_register
	
	register_decimal :#passa o valor de $t0 para uma string
		add $v1, $v1 ,1
		div $t0,$t6
		mflo $t0  	#$t0=$t0/$t6
		mfhi $t1	#$t1=$t0//$t6	
		
		sw $t1,($t2)	#salva o valor de $t1 no endere�o $t2
		add $t2, $t2, 4 #soma mais 4 no endere�o de $t2
		bne $t0, $zero, register_decimal #loop:enquando valor de $t0/10 diferente de 0
	
	move $v0, $a0
	jr $ra
