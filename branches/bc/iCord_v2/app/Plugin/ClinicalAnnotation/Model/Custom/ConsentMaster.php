<?php

class ConsentMasterCustom extends ConsentMaster
{

    var $name = 'ConsentMaster';

    var $useTable = 'consent_masters';
    
    public function calculateDateInterval($data, $consentMasterId)
    {
        $arrayDatetimeDeath = $data['ConsentDetail']['death_datetime'];
        $arrayDatetimeAutopsy = $data['ConsentDetail']['autopsy_datetime'];
        
        $datetimeDeath = $this->createDatetimeFromArray($arrayDatetimeDeath);
        $datetimeAutopsy = $this->createDatetimeFromArray($arrayDatetimeAutopsy);
        
        $interval = $datetimeDeath->diff($datetimeAutopsy);
        $intervalDays = $interval->days;
        
        if ($intervalDays == 0) {
            $intervalHours = $interval->h + bcdiv($interval->i, 60, 2);
        } else {
            $intervalHours = ($intervalDays * 24) + $interval->h + bcdiv($interval->i, 60, 2);
        }
        
        $query = "UPDATE cd_biobanks SET `postmortum_interval`='" . $intervalHours . "' WHERE `consent_master_id`=" . $consentMasterId . ";";
        $this->tryCatchQuery($query);
        
        $query = "UPDATE cd_biobanks_revs SET `postmortum_interval`='" . $intervalHours . "' WHERE `consent_master_id`=" . $consentMasterId . " ORDER BY `version_id` DESC LIMIT 1;";
        $this->tryCatchQuery($query);
        
        return null;
    }

    public function createDatetimeFromArray($datetimeArray)
    {
        $datetimeString = $datetimeArray['year'] . '-' . $datetimeArray['month'] . '-' . $datetimeArray['day'] . ' ' . $datetimeArray['hour'] . ':' . $datetimeArray['min'] . ':00';
        $datetime = DateTime::createFromFormat('Y-m-d H:i:s', $datetimeString); 
        return $datetime;
    }

    public function testCalculateDateInterval($data, $consentMasterId)
    {
        return null;
    }

    public function testCreateDatetimeFromArray($datetimeArray)
    {
        return null;
    }
}