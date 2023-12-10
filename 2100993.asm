.data
.text


main:
lw $t3,0($a1)   #address of y0
lw $t4,4($a1)   #address of h
lw $t5,8($a1)    #address of step

lb $a0,0($t3)
addi $a0,$a0,-48
lb $a1,0($t4)
addi $a1,$a1,-48
lb $a2,0($t5)       #no.of steps
addi $a2,$a2,-48

add $t3,$0,$0
add $t4,$0,$0
add $t5,$0,$0

      jal euler_fn
      j EndofCode 
euler_fn : add $s0,$a1,$0    #s0 =h
           add $a1,$a0,$0    #a1=y0
           add $a0,$0,$0    #a0 = x0 = 0
           addi $sp,$sp,-4
           sw $ra,0($sp)
     tag:  add $t8,$0,$0
           add $s2,$0,$0
           jal Equation
 h_m: beq $t8,$s0,NewY     
      add $s2,$s2,$v1  #s2= h*m
      addi $t8,$t8,1 
      j h_m
NewY: 
      add $a0,$a0,$s0       #xn+1= xn+h
      beq $a2,$0,Finale
      add $a1,$a1,$s2      #yn+1 = yn+ h*m(xn,yn)
      addi $t9,$t9,1 
      beq $t9,$a2,Finale                  
      j  tag 
   
Finale: add $v0,$a1,$0
        lui $at,4097
        sw $v0 ,0($at)
        lw $ra ,0($sp)
        addi $sp,$sp,4
        jr $ra
                
Equation: addi $sp, $sp,-12
          sw $ra,0($sp)
          sw $a0,4($sp)
          sw $a1,8($sp)     #a1 bottom
          add $v1,$0,$0
          sll $t0,$a1,4
          sll $t1,$a1,3
          sll $t2,$a1,1
          
          add $v1,$t1,$t0
          add $v1,$v1,$t2             #26y
          
          sll $t0,$a0,6      #64x
          sll $t1,$a0,1      #2x
          add $t1,$t1,$a0    #2x+x
          add $v1,$v1,$t1
          add $v1,$v1,$t0            #67x
          
          addi $v1,$v1,11            # return= 67x+26y+11
          add $t0,$0,$0
          add $t1,$0,$0
          add $t2,$0,$0
          
          jal function
          jal eight_eight
          add $v1,$v1,$t6        #return = 88y^2+67x+26y+11   #perfecto
          
          jal eightSevenNine
          sub $v1,$v1,$t4       #return= 879y^3+88y^2+67x+26y+11
          
          add $a1,$a0,$0       #let y=x
          add $t0,$0,$0
          add $t1,$0,$0
          add $t2,$0,$0
          
          jal function
          jal nine_four
          sub $v1,$v1,$t7
          
          jal sixsevenone
          add $v1,$v1,$t5
          lw $ra,0($sp)
          lw $a0,4($sp)
          lw $a1,8($sp)
          addi $sp,$sp,12          
          jr $ra
          
function: addi $s7,$0,-1
          slt $s6,$a1,$0    #s6 has 1 when a1 is -ve
          beq $s6,$0,square
          add $s5,$a1,$0
          sub $a1,$s7,$a1
          add $a1,$t1,$a1  #a1 is the positive value of our number
          addi $a1,$a1,1
square:  beq $t0,$a1,cube 
         add $t1,$t1,$a1  
         addi $t0,$t0,1
         j square
        
cube: beq $t3,$a1,Exit    #input t1
      add $t2,$t2,$t1     # result in t2
      addi $t3,$t3,1
      j cube        
 
Exit: 
      beq $s5,$0,bara
      add $a1,$s5,$0   #retrieve a1
      add $s5,$0,$0
      sub $t2,$s7,$t2
      addi $t2,$t2,1
                 
bara: add $t0,$0,$0
      add $t3,$0,$0
      add $s6,$0,$0
      jr $ra

sixsevenone: addi $t0,$0,671
    six_s_o: beq $t0,$t3,no      #input t2
             add $t5,$t5,$t2    #result in t5
             addi $t3,$t3,1
             j six_s_o

eightSevenNine: addi $t0,$0,879      #input t2
eightsn : beq $t0,$t3,no              #result in t4
         add $t4,$t4,$t2
         addi $t3,$t3,1
         j eightsn

eight_eight: addi $t0,$0,88
eight_e:     beq  $t0,$t3,no     #input t1
             add  $t6,$t6,$t1     #result in t6
             addi $t3,$t3,1
             j eight_e
             
nine_four: addi $t0,$0,94
nine_f   : beq  $t0,$t3,no      #input t1
           add  $t7,$t7,$t1     #result in t7
           addi $t3,$t3,1
           j nine_f
           
no: add $t0,$0,$0
    add $t3,$0,$0
    jr $ra

EndofCode:
