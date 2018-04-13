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

void initTables() {
  dataUser = new Table();
  dataExp = new Table();
  
  dataExp.addColumn("Sample");
  dataExp.addColumn("Timestamp");
  dataExp.addColumn("Beat");
  dataExp.addColumn("Stimulus");
  
  
  dataUser.addColumn("Step");
}