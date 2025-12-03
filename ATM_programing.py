# name="kesava"
# password="5689"
# user_name=input("Enter the user name:")
# passwords=input("Enter the password:")
# p='''
#     1. credit
#     2. debit
#     3. mini statement
#     4. exit
#     '''
# Amount=1000
# if name== user_name and password==passwords:
#     print(p)
#     option=int(input("Enter the option:"))
#     if option==1:
#      Credit_amount=float(input("Enter the amount:"))
#     print("amount after credited", Amount + Credit_amount)
# else:
#     print("wrong number Entered:")

name="kesava"
password="5678"
Uesr_name=input("Enter the user name:")
passwords=input("Enter the password:")
F='''
 1.crdit
 2.debit
 3.mini statement
 4.exit
 '''
Amount=1000
if name==Uesr_name and passwords==password:
    print(F)
    while True:        
        option=int(input("Enter the option:"))
        if option==1:
            credit_amount=float(input("Enter the amount:"))
            print("amount after credit",Amount + credit_amount)
        elif option==2:
            debit_amount=float(input("Enter the amount:"))
            print("amount after debit",Amount-debit_amount)
        elif option==3:
            print("amount:",Amount)
        elif option==4:
            break     
else:
        print("you are entered wrong number:")
    
     
    
     
