update tableA set tableA.someColumn = 
(select tableB.otherColumn from tableB where tableA.joiningColumn = tableB.joiningColumn)
where exists
(select tableB.otherColumn from tableB where tableA.joiningColumn = tableB.joiningColumn)