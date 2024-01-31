@echo off

set case=%1
set description=%2
set workDir =%case%%description%
set date=%DATE%_%TIME%

mkdir .\investigation, .\evidence, .\labs .\webex

copy nul >> .\investigation\originalDescription.txt
copy nul >> .\investigation\elevation.txt
copy nul >> .\investigation\investigation.txt
copy nul >> .\investigation\background.txt
copy nul >> .\investigation\cpea.txt
copy nul >> .\history.txt

echo. > .\investigation\elevation.txt
echo. > .\investigation\originalDescription.txt
echo. > .\investigation\background.txt
echo. > .\evidence\logsErrors.log
echo  "case/elevation was started on %date%" > .\history.txt



echo ==================================================== > .\investigation\investigation.txt
echo ======================Investigation================= >> .\investigation\investigation.txt
echo ==================================================== >> .\investigation\investigation.txt
echo. >> .\investigation\investigation.txt
echo Case Number:   %case% >> .\investigation\investigation.txt
echo Case Description:  %description% >> .\investigation\investigation.txt
echo. >> .\investigation\investigation.txt
echo Stage 1 Formulate Questions or Hypothesys to start investigation >> .\investigation\investigation.txt
echo    Status >> .\investigation\investigation.txt
echo. >> .\investigation\investigation.txt
echo Stage 2 Download FTP files and check environmental details  >> .\investigation\investigation.txt
echo    Status >> .\investigation\investigation.txt
echo. >> .\investigation\investigation.txt
echo Stage 3 start Investigation: >> .\investigation\investigation.txt
echo   Status >> .\investigation\investigation.txt
echo. >> .\investigation\investigation.txt
echo Stage 4 Check SF, OCTIM, Others >> .\investigation\investigation.txt 
echo   Status >> .\investigation\investigation.txt 
echo. >> .\investigation\investigation.txt
echo Stage 4 Based on Hypotesys confirmation and Lab, RCA is: >> .\investigation\investigation.txt 
echo   Possible solution will required: >> .\investigation\investigation.txt
echo. >> .\investigation\investigation.txt
echo Final Stage: Investigation Conclusions >> .\investigation\investigation.txt
echo   Status >> .\investigation\investigation.txt
echo   Issue >> .\investigation\investigation.txt
echo   Root Cause >> .\investigation\investigation.txt
echo   Steps to Reproduce >> .\investigation\investigation.txt
echo   Steps taken >> .\investigation\investigation.txt


