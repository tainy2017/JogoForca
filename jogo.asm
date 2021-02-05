.data

usadas: .space 50
linha: .asciiz "-"
win: .ascii "\|/ "
win2: .asciiz "VOCÊ VENCEU! PARABÉNS!!!"
loose2: .asciiz "VOCÊ PERDEU. :( "
nl: .asciiz "\n"
sp: .asciiz " "
array2: .space 1024
words: .space 1
spaces: .asciiz "\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n"
texto: .asciiz "VIDAS: "
texto1: .asciiz "LETRA? "
head: .asciiz "  0"
torso: .asciiz "\n  |"
left: .asciiz "./"
right: .asciiz "\."
msg1: .asciiz "Digite uma palavra: \n"
fig: .asciiz "  0 \n./|\. \n  | \n./ \."
creditos: .asciiz "PROJETO OAC - DUPLA CLOVIJAN E MAGDA"
titulo: .asciiz "JOGO DA FORCA"

filename: .asciiz "C:/Users/barbi/Desktop/HelloWorld.txt" #caminho completo do arquivo que será lido
fileWords: .space 1024 #string que vai receber as palavras do arquivo lido
array:      .space 1024
size:       .word   20
string:     .space  20000
text:       .asciiz "As strings no array são:"
novaLinha:    .asciiz "\n"
buffer:  .space  20000
contador: .word 0 #contador que vai incrementar a cada palavra lida, valor 0 inicialmente

.text

lerArquivo:
     #Abrir ARQUIVO                                                               #OBSERVAÇÃO:
     li $v0, 13       # Abre o arquivo código = 13                                # File flag:
     la $a0, filename #carrega o arquivo no endereço a0                           # 0 = ler o arquivo
     li $a1, 0        # a flag para ler o arquivo é 0                             # 1 = escrever no arquivo
     syscall          #---------- Abre arquivo                                    # utilizamos 0 porque queremos apenas ler
     move $s0, $v0
     
     #Ler ARQUIVO
     li $v0, 14       #ler arquivo código do syscall = 14
     move $a0, $s0    #descreve o arquivo      --------file_descriptor
     la $a1, array    #o buffer que separa as strings  ----------- endereço do buffer
     la $a2, 1024     #tamanho do buffer ------------
     syscall          #---------- ler arquivo

     #Imprime as palavras lidas do arquivo
  #   li $v0, 4        #ler a string, código syscall = 4
  #   la $a0, array    #endereço da string  --------buffer contem o valor
   #  syscall          #imprime
    
     #Fecha ARQUIVO 
     li $v0, 16       #Fecha arquivo código = 16
     move $a0, $s0    # file descrpitor close
     syscall

guardaPalavrasArquivo:  
#Exibe título do jogo
la $a0,titulo
li $v0,4
syscall

li $s2,0

la $a0,array          # Carrega no endereço $a0 o array com espaço 50, que vai receber a palavra lida
la $a1,1024            # Carrega no endereço $a1 
li $v0,4              # ler a string, código syscall = 4
syscall

la $t0,array          # carrega o endereço da string no array em t0 
la $t1,array2

#contador de linhas do array
contaLinhas:
    loop: 
    slt $t0, $s1, $s3  #compara i com n, enquanto i<n, continua, ou seja, não chegou ao fim do array
    beq $t0, $zero, end  #quando chegar no fim, sai por end

    la $t1, array       # Pegar o endereço do array e passa para $t1
    add $t2, $t1, $s1           # Somar com i resultando no endereço de X[i]
    addi $s1, $s1, 1  #incrementando o ponteiro
    j loop
    end: #retorna a quantidade de posições no array
	move $v0, $s1 # v0 <- contador
	jr $ra # return v0
	
#gerar random sorteando uma das linhas do array
random:
li $v0, 42 
li $a0, 0 #seleciono o gerador ramdom 0
li $a1, 25
#li $a1, 26 #delimito o tamanho do ramdom  tamanho de linhas no array t3
syscall #gera random int e retorna em $a0 
li $v0, 1 #serviço 1 -> imprime int
syscall #imprime random int gerado
#sll $t2, $a0, 1 # indice gerado aleatorio
#sw $t2, 0($sp) # indice colocado na memoria 
j random

#Acessar a linha do array que foi sorteada randômicamente
selecionaLinhaSorteada:
jal contaLinhas
move $t3, $v0 #  numero de linhas do array em t3

srl $t3, $t3, 1		
li $a0, 0
move $a1, $t3
add $s1 ,$zero, $zero  #inicializei s1 com 0 para o random
blt $s0,61,random #gerar random 


#Acessar a posicao sorteada correspondente ao indice no array
la $t4, array  # coloco o endereço do array em t1
#lw $a0, 0($sp) #carrega indice guardado na memória com valor de random
move $t2, $v0 #obter o numero random sorteado, que será o indice do array
add $t2, $t2, $t2    # dobra o index
add $t2, $t2, $t2    # dobra o indice 4x
add $t1, $t2, $t4   # combina os dois endereços 
lw $t0, 0($t1)       # obtem o valor da posicao 0 do array
sw $t0, 0($t1) 	

