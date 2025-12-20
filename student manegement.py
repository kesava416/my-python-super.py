students ={}

def add_Student():
    try:
        sid = int(input("Enter Student id: "))
        if sid in students:
            print("Student id already exists")
            return 
        name = input("Enter name:")
        marks = int(input("Enter marks: "))
        students[sid] ={"name": name, "marks": marks}
        print("student added successfully")
    except ValueError:
        print("invalid input")
        
def view_students():
        if not students:
            print("No student found")
            return
        for sid, data in students.items():
            print(sid, data["name"], data["marks"])
        
        
def search_student():
        sid = int(input("Enter student id to search: "))
        if sid in students:
           s = students[sid]
           print(" id:",sid)
           print("name:", s["name"])
           print("Marks:", s["marks"])
        else:
           print("student not found")
        
def update_marks():
        sid = int(input(" Enter student id to update: "))
        if sid in students:
            marks = int(input("Enter new marks: "))
            students[sid] ["marks"] = marks        
            print("marks updated")
        else:
            print("student not found")
            
def delete_student():
        sid = int(input("Enter student Id to delete"))
        if sid in students:
            del students[sid]
            print("student deleted")
        else:
            print("student not found")
            
while True:
        print("\n--- student management system ---")
        print("1. add student")
        print("2. view student")
        print("3. search student")
        print("4. update marks")
        print("5. delete student")
        print("6. Exit")
        
        choice = input("Enter your choice: ")
        
        if choice=="1":
            add_Student()
        elif choice=="2":
            view_students()
        elif choice=="3":
            search_student()
        elif choice=="4":
            update_marks()
        elif choice=="5":
            delete_student()
        elif choice=="6":
            print("thank you. Existing..")
            break
        else:
            print("invalid choice")
        