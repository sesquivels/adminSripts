
#!/bin/bash

##====================================================
##================Investigation Process===============
##====================================================

echo "This will create a form with action plan. Please first indicate if  is elevation fts or mine"


CASE=$1
BRIEF_DESCRIPTION=$2
LAB_DES= $CASE"_"$BRIEF_DESCRIPTION

#echo "el path es ${DIRPATH}"
mkdir investigation evidence labs webex
touch elevation.txt originalDescription.txt background.txt logsInvestigation.log labs.txt cpea.txt hystory.txt webex.txt

     echo "##====================================================" | tee -a investigationMain.txt
     echo "##======================Investigation=================" | tee -a investigationMain.txt
     echo "##====================================================" | tee -a investigationMain.txt
     echo " " | tee -a investigationMain.txt
     echo " " | tee -a investigationMain.txt
     echo "Case Number: $CASE" | tee -a investigationMain.txt
     echo "Case Description: $BRIEF_DESCRIPTION" | tee -a investigationMain.txt
     echo " " | tee -a investigationMain.txt
     echo " " | tee -a investigationMain.txt
     echo "Stage 1 Formulate Questions or Hypothesys to start investigation" | tee -a investigationMain.txt
     echo "    Status: " | tee -a investigationMain.txt
         echo " " | tee -a investigationMain.txt
     echo " " | tee -a investigationMain.txt
     echo "Stage 2 Download FTP files and check environmental details" | tee -a investigationMain.txt
     echo "    Status: " | tee -a investigationMain.txt
         echo " " | tee -a investigationMain.txt
     echo " " | tee -a investigationMain.txt
     echo "Stage 3 start Investigation" | tee -a investigationMain.txt
     echo "    Status: " | tee -a investigationMain.txt
         echo " " | tee -a investigationMain.txt
     echo "Stage 4 Check SF, OCTIM, Others " | tee -a investigationMain.txt
     echo "    Status: " | tee -a investigationMain.txt
         echo " " | tee -a investigationMain.txt
     echo "Stage 5 Based on Hypotesys confirmation and Lab, ActionPlan or Next steps are : " | tee -a investigationMain.txt
     echo "    Step 1: " | tee -a investigationMain.txt
     echo "    Step 2: " | tee -a investigationMain.txt
     echo "    Step 3: " | tee -a investigationMain.txt
     echo "    Step 4: " | tee -a investigationMain.txt
     echo "    Step 5: " | tee -a investigationMain.txt
     echo " " | tee -a investigationMain.txt
     echo "Final Stage: Investigation Conclusions" | tee -a investigationMain.txt
     echo "    Status: " | tee -a investigationMain.txt

     clear
     mv elevation.txt originalDescription.txt background.txt investigationMain.txt webex.txt investigation/
     mv logsInvestigation.txt evidence
     mv labs.txt cpea.txt hystory.txt investigation/
