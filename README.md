# Synthetic Minority Oversampling TEchnique (SMOTE) Synthetic Data Generation

This custom step helps you generate synthetic data based on an input table, using the Synthetic Minority Oversampling TEchnique (SMOTE). SMOTE is an oversampling technique which identifies new data observations in the neighborhood of closely associated original observations. 

SMOTE is an alternative approach to Generative Adversarial Networks (GANs) for generating synthetic tabular data. Access to synthetic data helps you make better, data-informed decisions in situations where you have imbalanced, scant, poor quality, unobservable, or restricted data.

## A general idea

This animated gif provides a basic idea: 

![SDG - SMOTE](./img/SMOTE_SDG.gif)

----
## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Requirements](#requirements)
3. [Parameters](#parameters)
   1. [Input Parameters](#input-parameters)
   2. [Configuration](#configuration)
   3. [Output Specifications](#output-specifications)
4. [Run-time Control](#run-time-control)
5. [Documentation](#documentation)
6. [SAS Program](#sas-program)
7. [Installation and Usage](#installation--usage)
8. [Created/Contact](#createdcontact)
9. [Change Log](#change-log)
----
## Requirements

1. A SAS Viya 4 environment, preferably monthly stable 2024.03 or later

2. A Visual Data Mining and Machine Learning (VDMML) license, usually provided with Viya Enterprise or higher, is required.

3. An active SAS Cloud Analytics Services (CAS) connection during runtime.

4. The smote.smoteSample CAS action requires Python configuration, as specified in [SAS documentation](https://go.documentation.sas.com/doc/en/pgmsascdc/default/casactml/casactml_smote_details01.htm). Please work with your SAS administrator to have the same configured. Ensure the following:

   1. Python 3.9.x required (dependent packages don't run on higher versions)
   2. [sas-ipc-queue](https://pypi.org/project/sas-ipc-queue/) , version atleast 0.7.0 and beyond 
   3. hnswlib - https://pypi.org/project/hnswlib/

-----

## Parameters
----
### Input Parameters

1. Input table (input port, required): 

2. Nearest neighbors (numeric stepper, default 5): 

3. Input columns (column selector):

4. Select a class column (column selector, optional): 

5. Class to augment (drop-down list, values from class column if selected): 


----
### Configuration 

1. **Embedding model** (text field, required):  provide the name of your Azure OpenAI deployment of an OpenAI embedding model. For convenience, it's suggested to use the same name as the model you wish to use. For example, if your OpenAI embedding model happens to be text-embedding-3-small, use the same name for your deployment. 

2. **Vector store persistent path** (text field, defaults to /tmp if blank): provide a path to a ChromaDB database.  If blank, this defaults to /tmp on the filesystem. 

3. **Chroma DB collection name** (text field): provide name of the Chroma DB collection you wish to use.  If the collection does not exist, a new one will be created. Ensure you have write access to the persistent area.

4. **Text generation model** (text field, required): provide the name of an Azure OpenAI text generation deployment.  For convenience, you may choose to use the same name as the OpenAI LLM. Example, gpt-35-turbo to gpt-35-turbo.

5. **Azure OpenAI service details** (file selector for key and text fields, required): provide a path to your Azure OpenAI access key.  Ensure this key is saved within a text file in a secure location on the filesystem.  Users are responsible for providing their keys to use this service.  In addition, also refer to your Azure OpenAI service to obtain the service endpoint and region.

----
### Output Specifications

Results (the answer from the LLM) are printed by default to the output window.

1. **Temperature** (numeric stepper, default 0, max 1): temperature for an LLM affects its abiity to predict the next word while generating responses.  A rule of thumb is that a temperature closer to 0 indicates the model uses the predicted next word with the highest probability and provides stable responses, whereas a temperature of 1 increases the randomness with which the model predicts the next word which may lead to more creative responses.

2. **Context size** (numeric stepper, default 10): select how many similar results from the vector store should be retrieved and provided as context to the LLM.  Note that a higher number results in more tokens provided as part of the prompt.

3. **Output table** (output port, option): attach either a CAS table or sas7bdat to the output port of this node to hold results.  These results contain the LLM's answer, the original question and supporting retrieved results. 

----
## Run-time Control

Note: Run-time control is optional.  You may choose whether to execute the main code of this step or not, based on upstream conditions set by earlier SAS programs.  This includes nodes run prior to this custom step earlier in a SAS Studio Flow, or a previous program in the same session.

Refer this blog (https://communities.sas.com/t5/SAS-Communities-Library/Switch-on-switch-off-run-time-control-of-SAS-Studio-Custom-Steps/ta-p/885526) for more details on the concept.

The following macro variable,
```sas
_aor_run_trigger
```

will initialize with a value of 1 by default, indicating an "enabled" status and allowing the custom step to run.

If you wish to control execution of this custom step, include code in an upstream SAS program to set this variable to 0.  This "disables" execution of the custom step.

To "disable" this step, run the following code upstream:

```sas
%global _aor_run_trigger;
%let _aor_run_trigger =0;
```

To "enable" this step again, run the following (it's assumed that this has already been set as a global variable):

```sas
%let _aor_run_trigger =1;
```


IMPORTANT: Be aware that disabling this step means that none of its main execution code will run, and any  downstream code which was dependent on this code may fail.  Change this setting only if it aligns with the objective of your SAS Studio program.

----
## Documentation

1. [SAS documentation for the smote.smoteSample CAS action.](https://go.documentation.sas.com/doc/en/pgmsascdc/default/casactml/casactml_smote_details01.htm)

2. PyPi page for [sas-ipc-queue](https://pypi.org/project/sas-ipc-queue/) 

3. PyPi page for [hnswlib](https://pypi.org/project/hnswlib/)

----
## SAS Program

Refer [here](./extras/LLM%20-%20Azure%20Open%20AI%20RAG.sas) for the SAS program used by the step.  You'd find this useful for situations where you wish to execute this step through non-SAS Studio Custom Step interfaces such as the [SAS Extension for Visual Studio Code](https://github.com/sassoftware/vscode-sas-extension), with minor modifications. 

----
## Installation & Usage

- Refer to the [steps listed here](https://github.com/sassoftware/sas-studio-custom-steps#getting-started---making-a-custom-step-from-this-repository-available-in-sas-studio).

----
## Created/contact: 

1. Samiul Haque (samiul.haque@sas.com)
2. Sundaresh Sankaran (sundaresh.sankaran@sas.com)

----
## Change Log

* Version 1.1 (03APR2024) 
    * Initial version