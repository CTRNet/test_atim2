<?php 


    class ConsentMasterCustom extends ConsentMaster {

        var $name = 'ConsentMaster';
        var $useTable = 'consent_masters';

        /**

        

        **/

        function calculateDateInterval($data, $consentMasterId) {
            //pr('Inside calculateDateInterval Function');
            //pr($data);
            //pr($consentMasterId);
            $arrayDatetimeDeath = $data['ConsentDetail']['death_datetime'];
            $arrayDatetimeAutopsy = $data['ConsentDetail']['autopsy_datetime'];

            $datetimeDeath = $this->createDatetimeFromArray($arrayDatetimeDeath);
            $datetimeAutopsy = $this->createDatetimeFromArray($arrayDatetimeAutopsy);

            pr($datetimeDeath->format('Y-m-d H:i:s'));
            pr($datetimeAutopsy->format('Y-m-d H:i:s'));

            $interval = $datetimeDeath->diff($datetimeAutopsy);
            $intervalDays = $interval->days;
 
            if($intervalDays == 0) {
                $intervalHours = $interval->h + bcdiv($interval->i, 60, 2);
            } else {
                $intervalHours = ($intervalDays * 24) + $interval->h + bcdiv($interval->i, 60, 2);
            }

            //pr($interval->format('%days'));
            print_r($interval);
            pr($intervalDays);
            pr($intervalHours);
            //pr('Interval is');
            //pr($interval->format('%d'));
            //pr($interval_integer);

            //$datetimeDeath = $arrayDatetimeDeath['year'] . '-' . $arrayDatetimeDeath['month'] . '-' . $arrayDatetimeDeath['day'] .

            

            $query = "UPDATE cd_biobanks SET `postmortum_interval`='" . $intervalHours . "' WHERE `consent_master_id`=" . $consentMasterId . ";";
            //pr($query);
            $this->tryCatchQuery($query);

            $query = "UPDATE cd_biobanks_revs SET `postmortum_interval`='" . $intervalHours . "' WHERE `consent_master_id`=" . $consentMasterId . " ORDER BY `version_id` DESC LIMIT 1;";
            //pr($query);
            $this->tryCatchQuery($query);

            //exit("calculateDateIntervalFunction");

            return null;
        }

        function createDatetimeFromArray($datetimeArray) {
            //pr($datetimeArray);

            $datetimeString = $datetimeArray['year'] . '-' . $datetimeArray['month'] . '-' . $datetimeArray['day'] . ' ' . $datetimeArray['hour'] . ':' . $datetimeArray['min'] . ':00';
            
            //pr($datetimeString);

            $datetime = DateTime::createFromFormat('Y-m-d H:i:s', $datetimeString);
            //echo $datetime->format('Y-m-d H:i:s');
            
            return $datetime;
        }

        function testCalculateDateInterval($data, $consentMasterId) {
            return null;
        }

        function testCreateDatetimeFromArray($datetimeArray) {
            return null;
        }

    }