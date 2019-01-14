<?php

// --- START OF CLL CALC FIELDS
// NOV 29 2010 MARY NATIVIDAD
// v2.4.3a changes to event masters , need to change if statements to event_control_id
// CLL CONTROL FU event_control_id=38
if ($this->request->data['EventMaster']['event_control_id'] == 38) {
    
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

// END OF CLL CONTROL FU

// CLL FU OR PRES control id =39, 40

if ($this->request->data['EventMaster']['event_control_id'] == 39 || $this->request->data['EventMaster']['event_control_id'] == 40) {
    
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

if ($this->request->data['EventMaster']['event_control_id'] == 41) {
    
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

if ($this->request->data['EventMaster']['event_control_id'] == 44 || $this->request->data['EventMaster']['event_control_id'] == 45) {
    
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
    
    if ($diffInYrs > 0 && $this->request->data['EventMaster']['event_control_id'] == 44) {
        $this->request->data['EventDetail']['age_at_presentation'] = $diffInYrs;
    }
    // end diff in years >0
    
    if ($diffInYrs > 0 && $this->request->data['EventMaster']['event_control_id'] == 45) {
        $this->request->data['EventDetail']['age_at_followup'] = $diffInYrs;
    }
    // end diff in years >0
    
    // AUTOFILL DATES BASED ON EVENTDATE I.E FU DATE
    //
    // if ($this->request->data['EventMaster']['event_control_id']==45){
    //
    // $this->request->data['EventDetail']['ht_wt_bmi_date']=$endDate;
    // $this->request->data['EventDetail']['Bonemarrowbiopsy_date']=$endDate;
    // $this->request->data['EventDetail']['Hematology_date']=$endDate;
    // $this->request->data['EventDetail']['Chemistry_date']=$endDate;
    // $this->request->data['EventDetail']['Immunology_date']=$endDate;
    // $this->request->data['EventDetail']['LightChainIsotype_date']=$endDate;
    // $this->request->data['EventDetail']['SerumFreeLtChLevels_date']=$endDate;
    // $this->request->data['EventDetail']['FlowCytometry_date']=$endDate;
    // $this->request->data['EventDetail']['Cytogenetics_date']=$endDate;
    //
    // } // END AUTOFILL DATES BASED ON EVENTDATE I.E FU DATE
    
    // FILL STATUS TIME IN MMY FU
    if ($this->request->data['EventMaster']['event_control_id'] == 45) {
        
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

// CALC FOR AGE AT LAB
if ($this->request->data['EventMaster']['event_control_id'] == 47) {
    
    // GET PARTICIPANT DATA
    $this->Participant->id = $participantId;
    $participantData = $this->Participant->read();
    
    // AGE AT Lab
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
    
    if ($diffInYrs > 0 && $this->request->data['EventMaster']['event_control_id'] == 47) {
        $this->request->data['EventDetail']['age_at_lab'] = $diffInYrs;
    }
    // end diff in years >0
}

// --- !!! END OF MMY CALC FIELDS

// FILL STATUS TIME LUNG AND OV , general

if ($this->request->data['EventMaster']['event_control_id'] == 66 || $this->request->data['EventMaster']['event_control_id'] == 71 || $this->request->data['EventMaster']['event_control_id'] == 20) {
    
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
} // END FILL STATUS TIME LUNG AND OV general
  
// ----------------- !!! AUTOMATIC UPDATING
  // CUSTOM CODE ADDED MAY20 2009 - BY MARY NATIVIDAD
  // CUSTOM CODE revised feb 24 2010 - BY MARY NATIVIDAD
  // BREAST FU CONTROL ID 35
if ($this->request->data['EventMaster']['event_control_id'] == 35) {
    
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
    
    // UPDATE LAST_CHART_CHECKED_DATE TO cht_checked , cht_checked always defaults to current date
    // also update certainty - status fields for corresponding fields
    
    $this->request->data['EventDetail']['cht_checked'] = date("Y-m-d");
    $this->request->data['EventDetail']['cht_checked_certainty'] = 'c';
    $this->request->data['Participant']['last_chart_checked_date'] = $this->request->data['EventDetail']['cht_checked'];
    $this->request->data['Participant']['last_chart_checked_date_accuracy'] = $this->request->data['EventDetail']['cht_checked_certainty'];
    
    // UPDATE PARTICIPANT VITAL_STATUS IF THERE IS A DATE OF DEATH
    
    if (! ($participantData['Participant']['date_of_death'] == '0000-00-00' || $participantData['Participant']['date_of_death'] == null)) {
        
        $this->request->data['Participant']['vital_status'] = 'dead';
        
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
            $this->request->data['Participant']['time_to_death'] = $diffInYrs;
        }
    }
    
    // UPDATE PARTICIPANT VITAL_STATUS IF EVENT DETAIL VITAL STATUS NOT BLANK AND NOT DEAD
    
    if (($this->request->data['EventDetail']['vital_status'] == 'unknown' || substr($this->request->data['EventDetail']['vital_status'], 0, 5) == 'alive' || $this->request->data['EventDetail']['vital_status'] == 'lost contact') && ($participantData['Participant']['date_of_death'] == '0000-00-00' || $participantData['Participant']['date_of_death'] == null)) 

    {
        if ($this->request->data['EventDetail']['vital_status'] == 'unknown') {
            $this->request->data['Participant']['vital_status'] = 'unknown';
        }
        
        if (substr($this->request->data['EventDetail']['vital_status'], 0, 5) == 'alive') {
            $this->request->data['Participant']['vital_status'] = 'alive';
        }
        
        if ($this->request->data['EventDetail']['vital_status'] == 'lost contact') {
            $this->request->data['Participant']['vital_status'] = 'unknown';
        }
    }
    
    // UPDATE PARTICIPANT DATE OF DEATH if blank WITH EVENT DATE IF VITAL STATUS = died of ...
    
    if (substr($this->request->data['EventDetail']['vital_status'], 0, 4) == 'died') {
        $this->request->data['Participant']['vital_status'] = 'dead';
        
        if ($participantData['Participant']['date_of_death'] == '0000-00-00' || $participantData['Participant']['date_of_death'] == null) {
            $this->request->data['Participant']['date_of_death'] = $this->request->data['EventMaster']['event_date'];
            $this->request->data['Participant']['date_of_death_accuracy'] = $this->request->data['EventMaster']['event_date_accuracy'];
            
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
            }
        }
    }
    
    // SAVE THE PARTICIPANT DATA
    $this->Participant->save($this->request->data['Participant']);
}
// ----------------- !!! END AUTOMATIC UPDATING