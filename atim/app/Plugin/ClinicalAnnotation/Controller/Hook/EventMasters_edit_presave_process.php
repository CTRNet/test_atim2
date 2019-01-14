<?php

// --- START OF CLL CALC FIELDS
// NOV 29 2010 MARY NATIVIDAD

// CLL CONTROL FU
if ($eventMasterData['EventMaster']['event_control_id'] == 38) {
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // AGE AT STUDY
    $endDate = $this->request->data['EventMaster']['event_date'];
    echo $endDate;
    
    $startDate = $participantData['Participant']['date_of_birth'];
    echo $startDate;
    
    $startYear = substr($startDate, 0, 4);
    echo $startYear;
    
    $endYear = $endDate['year'];
    echo $endYear;
    
    $diffInYrs = ($endYear - $startYear);
    echo $diffInYrs;
    
    if ($diffInYrs > 0) {
        $this->request->data['EventDetail']['cll_age_at_study'] = $diffInYrs;
    }
    // end diff in years
}

// END OF CLL CONTROL FU

// CLL FU PRES
if ($eventMasterData['EventMaster']['event_control_id'] == 39 || $eventMasterData['EventMaster']['event_control_id'] == 40) {
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // AGE AT STUDY
    $endDate = $this->request->data['EventMaster']['event_date'];
    echo $endDate;
    
    $startDate = $participantData['Participant']['date_of_birth'];
    echo $startDate;
    
    $startYear = substr($startDate, 0, 4);
    echo $startYear;
    
    $endYear = $endDate['year'];
    echo $endYear;
    
    $diffInYrs = ($endYear - $startYear);
    echo $diffInYrs;
    
    if ($diffInYrs > 0) {
        $this->request->data['EventDetail']['cll_age_at_study'] = $diffInYrs;
    }
    // end diff in years
    
    // BMI
    $cllHeight = $this->request->data['EventDetail']['cll_height_at_sample'];
    echo $cllHeight;
    
    $cllWeight = $this->request->data['EventDetail']['cll_weight_at_sample'];
    echo $cllWeight;
    
    $cllHeightM = $cllHeight * 0.01;
    echo $cllHeightM;
    
    $bmiCalc = $cllWeight / ($cllHeightM * $cllHeightM);
    echo $bmiCalc;
    
    $this->request->data['EventDetail']['cll_bmi'] = $bmiCalc;
}
// --- !!! END OF CLL CALC FIELDS

// CLL FU LAB combo control id =41

if ($eventMasterData['EventMaster']['event_control_id'] == 41) {
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // AGE AT STUDY
    $endDate = $this->request->data['EventMaster']['event_date'];
    echo $endDate;
    
    $startDate = $participantData['Participant']['date_of_birth'];
    echo $startDate;
    
    $startYear = substr($startDate, 0, 4);
    echo $startYear;
    
    $endYear = $endDate['year'];
    echo $endYear;
    
    $diffInYrs = ($endYear - $startYear);
    echo $diffInYrs;
    
    if ($diffInYrs > 0) {
        $this->request->data['EventDetail']['cll_age_at_study'] = $diffInYrs;
    }
    // end diff in years >0
}
// --- !!! END OF CLL FU LAB COMBO CALC FIELDS

// --- !!! START OF MMY CALC FIELDS

// MMY FU PRES
if ($eventMasterData['EventMaster']['event_control_id'] == 44 || $eventMasterData['EventMaster']['event_control_id'] == 45) {
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // AGE AT DONATION
    $endDate = $this->request->data['EventMaster']['event_date'];
    echo $endDate;
    
    $startDate = $participantData['Participant']['date_of_birth'];
    echo $startDate;
    
    $startYear = substr($startDate, 0, 4);
    echo $startYear;
    
    $endYear = $endDate['year'];
    echo $endYear;
    
    $diffInYrs = ($endYear - $startYear);
    echo $diffInYrs;
    
    if ($diffInYrs > 0 && $eventMasterData['EventMaster']['event_control_id'] == 44) {
        $this->request->data['EventDetail']['age_at_presentation'] = $diffInYrs;
    }
    // end diff in years
    
    if ($diffInYrs > 0 && $eventMasterData['EventMaster']['event_control_id'] == 45) {
        $this->request->data['EventDetail']['age_at_followup'] = $diffInYrs;
    }
    // end diff in years
    
    // FILL STATUS TIME IN MMY FU
    if ($eventMasterData['EventMaster']['event_control_id'] == 45) {
        
        // UPDATE FU STATUS TIME
        $endDate = $this->request->data['EventMaster']['event_date'];
        $dxIdSelected = $this->request->data['EventMaster']['diagnosis_master_id'];
        
        if ($dxIdSelected > 0) {
            $this->DiagnosisMaster->id = $dxIdSelected;
            $dxSelected = $this->DiagnosisMaster->read();
            
            $startDate = $dxSelected['DiagnosisMaster']['dx_date'];
            
            $startYear = substr($startDate, 0, 4);
            
            $startMonth = substr($startDate, 5, 2);
            
            $endYear = $endDate['year'];
            
            $endMonth = $endDate['month'];
            
            $diffInMonths = ($endYear - $startYear) * 12 - $startMonth + $endMonth;
            
            $this->request->data['EventDetail']['status_time'] = $diffInMonths;
        }
    } // END FILL STATUS TIME
      
    // BMI
    $mmyHeight = $this->request->data['EventDetail']['height'];
    echo $mmyHeight;
    
    $mmyWeight = $this->request->data['EventDetail']['weight'];
    echo $mmyWeight;
    
    $mmyHeightM = $mmyHeight * 0.01;
    echo $mmyHeightM;
    
    $bmiCalc = $mmyWeight / ($mmyHeightM * $mmyHeightM);
    echo $bmiCalc;
    
    $this->request->data['EventDetail']['bmi'] = $bmiCalc;
}

