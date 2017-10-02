/* 
 * This file is part of the Rock6-Research distribution (https://github.com/cgxeiji/Rock6-Research).
 * Copyright (c) 2017 Eiji Onchi.
 * 
 * This program is free software: you can redistribute it and/or modify  
 * it under the terms of the GNU General Public License as published by  
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

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