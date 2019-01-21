<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    public function validates($options = array())
    {
        $res = parent::validates($options);
        
        $gldResult = true;
        if (array_key_exists('Participant', $this->data) && array_key_exists('date_of_birth', $this->data['Participant']) && array_key_exists('gld_dob_unknown', $this->data['Participant'])) {
            if (strlen($this->data['Participant']['date_of_birth']) && $this->data['Participant']['gld_dob_unknown']) {
                $this->validationErrors['date_of_birth'][] = __('unknown date of birth should not be completed');
                $gldResult = false;
            }
        }
        if (array_key_exists('Participant', $this->data) && array_key_exists('date_of_death', $this->data['Participant']) && array_key_exists('gld_dod_unknown', $this->data['Participant'])) {
            if (strlen($this->data['Participant']['date_of_death']) && $this->data['Participant']['gld_dod_unknown']) {
                $this->validationErrors['date_of_death'][] = __('unknown date of death should not be completed');
                $gldResult = false;
            }
        }
        
        return ($res && $gldResult)? true : false;
    }
}