import serial
import time

# Initialize serial connection with appropriate settings
ser = serial.Serial(
    port='COM9',       # Replace with the correct port (e.g., COM3 for Windows or /dev/ttyUSB0 for Linux)
    baudrate=9600,     # Ensure this matches your FPGA UART baud rate
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    timeout=1          # Timeout for reading
)

# Check if the port opened correctly
if ser.is_open:
    print("Serial port opened successfully.")
else:
    print("Failed to open serial port.")

# Example: Sending data to FPGA
def send_data(data):
    if ser.is_open:
        ser.write(data.encode())  # Sending string data
        # ser.write(b'hello')
        print(f"Sent: {data}")

def send_data_bits():
    if ser.is_open:
        # ser.write(data.encode())  # Sending string data
        F = [0, 1, 0, 0, 0, 1, 1, 0]
        bits1 = [0, 0, 0, 0, 1, 1, 1, 1]
        bits2 = [1, 0, 1, 0, 0, 0, 0, 0]
        W = [0, 1, 0, 1, 0, 1, 1, 1]
        bits3 = [0, 1, 1, 1, 1, 1, 1, 1]
        bits4 = [1, 1, 1, 1, 1, 1, 1, 1]
        S = [0, 1, 0, 1, 0, 0, 1, 1]
        c = [0, 1, 1, 0, 0, 0, 1, 1]
        R = [0, 1, 0, 1, 0, 0, 1, 0]
        C = [0, 1, 0, 0, 0, 0, 1, 1]
        for bit in C:
            ser.write(b'\x01' if bit == 1 else b'\x00')
        print(f"Sent bits: {C}")

# Example: Receiving data from FPGA
def receive_data():
    if ser.is_open:
        data = ser.readline().decode('utf-8').strip()  # Reads a line
        print(f"Received: {data}")
        return data
    return None



# Send and receive an example message
send_data('Hello World!')  # Send message to FPGA
time.sleep(0.5)          # Wait briefly for FPGA to respond
response = receive_data()  # Read the response

# Close the serial connection when done
ser.close()
print("Serial port closed.")
