<?php

// Clinical file update process
if (empty($this->request->data)) {
    $this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participantId, $this->passedArgs);
    if (strpos(implode('', $this->passedArgs), 'clinical_file_update_process_step') !== false && isset($_SESSION['procure_clinical_file_update_process'])) {
        // Set default data
        $nowQuery = "SELECT DATE_FORMAT(NOW(),'%Y-%m-%d') as 'created_date' FROM users LIMIT 0,1";
        $nowData = $this->Participant->query($nowQuery);
        $nowDate = $nowData[0][0]['created_date'];
        
        // *** 1 *** Set the date of the last chart checked date
        // - If date of the visit completed today during this clinical file update process
        // then set by default the last chart checked date to this visite date
        // if this one is bigger than the existing last chart checked date
        // - Else if the current date is bigger than the last chart checked date
        // then set by default the last chart checked date to the current date
        
        // Check a visit/contact form has just been completed by user
        $visitContactFormConditions = array(
            'EventMaster.participant_id' => $participantId,
            'EventControl.event_type' => 'visit/contact',
            "EventMaster.created LIKE '$nowDate%'",
            'EventMaster.created_by' => $_SESSION['Auth']['User']['id']
        );
        $lastVisitDateCompletedToday = $this->EventMaster->find('first', array(
            'conditions' => $visitContactFormConditions,
            'order' => array(
                'EventMaster.event_date DESC'
            )
        ));
        
        $lastChartCheckedDateInDatabase = '';
        if (preg_match('/^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/', $participantData['Participant']['last_chart_checked_date'], $matches)) {
            switch ($participantData['Participant']['last_chart_checked_date_accuracy']) {
                case 'd':
                    $lastChartCheckedDateInDatabase = $matches[1] . '-' . $matches[2];
                    break;
                case 'm':
                case 'y':
                    $lastChartCheckedDateInDatabase = $matches[1];
                    break;
                default:
                    $lastChartCheckedDateInDatabase = $participantData['Participant']['last_chart_checked_date'];
            }
            $lastChartCheckedDateInDatabase = __("the 'last chart checked date' is currently set to '%s'", $lastChartCheckedDateInDatabase);
        }
        
        if ($lastVisitDateCompletedToday) {
            if ($lastVisitDateCompletedToday['EventMaster']['event_date'] > $participantData['Participant']['last_chart_checked_date']) {
                AppController::addWarningMsg(__('set last chart checked date to the date of the visit of the form you compelted today') . ' ' . $lastChartCheckedDateInDatabase);
                $participantData['Participant']['last_chart_checked_date'] = $lastVisitDateCompletedToday['EventMaster']['event_date'];
                $participantData['Participant']['last_chart_checked_date_accuracy'] = $lastVisitDateCompletedToday['EventMaster']['event_date_accuracy'];
            }
        } else {
            if ($nowDate > $participantData['Participant']['last_chart_checked_date']) {
                AppController::addWarningMsg(__('set last chart checked date to the current date') . ' ' . $lastChartCheckedDateInDatabase);
                $participantData['Participant']['last_chart_checked_date'] = $nowDate;
                $participantData['Participant']['last_chart_checked_date_accuracy'] = 'c';
            }
        }
        
        // *** 2 *** Last contact date
        
        $procureLastContactInDatabase = '';
        if (preg_match('/^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/', $participantData['Participant']['procure_last_contact'], $matches)) {
            switch ($participantData['Participant']['procure_last_contact_accuracy']) {
                case 'd':
                    $procureLastContactInDatabase = $matches[1] . '-' . $matches[2];
                    break;
                case 'm':
                case 'y':
                    $procureLastContactInDatabase = $matches[1];
                    break;
                default:
                    $procureLastContactInDatabase = $participantData['Participant']['procure_last_contact'];
            }
            $procureLastContactInDatabase = __("the 'last contact date' is currently set to '%s'", $procureLastContactInDatabase);
        }
        
        if ($lastVisitDateCompletedToday) {
            if ($lastVisitDateCompletedToday['EventMaster']['event_date'] > $participantData['Participant']['procure_last_contact']) {
                AppController::addWarningMsg(__('set last contact date to the date of the visit of the form you compelted today') . ' ' . $procureLastContactInDatabase);
                $participantData['Participant']['procure_last_contact'] = $lastVisitDateCompletedToday['EventMaster']['event_date'];
                $participantData['Participant']['procure_last_contact_accuracy'] = $lastVisitDateCompletedToday['EventMaster']['event_date_accuracy'];
            }
        }
    }
}
$this->Participant->addClinicalFileUpdateProcessInfo();