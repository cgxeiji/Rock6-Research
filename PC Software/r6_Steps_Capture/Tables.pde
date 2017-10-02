Table dataUser, dataExp;

void initTables() {
  dataUser = new Table();
  dataExp = new Table();
  
  dataExp.addColumn("Sample");
  dataExp.addColumn("Timestamp");
  dataExp.addColumn("Beat");
  dataExp.addColumn("Stimulus");
  
  
  dataUser.addColumn("Step");
}