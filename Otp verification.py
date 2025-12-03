import smtplib
from email.message import EmailMessage
import random
import time
# Generate OTP
otp = str(random.randint(1000, 9999))
otp_lifetime = 60
start_time = time.time()
# Email setup
from_mail = "peetanikesavarao@gmail.com"
to_mail = input("Enter your mail: ")

msg = EmailMessage()
msg['Subject'] = "Your OTP Code"
msg['From'] = from_mail
msg['To'] = to_mail
msg.set_content("Your OTP is: " + otp)
# Use SMTP with SSL
with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
    server.login(from_mail,'lzlmpkkrxhncepqm')  # Use app password here
    server.send_message(msg)

print("OTP sent successfully!")

user_input = input("Enter the OTP sent to your email: ")
elapsed_time = time.time() -start_time
if elapsed_time > otp_lifetime:
    print("your otp expired! please request a new one.")    
elif user_input == otp:
    print("OTP Verified Successfully!")
else:
    print("Invalid OTP.")



