.data
filename: .asciiz "C:/Users/barbi/Desktop/HelloWorld.txt" #caminho completo do arquivo que ser� lido
fileWords: .space 1024 #string que vai receber as palavras do arquivo lido

.text 
.globl main

main:
     #primeiro LER O ARQUIVO
     li $v0, 13 # open_file syscall c�digo = 13                                      # file flag:
     la $a0, filename #obter o nome do arquivo                                       # 0 = read file
     li $a1, 0        # a flag para ler o arquivo � 0                                # 1 = write file
     syscall                                                                         # utilizamos 0 porque queremos ler
     move $s0, $v0
     
     #ler o arquivo
     li $v0, 14  #ler arquivo c�digo do syscall = 14
     move $a0, $s0 #descreve o arquivo
     la $a1, fileWords #o buffer que separa as strings 
     la $a2, 1024 #tamanho do buffer
     syscall
     
     #imprime as palavras lidas do arquivo
     li $v0, 4 #ler a string sycall = 4
     la $a0, fileWords
     syscall
     
     #fecha o arquivo 
     li $v0, 16                     #close_file syscall c�digo = 16
     move $a0, $s0                  # file descrpitor close
     syscall