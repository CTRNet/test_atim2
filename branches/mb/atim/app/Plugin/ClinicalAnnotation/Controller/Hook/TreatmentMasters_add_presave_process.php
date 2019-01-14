<?php

// FILL time to tx
$endDate = $this->request->data['TreatmentMaster']['start_date'];
$dxIdSelected = $this->request->data['TreatmentMaster']['diagnosis_master_id'];

if ($dxIdSelected > 0) {
    $this->DiagnosisMaster->id = $dxIdSelected;
    $dxSelected = $this->DiagnosisMaster->read();
    
    $startDate = $dxSelected['DiagnosisMaster']['dx_date'];
    
    $startYear = substr($startDate, 0, 4);
    
    $startMonth = substr($startDate, 5, 2);
    
    $endYear = $endDate['year'];
    
    $endMonth = $endDate['month'];
    
    $diffInMonths = ($endYear - $startYear) * 12 - $startMonth + $endMonth;
    
    $this->request->data['TreatmentMaster']['time_to_tx'] = $diffInMonths;
}