// CALC AGE AT LAB
if ($eventMasterData['EventMaster']['event_control_id'] == 47) {
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // AGE AT DONATION
    $endDate = $this->request->data['EventMaster']['event_date'];
    echo $endDate;
    
    $startDate = $participantData['Participant']['date_of_birth'];
    echo $startDate;
    
    $startYear = substr($startDate, 0, 4);
    echo $startYear;
    
    $endYear = $endDate['year'];
    echo $endYear;
    
    $diffInYrs = ($endYear - $startYear);
    echo $diffInYrs;
    
    if ($diffInYrs > 0 && $eventMasterData['EventMaster']['event_control_id'] == 47) {
        $this->request->data['EventDetail']['age_at_lab'] = $diffInYrs;
    }
    // end diff in years
}

// --- !!! END OF MMY CALC FIELDS

// FILL STATUS TIME LUNG AND OV and general

if ($eventMasterData['EventMaster']['event_control_id'] == 66 || $eventMasterData['EventMaster']['event_control_id'] == 71 || $eventMasterData['EventMaster']['event_control_id'] == 20) {
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // UPDATE FU STATUS TIME
    $endDate = $this->request->data['EventMaster']['event_date'];
    $dxIdSelected = $this->request->data['EventMaster']['diagnosis_master_id'];
    
    if ($dxIdSelected > 0) {
        $this->DiagnosisMaster->id = $dxIdSelected;
        $dxSelected = $this->DiagnosisMaster->read();
        
        $startDate = $dxSelected['DiagnosisMaster']['dx_date'];
        
        $startYear = substr($startDate, 0, 4);
        
        $startMonth = substr($startDate, 5, 2);
        
        $endYear = $endDate['year'];
        
        $endMonth = $endDate['month'];
        
        $diffInMonths = ($endYear - $startYear) * 12 - $startMonth + $endMonth;
        
        $this->request->data['EventDetail']['status_time'] = $diffInMonths;
    }
} // END FILL STATUS TIME LUNG AND OV and general
  
// ----------------- !!! AUTOMATIC UPDATING
  // CUSTOM CODE ADDED FEB 8 2010 - BY MARY NATIVIDAD
  // BREAST FU
