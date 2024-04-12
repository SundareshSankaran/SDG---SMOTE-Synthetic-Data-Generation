/*-----------------------------------------------------------------------------------------*
   EXECUTION CODE MACRO 

   _smt prefix stands for SMOTE
*------------------------------------------------------------------------------------------*/

%macro _smt_execution_code;

    proc cas;
        
        numK = symget("numK");
        inputTableCaslib = symget("inputTableCaslib");
        inputTableName = symget("inputTableName");
        blankSeparatedNominalVars = symget("blankSeparatedNominalVars");
        blankSeparatedInputVars = symget("blankSeparatedInputVars");
        classColumnVar = symget("classColumn");
        classToAugment = symget("classToAugment");
        seedNumber = symget("seedNumber");
        numThreads = symget("numThreads");
        numSamplesVar = symget("numSamples");
        outputTableCaslib = symget("inputTableCaslib");
        outputTableName = symget("outputTableName");

        smote.smoteSample result=r/
            table={name=inputTableName, caslib=inputTableCaslib},
            k = numK,
            nominals=${&blankSeparatedNominalVars.},
            classColumn=classColumnVar,
            classToAugment=classToAugment,
            seed=seedNumber,
            nThreads = numThreads,
            numSamples=numSamplesVar,
            casout={name=outputTableName,caslib= outputTableCaslib, replace="TRUE"};
      print r;
run;
    quit;

%mend _smt_execution_code;