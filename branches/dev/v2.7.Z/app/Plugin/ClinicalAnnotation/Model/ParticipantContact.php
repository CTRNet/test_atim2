<?php

class ParticipantContact extends ClinicalAnnotationAppModel
{

    public function beforeFind($queryData)
    {
        if (! AppController::getInstance()->Session->read('flag_show_confidential') && ! preg_match('/ParticipantContact\.confidential/', serialize($queryData['conditions']))) {
            $queryData['conditions'][] = 'ParticipantContact.confidential != 1';
        }
        return $queryData;
    }
}