class Bikes:
    def __init__(self,Bike_name,Bike_cubicapacity,Bike_milege,Bike_price):
       self.a = Bike_name
       self.b = Bike_cubicapacity
       self.c = Bike_milege
       self.d = Bike_price
    
    def Bike_Data(self):
        print("Bike Name:", self.a)
        print("Bike cubicapacity:", self.b)
        print("Bike milege:", self.c)
        print("Bike price:", self.d)
while True:
    name=input("Enter the Bike name: ")
    cubicapacity=int(input("Enter the cubicapacity: "))
    milege=float(input("Enter the milege: "))
    price=float(input("Enter the Price: "))
    
    Bike_obj=Bikes(name,cubicapacity,milege,price)
    Bike_obj.Bike_Data()
       