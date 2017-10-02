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

import processing.serial.*;
import ddf.minim.*;

Minim minim;
int counter = 0;
int counterDown = 0;

PlaySet playset;
AudioPlayer[] playlist;

String code;

void setup() {
  //size(500, 500);
  fullScreen();
  
  initTables();
  initSerial();
  
  code = String.valueOf(year()) + String.valueOf(month()) + String.valueOf(day()) + String.valueOf(hour()) + String.valueOf(minute()) + String.valueOf(second());
  
  minim = new Minim(this);
  playset = new PlaySet(minim, 2); // put the number here!!! > playset = new PlaySet(minim, 0);
  
  fill(255);
  textSize(200);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}

long countdownTimer;

void draw() {
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
      thread("runPlaylist");
    }
  } else {
    background(0);
  }
}

boolean startCountdown = false;

void keyPressed() {
  if (key == ' ') {
    startCountdown = true;
    counterDown = 5;
    playlist = playset.getPlaylist();
    countdownTimer = millis();
  }
}