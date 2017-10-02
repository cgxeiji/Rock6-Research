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

int pSensor;

void setup() {
  Serial.begin(115200);
  while(!Serial);
  pinMode(13, INPUT_PULLUP);
}

void loop() {
  int sensorVal = readSensor(13);
  if (sensorVal == 0 && pSensor == 1) {
    Serial.println("");
  }
  pSensor = sensorVal;
}

int readSensor(int number) {
  int sensor = 0;
  for(int i = 0; i < 128; i++) {
    sensor += digitalRead(number);
  }
  return (sensor > 64);
}