if ($eventMasterData['EventMaster']['event_control_id'] == 35) {
    
    // UPDATE FU STATUS TIME
    $endDate = $this->request->data['EventMaster']['event_date'];
    $dxIdSelected = $this->request->data['EventMaster']['diagnosis_master_id'];
    
    if ($dxIdSelected > 0) {
        $this->DiagnosisMaster->id = $dxIdSelected;
        $dxSelected = $this->DiagnosisMaster->read();
        
        $startDate = $dxSelected['DiagnosisMaster']['dx_date'];
        
        $startYear = substr($startDate, 0, 4);
        
        $startMonth = substr($startDate, 5, 2);
        
        $endYear = $endDate['year'];
        
        $endMonth = $endDate['month'];
        
        $diffInMonths = ($endYear - $startYear) * 12 - $startMonth + $endMonth;
        
        $this->request->data['EventDetail']['status_time'] = $diffInMonths;
    }
    // END STATUS TIME
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // IN EDIT THE CHRT_CHECKED DATE ALWAYS DEFAULTS TO CURRENT DATE REGARDLESS IF ANYTHING WAS CHANGED ON EDIT AND SUBMIT
    // UPDATE LAST_CHART_CHECKED_DATE TO cht_checked , cht_checked always defaults to current date
    // also update certainty - status fields for corresponding fields
    $this->request->data['EventDetail']['cht_checked'] = date("Y-m-d");
    $this->request->data['EventDetail']['cht_checked_certainty'] = 'c';
    // NOT NEEDED $this->request->data['Participant']['last_chart_checked_date'] = $this->request->data['EventDetail']['cht_checked'];
    // NOT NEEDED $this->request->data['Participant']['last_chart_checked_date_accuracy'] = $this->request->data['EventDetail']['cht_checked_certainty'];
    
    $ptLastChartCheckedDate = $this->request->data['EventDetail']['cht_checked'];
    $ptLastChartCheckedDateAccuracy = $this->request->data['EventDetail']['cht_checked_certainty'];
    
    // echo date('c');
    // echo date('Y m d');
    
    $ptVitalStatus = '';
    $ptTimeToDeath = 0;
    
    // UPDATE PARTICIPANT VITAL_STATUS IF THERE IS A DATE OF DEATH
    
    if (! ($participantData['Participant']['date_of_death'] == '0000-00-00' || $participantData['Participant']['date_of_death'] == null)) {
        
        // NOT NEEDED $this->request->data['Participant']['vital_status'] ='dead';
        $ptVitalStatus = 'dead';
        // calc age at death
        
        $endDate = $participantData['Participant']['date_of_death'];
        echo $endDate;
        
        $startDate = $participantData['Participant']['date_of_birth'];
        echo $startDate;
        
        $startYear = substr($startDate, 0, 4);
        echo $startYear;
        
        $endYear = substr($endDate, 0, 4);
        echo $endYear;
        
        $diffInYrs = ($endYear - $startYear);
        echo $diffInYrs;
        
        if ($diffInYrs > 0) {
            // NOT NEEDED $this->request->data['Participant']['time_to_death'] =$diffInYrs;
            
            $ptTimeToDeath = $diffInYrs;
        }
    }
    
    // UPDATE PARTICIPANT VITAL_STATUS IF EVENT DETAIL VITAL STATUS NOT BLANK AND NOT DEAD
    
    if (($this->request->data['EventDetail']['vital_status'] == 'unknown' || substr($this->request->data['EventDetail']['vital_status'], 0, 5) == 'alive' || $this->request->data['EventDetail']['vital_status'] == 'lost contact') && ($participantData['Participant']['date_of_death'] == '0000-00-00' || $participantData['Participant']['date_of_death'] == null)) 

    {
        if ($this->request->data['EventDetail']['vital_status'] == 'unknown') {
            // NOT NEEDED $this->request->data['Participant']['vital_status'] ='unknown';
            $ptVitalStatus = 'unknown';
        }
        
        if (substr($this->request->data['EventDetail']['vital_status'], 0, 5) == 'alive') {
            // NOT NEEDED $this->request->data['Participant']['vital_status'] ='alive';
            $ptVitalStatus = 'alive';
        }
        
        if ($this->request->data['EventDetail']['vital_status'] == 'lost contact') {
            // NOT NEEDED $this->request->data['Participant']['vital_status'] ='unknown';
            $ptVitalStatus = 'unknown';
        }
    }
    
    // UPDATE PARTICIPANT DATE OF DEATH if blank WITH EVENT DATE IF VITAL STATUS = died of ...
    
    if (substr($this->request->data['EventDetail']['vital_status'], 0, 4) == 'died') {
        // NOT NEEDED $this->request->data['Participant']['vital_status'] ='dead';
        
        $ptVitalStatus = 'dead';
        
        if ($this->request->data['Participant']['date_of_death'] == '0000-00-00' || $this->request->data['Participant']['date_of_death'] == null) {
            
            $this->request->data['Participant']['date_of_death'] = $this->request->data['EventMaster']['event_date'];
            $this->request->data['Participant']['date_of_death_accuracy'] = $this->request->data['EventMaster']['event_date_accuracy'];
            
            $ptDateOfDeath = $this->request->data['EventMaster']['event_date'];
            $ptDateOfDeathAccuracy = $this->request->data['EventMaster']['event_date_accuracy'];
            
            // calc age at death
            $endDate = $this->request->data['Participant']['date_of_death'];
            echo $endDate;
            
            $startDate = $participantData['Participant']['date_of_birth'];
            echo $startDate;
            
            $startYear = substr($startDate, 0, 4);
            echo $startYear;
            
            $endYear = $endDate['year'];
            echo $endYear;
            
            $diffInYrs = ($endYear - $startYear);
            echo $diffInYrs;
            
            if ($diffInYrs > 0) {
                $this->request->data['Participant']['time_to_death'] = $diffInYrs;
                $ptTimeToDeath = $diffInYrs;
            }
        }
    }
    
    // SAVE THE PARTICIPANT DATA
    
    // $this->Participant->save( $this->request->data['Participant'] );
    
    // --------------------------------------------------------------------------------
    // Save Participant info using an UPDATE statement
    // vital status
    // --------------------------------------------------------------------------------
    // $queryToUpdate = "UPDATE participants SET participants.vital_status = '".$this->request->data['EventDetail']['vital_status']."' WHERE participants.id = ".$this->Participant->id.";";
    
    // thse 2 not working
    // "participants.date_of_death=".$ptDateOfDeath." , ".
    // "participants.date_of_death_accuracy='".$ptDateOfDeathAccuracy."' , ".
    
    $queryToUpdate = "UPDATE participants SET participants.vital_status='" . $ptVitalStatus . "' , " . "participants.time_to_death=" . $ptTimeToDeath . " , " . "participants.last_chart_checked_date='" . $ptLastChartCheckedDate . "' , " . "participants.last_chart_checked_date_accuracy='" . $ptLastChartCheckedDateAccuracy . "' WHERE participants.id = " . $this->Participant->id . ";";
    
    $this->Participant->tryCatchQuery($queryToUpdate);
}
// ----------------- !!! END AUTOMATIC UPDATING