echo ACTUAL BEHAVIOR: > .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo EXPECTED BEHAVIOR: >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo HOW-TO-REPRODUCE: >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "What is the level of urgency of the issue? (1, 2, 3, 4)" >> .\investigation\cpea.txt
echo "Identify the urgency level of this elevation based on the Severity or Urgency identified in the Case system of record (Zendesk/Octane/Salesforce/Other). In general, the elevated Severity and Priority for the elevated Incident should match with the Severity in the Case system. If you need to change the Severity e.g., elevating a High Severity Support Case to a Critical Severity CPE Incident please justify." >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "Suggested Prioritization Comments:" >> .\investigation\cpea.txt
echo "Suggest what the CPE Incident Priority should be: Urgent, Very High, High, Medium, Low.  Provide any additional “Business Impact” information that may be helpful in prioritizing this elevation request. This could include items like:" >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "a CritSit exist" >> .\investigation\cpea.txt
echo "the Customer’s Business Impact" >> .\investigation\cpea.txt
echo "the Potential Deal $ Cost to OpenText" >> .\investigation\cpea.txt
echo "end users' impact" >> .\investigation\cpea.txt
echo "number(s) of systems, accounts, etc." >> .\investigation\cpea.txt
echo "rate of issue occurrence: constant, hourly, daily, etc." >> .\investigation\cpea.txt
echo "any other information that is helpful" >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "What is the purpose of this elevation?" >> .\investigation\cpea.txt
echo "Set the Expectation you need from R&D: Answer Question, Investigate, Hotfix requested, Create Defect, Create Enhancement then provide any additional details that would be helpful supporting Expectation set." >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "Describe your expected assistance you need from R&D." >> .\investigation\cpea.txt
echo "Does the customer have any special expectations e.g. Hotfix or workaround needed? a WebEx session with Engineering? - provide any detail." >> .\investigation\cpea.txt   
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "Description of the issue:" >> .\investigation\cpea.txt
echo "Provide an “Executive Summary” of the issue, using as much detail as is possible without bogging down the description in verbose detail. Use your own words. Report clearly on what you understand the issue to be. DO NOT just copy / paste from the Support Case)!" >> .\investigation\cpea.txt
echo "In addition to updating the Description, have you updated the title to better reflect what the problem is?" >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "Issue timeline / frequency / current status:" >> .\investigation\cpea.txt
echo "Provide a timeline of the issue. When did the issue started to appear? Was there anything changed made prior to the issue first occurring?" >> .\investigation\cpea.txt
echo "What led to the identification that an issue exists?" >> .\investigation\cpea.txt
echo "How frequently does the issue occur?  Is the problem persistent or intermittent?" >> .\investigation\cpea.txt
echo "What is the status of the issue?" >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "Steps Taken to Reproduce:" >> .\investigation\cpea.txt
echo "Describe the trouble shooting steps and diagnostics that was done by Support so far. " >> .\investigation\cpea.txt
echo "What worked?  What didn't?" >> .\investigation\cpea.txt
echo "Was the problem reproduced? e.g., reproduced in my lab I tried to replicate the issue and found the following..." >> .\investigation\cpea.txt
echo "Provide reproduction steps in detail and if any of those in house systems can be made available to R&D Engineering. If available for R&D Engineering to access in house systems, identify those systems along with all required access information." >> .\investigation\cpea.txt
echo "What is the current conclusion from Support?" >> .\investigation\cpea.txt
echo "Was there any workaround identified?" >> .\investigation\cpea.txt
echo "System Environment:" >> .\investigation\cpea.txt
echo "Describe the systems involved and the environment that the issue has been identified in. Include all solutions and operating system versions, patches and hot fixes involved. If the issue has occurred with other versions, make sure that is also identified." >> .\investigation\cpea.txt
echo "What information (e.g., logs, files, recordings) has been gathered?  Location? " >> .\investigation\cpea.txt
echo "Are evidence or details of the issue provided or attached e.g. screenshots, logs etc." >> .\investigation\cpea.txt
echo "Have you gathered and attached additional product specific info requested here:" >> .\investigation\cpea.txt
echo "https://rndwiki.houston.softwaregrp.net/confluence/pages/viewpage.action?spaceKey=ADP&title=CPE+Incident+Submittal+Guidelines%3A+How+to+gather+logs+for+CPE+team+in+an+efficient+manner" >> .\investigation\cpea.txt
echo "Relevant Tickets:" >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo "Have you research for related Zendesk/Octane/Salesforce/other Case, Octane CPE Incident or Octane Change Requests? ">> .\investigation\cpea.txt
echo "Please provide reference numbers and any summary notes.">> .\investigation\cpea.txt
echo "Who was / is involved on the Support team?">> .\investigation\cpea.txt
echo "Identify and list the Support staff who has been engaged on this issue from all relevant support teams.  Was there “Backline Support” engaged?  ">> .\investigation\cpea.txt
echo "What are the next steps?">> .\investigation\cpea.txt
echo "What are the next steps that are expected and/or required at this time? Identify any commitments that have been made to customers or other parties regarding this elevation.">> .\investigation\cpea.txt
echo "Comments/Notes:">> .\investigation\cpea.txt
echo "Provide any additional comments and notes that are relevant and have not been captured in the above details.">> .\investigation\cpea.txt
echo "Please note:">> .\investigation\cpea.txt
echo  "Please prefix the title of the elevated CPE Incident with one of the following Product short name: [ArcMC], [CDF], [Connectors], [Content],[ESM], [Fusion], [Intelligence], [Logger], [Recon], [SOAR], [T-Hub], [Other]" >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo. >> .\investigation\cpea.txt
echo  "Remember: Any information provided by the customer must be VERIFIED with evidence from the logs, executed commands on the customer system, etc.  Just because the customer told you something does NOT guarantee the accuracy/precision of the claim!!!" >> .\investigation\cpea.txt
echo "Support should monitor for OCTANE updates." >> .\investigation\cpea.txt
echo "The title of the CPE Incident (OCTIM) must be descriptive and useful!!!  For example, putting only "Connector parsing issue" is completely useless. " >> .\investigation\cpea.txt
echo "Expected is a clear and concise description of the issue." >> .\investigation\cpea.txt
echo "If you refer to error/exception/observation from customer log, You MUST point out log file's name and location. For example, agent.log.5 from <XYZ>.zip (attached to the OCTIM)" >> .\investigation\cpea.txt
echo "what was attempted to solve or work around it. " >> .\investigation\cpea.txt
echo "Workaround if any, and reproduction steps in detail " >> .\investigation\cpea.txt
echo "Check with customer if it is a regression, if so, provide last working version and device version that are known to customer.">> .\investigation\cpea.txt
echo "YOU MUST try to reproduce the issue in-house.  If this is not possible, please note why not in detail so this can be considered. ">> .\investigation\cpea.txt
echo "Submittal quality rating will be updated by CPE team members according to conformance to the guidelines here. We are striving for 100% compliance. Items with bad/incomplete repro steps WILL BE ASSIGNED BACK." >> .\investigation\cpea.txt
echo "SECURITY RISK!" >> .\investigation\cpea.txt
echo "If it is a security risk please follow KM000010955 – CPE assist requests should be via “need to know” email only." >> .\investigation\cpea.txt




 

 





 






