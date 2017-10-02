Serial device;
String deviceOutput = "";

void initSerial() {
  device = new Serial(this, Serial.list()[0], 115200);
  device.bufferUntil(10);
}

void serialEvent(Serial p) {
  double timestamp = (double)System.nanoTime()/1000000.0 - timer;
  deviceOutput = p.readString();
  
  TableRow row = dataUser.addRow();
  row.setDouble("Step", timestamp);
  
  saveTable(dataUser, code + "user.csv");
}