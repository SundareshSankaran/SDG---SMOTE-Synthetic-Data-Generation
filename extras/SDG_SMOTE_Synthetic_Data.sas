/*-----------------------------------------------------------------------------------------*
   Macro to capture indicator and UUIDof any currently active CAS session.
   UUID is not expensive and can be used in future to consider graceful reconnect.

   Input:
   1. errorFlagName: name of an error flag that gets populated in case the connection is 
                     not active. Provide this value in quotes when executing the macro.
                     Define this as a global macro variable in order to use downstream.
   2. errorFlagDesc: Name of a macro variable which can hold a descriptive message output
                     from the check.
                     
   Output:
   1. Informational note as required. We explicitly don't provide an error note since 
      there is an easy recourse(of being able to connect to CAS)
   2. UUID of the session: macro variable which gets created if a session exists.
   3. errorFlagName: populated
   4. errorFlagDesc: populated
*------------------------------------------------------------------------------------------*/

%macro _env_cas_checkSession(errorFlagName, errorFlagDesc);
    %if %sysfunc(symexist(_current_uuid_)) %then %do;
       %symdel _current_uuid_;
    %end;
    %if %sysfunc(symexist(_SESSREF_)) %then %do;
      %let casSessionExists= %sysfunc(sessfound(&_SESSREF_.));
      %if &casSessionExists.=1 %then %do;
         %global _current_uuid_;
         %let _current_uuid_=;   
         proc cas;
            session.sessionId result = sessresults;
            call symputx("_current_uuid_", sessresults[1]);
         quit;
         %put NOTE: A CAS session &_SESSREF_. is currently active with UUID &_current_uuid_. ;
         data _null_;
            call symputx(&errorFlagName., 0);
            call symput(&errorFlagDesc., "CAS session is active.");
         run;
      %end;
      %else %do;
         %put NOTE: Unable to find a currently active CAS session. Reconnect or connect to a CAS session upstream. ;
         data _null_;
            call symputx(&errorFlagName., 1);
            call symput(&errorFlagDesc., "Unable to find a currently active CAS session. Reconnect or connect to a CAS session upstream.");
        run;
      %end;
   %end;
   %else %do;
      %put NOTE: No active CAS session ;
      data _null_;
        call symputx(&errorFlagName., 1);
        call symput(&errorFlagDesc., "No active CAS session. Connect to a CAS session upstream.");
      run;
   %end;
%mend _env_cas_checkSession;   
   
   
   
   
   
   
   
   
/* -----------------------------------------------------------------------------------------* 
   Macro to create an error flag for capture during code execution.

   Input:
      1. errorFlagName: The name of the error flag you wish to create. Ensure you provide a 
         unique value to this parameter since it will be declared as a global variable.
      2. errorFlagDesc: A description to add to the error flag.

    Output:
      1. &errorFlagName : A global variable which takes the name provided to errorFlagName.
      2. &errorFlagDesc : A global variable which takes the name provided to errorFlagDesc.
*------------------------------------------------------------------------------------------ */


%macro _create_error_flag(errorFlagName, errorFlagDesc);

   %global &errorFlagName.;
   %let  &errorFlagName.=0;

   %global &errorFlagDesc.;


%mend _create_error_flag;
   
   
   
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
   
   
/* Not so empty commit test */