count:
lb $s0,($t0)
blt $s0,61,pregame
add $t0,$t0,1
add $s2,$s2,1 #s2 - número de letras
j count

pregame: #espaço de acordo com o tamanho da palavra selecionada do array
la $a0,spaces
li $v0,4
syscall
la $a0,spaces
li $v0,4
syscall
la $a0,spaces
li $v0,4
syscall

misterio:
beq $s6,$s2,jogo
la $t9,linha
lb $t8,($t9)
sb $t8,($t1)
add $t1,$t1,1
add $s6,$s6,1
j misterio

jogo:
la $a0,array2
li $v0,4
syscall

li $s4,1 #//decide as vidas
li $s6,0 #contador s6, s2 numero de letras
li $t4,7 #quantidade de vidas (tentativas) está em t4, são 7 vidas
la $t0,array
la $t1,array2
lb $s0,($t0)
lb $s1,($t1)
la $t2,linha
lb $t3,($t2) #t3 = " - "
la $t5,usadas #t5 = array de usadas

in:
la $a0,nl
li $v0,4
syscall

la $a0,texto1
li $v0,4
syscall

la $a0,words
li $v0,8
syscall

lb $s7,($a0) #letra introduzida = $s8
sb $s7,($t5)
li $s4,1
li $s6,0
la $t1,array2

verify: #introduzida pertence? --> para saber se desconta ou não uma vida
bne $s7,$s0,next
hit:
li $s4,0 #introduzida pertence!
sb $s7,($t1)
add $t0,$t0,1
add $t1,$t1,1
lb $s0,($t0)
lb $s1,($t1)
add $s6,$s6,1
beq $s6,$s2,letters
j verify

next:
add $t0,$t0,1
add $t1,$t1,1
lb $s0,($t0)
lb $s1,($t1)
add $s6,$s6,1
beq $s6,$s2,letters
j verify

letters:
li $s6,0 #contador  
li $t7,0 #nº de letras usadas
la $t0,array
la $t1,array2
lb $s1,($t1)
lb $s0,($t0)

used:
blt $s5,61,checkwin #conta número letras usadas! $t7
add $t7,$t7,1
add $t5,$t5,1
lb $s5,($t5)
j used

checkwin:
beq $s1,$t3,lifes
beq $s6,$s2,end1
add $t1,$t1,1
lb $s1,($t1)
add $s6,$s6,1
j checkwin

lifes:
bne $s4,0,loose #s4 = 0 --> acertou letra introduzida
lifes1: beq $t4,1,vida5
beq $t4,2,vida4
beq $t4,3,vida3
beq $t4,4,vida2
beq $t4,5,vida1

printer:
la $a0,nl
li $v0,4
syscall

la $a0,array2
li $v0,4
syscall

la $a0,nl
li $v0,4
syscall

la $a0,texto
li $v0,4
syscall

move $a0,$t4
li $v0,1
syscall

add $t5,$t5,1 #prepara posição para a próxima letra introduzida
j in

loose:
beq $t4,0,end2
sub $t4,$t4,1
j lifes1


end1:
la $a0,nl
li $v0,4
syscall
la $a0,nl
li $v0,4
syscall
la $a0,nl
li $v0,4
syscall

la $a0,win
li $v0,4
syscall

la $a0,nl
li $v0,4
syscall

la $a0,array2
li $v0,4
syscall
la $a0,nl
li $v0,4
syscall

la $a0,creditos
li $v0,4
syscall

li $v0,10
syscall

end2:  
la $a0,nl
li $v0,4
syscall
la $a0,nl
li $v0,4
syscall
la $a0,nl
li $v0,4
syscall

la $a0,loose2
li $v0,4
syscall
la $a0,nl
li $v0,4
syscall

la $a0,fig
li $v0,4
syscall
la $a0,nl
li $v0,4
syscall

la $a0,creditos
li $v0,4
syscall

li $v0,10
syscall

vida1:
la $a0,head
li $v0,4
syscall
j printer

vida2:
la $a0,head
li $v0,4
syscall
la $a0,torso
li $v0,4
syscall
j printer

vida3:
la $a0,head
li $v0,4
syscall

la $a0,nl
li $v0,4
syscall

la $a0,left
li $v0,4
syscall
la $a0,torso
li $v0,4
syscall
j printer

vida4:
la $a0,head
li $v0,4
syscall

la $a0,nl
li $v0,4
syscall

la $a0,left
li $v0,4
syscall
la $a0,sp #espaço
li $v0,4
syscall
la $a0,right
li $v0,4
syscall
la $a0,torso
li $v0,4
syscall
j printer

vida5:
la $a0,head
li $v0,4
syscall

la $a0,nl
li $v0,4
syscall

la $a0,left
li $v0,4
syscall
la $a0,sp
li $v0,4
syscall
la $a0,right
li $v0,4
syscall
la $a0,torso
li $v0,4
syscall

la $a0,nl
li $v0,4
syscall

la $a0,left
li $v0,4
syscall
la $a0,sp #espaço
li $v0,4
syscall
la $a0,right
li $v0,4
syscall
j printer
