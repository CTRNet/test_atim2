<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    public function beforeSave($options = array())
    {
        if (array_key_exists('Participant', $this->data) && array_key_exists('date_of_birth', $this->data['Participant']) && array_key_exists('date_of_death', $this->data['Participant'])) {
            // Calculate time to death
            $startDate = $this->data['Participant']['date_of_birth'];
            $startDateAccuracy = $this->data['Participant']['date_of_birth_accuracy'];
            $startDateOb = new DateTime($startDate);
            $endDate = $this->data['Participant']['date_of_death'];
            $endDateAccuracy = $this->data['Participant']['date_of_death_accuracy'];
            $endDateOb = new DateTime($endDate);
            $timeToDeath = '';
            if ($startDate && $endDate) {
                $interval = $startDateOb->diff($endDateOb);
                if ($interval->invert) {
                    AppController::addWarningMsg(__("'time to death' cannot be calculated because dates are not chronological"));
                } else {
                    $timeToDeath = $interval->y;
                }
                if ($timeToDeath && ($startDateAccuracy . $endDateAccuracy) != 'cc') {
                    AppController::addWarningMsg(__("'time to death' has been calculated with at least one inaccurate date"));
                }
            }
            $this->data['Participant']['time_to_death'] = $timeToDeath;
            $this->addWritableField(array(
                'time_to_death'
            ));
        }
        
        return parent::beforeSave($options);
    }
}