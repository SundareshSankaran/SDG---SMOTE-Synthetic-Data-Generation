cas ss;
caslib _ALL_ assign;

/* WORKS */

proc cas;
   loadactionset "smote";
   action smoteSample result=r/
      table={name="hmeq", caslib="PUBLIC"},
      inputs={"REASON", "JOB", "BAD" },
      nominals={"REASON", "JOB", "BAD"},
      classColumn="BAD",
      classToAugment=1,
      seed=10,
      numSamples=1000,
      casout={name="out",replace="TRUE"};
      print r;
run;
quit;

/* Fails */

cas ss;
caslib _ALL_ assign;


proc cas;
   loadactionset "smote";
   action smoteSample result=r/
      table={name="hmeq", caslib="PUBLIC"},
      inputs={"REASON", "JOB"},
      nominals={"REASON", "JOB", "BAD"},
      classColumn="BAD",
      classToAugment=1,
      seed=10,
      numSamples=1000,
      casout={name="out",replace="TRUE"};
      print r;
run;
quit;

/*

NOTE: CASLIB Samples for session SS will be mapped to SAS Library SAMPLES.
NOTE: CASLIB benelux for session SS will be mapped to SAS Library BENELUX.
82   
83   
84   proc cas;
85      loadactionset "smote";
86      action smoteSample result=r/
87         table={name="hmeq", caslib="PUBLIC"},
88         inputs={"REASON", "JOB"},
89         nominals={"REASON", "JOB", "BAD"},
90         classColumn="BAD",
91         classToAugment=1,
92         seed=10,
93         numSamples=1000,
94         casout={name="out",replace="TRUE"};
95         print r;
96   run;
NOTE: Active Session now SS.
NOTE: Added action set 'smote'.
ERROR: For the 'NOMINALS' parameter, the 'BAD' column does not appear in 'INPUTS or TABLE'.
ERROR: The action stopped due to errors.
{}
97   quit;
NOTE: PROCEDURE CAS used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds

      */;


/* Also Fails: */

proc cas;
   loadactionset "smote";
   action smoteSample result=r/
      table={name="hmeq", caslib="PUBLIC"},
      inputs={"REASON", "JOB"},
      nominals={"REASON", "JOB"},
      classColumn="BAD",
      classToAugment=1,
      seed=10,
      numSamples=1000,
      casout={name="out",replace="TRUE"};
      print r;
run;
quit;

/*
96   run;
NOTE: Active Session now SS.
NOTE: Added action set 'smote'.
ERROR: For the 'classColumn' parameter, the 'BAD' column does not appear in 'INPUTS'.
ERROR: The action stopped due to errors.
{}
97   quit;

*/;



      cas ss terminate;

      