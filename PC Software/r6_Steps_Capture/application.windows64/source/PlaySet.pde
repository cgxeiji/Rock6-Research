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

import ddf.minim.*;

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
  
  int[] getIndexPlaylist() {
    IntList playlist = base.copy();
    playlist.shuffle();
    playlist.append(0);
    playlist.reverse();
    playlist.append(0);
    return playlist.array();
  }
  
  AudioPlayer[] getPlaylist() {
    AudioPlayer[] playlist = new AudioPlayer[8];
    
    int[] index = getIndexPlaylist();
    println(index);
    for (int i = 0; i < index.length; i++) {
      playlist[i] = samples.get(index[i]);
    }
    
    return playlist;
  }
  
  AudioPlayer[] getPlaylist(int s) {
    AudioPlayer[] playlist = new AudioPlayer[8];
    
    for (int i = 0; i < playlist.length; i++) {
      playlist[i] = samples.get(0);
    }
    
    playlist[3] = samples.get(s);
    
    return playlist;
  }
  
  AudioPlayer[] getTrainingPlaylist() {
    AudioPlayer[] _playlist = new AudioPlayer[4];
    
    for (int i = 0; i < _playlist.length; i++) {
      _playlist[i] = samples.get(0);
    }
    
    return _playlist;
  }
}