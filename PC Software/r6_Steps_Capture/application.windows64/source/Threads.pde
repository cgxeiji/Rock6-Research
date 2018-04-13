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

boolean running = false;

void runPlaylist() {
  running = true;
  counter = 0;
  timer = (double)System.nanoTime() / 1000000.0;
  while (counter < playlist.length) {
    playlist[counter].pause();
    playlist[counter].rewind();
    playlist[counter].play();
    thread("saveData");
    println(counter);
    
    while (!playlist[counter].isPlaying()) {
      delay(1);
    }
    while (playlist[counter].isPlaying()) {
      delay(1);
    }
    counter++;
  }
  running = false;
}

void runTraining() {
  running = true;
  counter = 0;
  while (counter < playlist.length) {
    playlist[counter].pause();
    playlist[counter].rewind();
    playlist[counter].play();
    println(counter);
    
    while (playlist[counter].isPlaying()) {
      delay(1);
    }
    counter++;
  }
  running = false;
}

void resetPlayback() {
  playlist[counter].pause();
  playlist[counter].rewind();
  playlist[counter].play();
}

double timer;

void saveData() {
  TableRow row = dataExp.addRow();
  double timestamp = (double)System.nanoTime()/1000000.0 - timer;
  row.setDouble("Timestamp", timestamp);
  String sample = playlist[counter].getMetaData().fileName();
  row.setString("Sample", sample);
  
  row.setDouble("Beat", timestamp);
  
  if (sample != "loop.wav") {
    for (int i = 1; i < 16; i++) {
      TableRow r = dataExp.addRow();
      r.setDouble("Beat", timestamp + 461.538462 * i);
      if (i == 4) {
        r.setString("Stimulus", "o");
      }
    }
    if (sample == "clipped.wav") {
      TableRow r = dataExp.addRow();
      r.setDouble("Beat", timestamp + 461.538462 * 16);
    }
  } else {
    for (int i = 1; i < 16; i++) {
      TableRow r = dataExp.addRow();
      r.setDouble("Beat", timestamp + 461.538462 * i);
    }
  }
  
  saveTable(dataExp, code + "experiment.csv");
  
  println(timestamp);
}