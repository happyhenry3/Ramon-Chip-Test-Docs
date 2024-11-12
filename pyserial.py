import serial
import time
import datetime

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



def send_data_bits():
    if ser.is_open:
        # ser.write(data.encode())  # Sending string data
        # F = [0, 1, 0, 0, 0, 1, 1, 0]
        # bits1 = [0, 0, 0, 0, 1, 1, 1, 1]
        # bits2 = [1, 0, 1, 0, 0, 0, 0, 0]
        # W = [0, 1, 0, 1, 0, 1, 1, 1]
        # bits3 = [0, 1, 1, 1, 1, 1, 1, 1]
        # bits4 = [1, 1, 1, 1, 1, 1, 1, 1]
        # S = [0, 1, 0, 1, 0, 0, 1, 1]
        # c = [0, 1, 1, 0, 0, 0, 1, 1]
        # R = [0, 1, 0, 1, 0, 0, 1, 0]
        # C = [0, 1, 0, 0, 0, 0, 1, 1]
        # config_stream = [0,0,0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,0,1,1,1]
        for bit in config_stream:
            ser.write(b'\x01' if bit == 1 else b'\x00')
        print(f"Sent bits: {config_stream}")

# Example: Sending data to FPGA
def send_data(data):
    if ser.is_open:
        # ser.write(data.encode())  # Sending string data
        ser.write(data)
        print(f"Sent: {data}")

# Example: Receiving data from FPGA
def receive_data():
    if ser.is_open:
        # data = ser.readline().decode('utf-8').strip()  # Reads a line
        data = ser.readline()
        print(f"Received: {data}")
        return data
    return None

now = datetime.datetime.now()
# Define the binary bitstream
bitstream_org = "01001000011001010110110001101100011011110101011101101111"
bitstream_zeros = "00000000000000000000000000000000000000000000000000000000"
bitstream_ones = "11111111111111111111111111111111111111111111111111111111"
bitstream_10 = "10101010101010101010101010101010101010101010101010101010"
bitstream_kk = "01101010011010110110101101101011011010110110101101101100"
bitstream_hello = "01001000011001010110110001101100011011110101011101101111" # 01001000 01100101 01101100 01101100 01101111 01010111 01101111
bitstream_01 = "00110000001100010011000000110001001100000011000100110000"
bitstream_d_freq = "11100101010110000000000000000000000000000000000000000000"
bitstream_c_freq = "11110100010110000000000000000000000000000000000000000000"

bitstream_to_send = bitstream_c_freq

# Split bitstream into 8-bit chunks
byte_strings = [bitstream_to_send[i:i+8] for i in range(0, 56, 8)]

# Convert each 8-bit chunk to an integer, then to a single byte, and store in a bytes object
bitstream_encoded = bytes(int(b, 2) for b in byte_strings)
print(now)
print(f"Send before conversion: {bitstream_to_send}")
# Send and receive an example message
send_data(bitstream_encoded)  # Send message to FPGA
# send_data_bits()
time.sleep(1)          # Wait briefly for FPGA to respond
bitstream_response = receive_data()  # Read the response
bitstream_decoded = ''.join(format(byte, '08b') for byte in bitstream_response)
print(f"Received after conversion: {bitstream_decoded}")

# Close the serial connection when done
ser.close()
print("Serial port closed.\n")
