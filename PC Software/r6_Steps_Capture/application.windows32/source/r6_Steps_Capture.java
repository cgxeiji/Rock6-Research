import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import ddf.minim.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class r6_Steps_Capture extends PApplet {

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




Minim minim;
int counter = 0;
int counterDown = 0;

PlaySet playset;
AudioPlayer[] playlist;

String code;

int option = 0;

public void setup() {
  //size(500, 500);
  
  
  initSerial();
  
  minim = new Minim(this);
  playset = new PlaySet(minim); // put the number here!!! > playset = new PlaySet(minim, 0);
  
  fill(255);
  textSize(200);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}

long countdownTimer;

public void draw() {
  background(0);
  if (startCountdown) {
    if (millis() - countdownTimer >= 500) {
      countdownTimer = millis();
      counterDown--;
    }
    if (counterDown != 0) {
      text(counterDown, width / 2, height / 2);  
    } else {
      startCountdown = false;
      switch(option) {
        case 0:
          thread("runPlaylist");
          break;
        case 1:
          thread("runTraining");
          break;
      }
    }
  } else {
    background(0);
  }
  
  if (running) {
    background(0, 0, 100);
    text("+", width / 2, height / 2);  
  }
}

boolean startCountdown = false;

public void keyPressed() {
  if (!running) {
    if (key == ' ') {
      initTables();
      code = String.valueOf(year()) + String.valueOf(month()) + String.valueOf(day()) + String.valueOf(hour()) + String.valueOf(minute()) + String.valueOf(second());
      playlist = playset.getPlaylist();
      countdownTimer = millis();
      
      option = 0;
      counterDown = 5;
      startCountdown = true;
    } else if (key == 't') {
      playlist = playset.getTrainingPlaylist();
      countdownTimer = millis();
      
      option = 1;
      counterDown = 5;
      startCountdown = true;
    }
  }
  
  if (key == 'x') {
    
  }
}
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



int CHUNK = 1;
int SET = 0;

class PlaySet {
  int mode;    // CHUNK - SET
  ArrayList<AudioPlayer> samples;
  IntList base;
  Minim minim;
  
  PlaySet(Minim m) {
    minim = m;
    
    mode = CHUNK;
    samples = new ArrayList<AudioPlayer>();
    base = new IntList();
    
    samples.add(minim.loadFile("loop.wav"));
    samples.add(minim.loadFile("muted.wav"));
    samples.add(minim.loadFile("clipped.wav"));
    
    base.append(0);
    base.append(0);
    base.append(1);
    base.append(1);
    base.append(2);
    base.append(2);
  }
  
  PlaySet(Minim m, int type) {
    minim = m;
    
    mode = CHUNK;
    samples = new ArrayList<AudioPlayer>();
    base = new IntList();
    
    samples.add(minim.loadFile("loop.wav"));
    samples.add(minim.loadFile("muted.wav"));
    samples.add(minim.loadFile("clipped.wav"));
    
    base.append(0);
    base.append(0);
    base.append(0);
    base.append(type);
    base.append(type);
    base.append(type);
  }
  
  public int[] getIndexPlaylist() {
    IntList playlist = base.copy();
    playlist.shuffle();
    playlist.append(0);
    playlist.reverse();
    playlist.append(0);
    return playlist.array();
  }
  
  public AudioPlayer[] getPlaylist() {
    AudioPlayer[] playlist = new AudioPlayer[8];
    
    int[] index = getIndexPlaylist();
    println(index);
    for (int i = 0; i < index.length; i++) {
      playlist[i] = samples.get(index[i]);
    }
    
    return playlist;
  }
  
  public AudioPlayer[] getPlaylist(int s) {
    AudioPlayer[] playlist = new AudioPlayer[8];
    
    for (int i = 0; i < playlist.length; i++) {
      playlist[i] = samples.get(0);
    }
    
    playlist[3] = samples.get(s);
    
    return playlist;
  }
  
  public AudioPlayer[] getTrainingPlaylist() {
    AudioPlayer[] _playlist = new AudioPlayer[4];
    
    for (int i = 0; i < _playlist.length; i++) {
      _playlist[i] = samples.get(0);
    }
    
    return _playlist;
  }
}
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

public void initSerial() {
  device = new Serial(this, Serial.list()[0], 115200);
  println(Serial.list());
  device.bufferUntil(10);
}

public void serialEvent(Serial p) {
  if (running && option == 0) {
    double timestamp = (double)System.nanoTime()/1000000.0f - timer;
    deviceOutput = p.readString();
    
    TableRow row = dataUser.addRow();
    row.setDouble("Step", timestamp);
    
    saveTable(dataUser, code + "user.csv");
  }
}
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

Table dataUser, dataExp;

public void initTables() {
  dataUser = new Table();
  dataExp = new Table();
  
  dataExp.addColumn("Sample");
  dataExp.addColumn("Timestamp");
  dataExp.addColumn("Beat");
  dataExp.addColumn("Stimulus");
  
  
  dataUser.addColumn("Step");
}
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

public void runPlaylist() {
  running = true;
  counter = 0;
  timer = (double)System.nanoTime() / 1000000.0f;
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

public void runTraining() {
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

public void resetPlayback() {
  playlist[counter].pause();
  playlist[counter].rewind();
  playlist[counter].play();
}

double timer;

public void saveData() {
  TableRow row = dataExp.addRow();
  double timestamp = (double)System.nanoTime()/1000000.0f - timer;
  row.setDouble("Timestamp", timestamp);
  String sample = playlist[counter].getMetaData().fileName();
  row.setString("Sample", sample);
  
  row.setDouble("Beat", timestamp);
  
  if (sample != "loop.wav") {
    for (int i = 1; i < 16; i++) {
      TableRow r = dataExp.addRow();
      r.setDouble("Beat", timestamp + 461.538462f * i);
      if (i == 4) {
        r.setString("Stimulus", "o");
      }
    }
    if (sample == "clipped.wav") {
      TableRow r = dataExp.addRow();
      r.setDouble("Beat", timestamp + 461.538462f * 16);
    }
  } else {
    for (int i = 1; i < 16; i++) {
      TableRow r = dataExp.addRow();
      r.setDouble("Beat", timestamp + 461.538462f * i);
    }
  }
  
  saveTable(dataExp, code + "experiment.csv");
  
  println(timestamp);
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "r6_Steps_Capture" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
