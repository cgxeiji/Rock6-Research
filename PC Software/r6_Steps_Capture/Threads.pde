boolean running = false;

void runPlaylist() {
  running = true;
  playlist[counter].play();
  timer = (double)System.nanoTime() / 1000000.0;
  thread("saveData");
  while (counter < playlist.length - 1) {
    if (!playlist[counter].isPlaying()) {
      playlist[counter].pause();
      playlist[counter].rewind();
      counter++;
      playlist[counter].play();
      thread("saveData");
      println(counter);
    }
    delay(1);
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