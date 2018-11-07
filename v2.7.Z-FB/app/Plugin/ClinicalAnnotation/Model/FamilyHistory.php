<?php

/**
 * Class FamilyHistory
 */
class FamilyHistory extends ClinicalAnnotationAppModel
{

    /**
     *
     * @param array $variables
     * @return bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        // if ( isset($variables['FamilyHistory.id']) ) {
        //
        // $result = $this->find('first', array('conditions'=>array('FamilyHistory.id'=>$variables['FamilyHistory.id'])));
        //
        // $return = array(
        // 'data' => $result,
        // 'structure alias'=>'familyhistories'
        // );
        // }
        
        return $return;
    }

    /**
     * Replaces icd10 empty string to null values to respect foreign keys constraints
     *
     * @param $participantArray
     */
    public function patchIcd10NullValues(&$participantArray)
    {
        if (array_key_exists('primary_icd10_code', $participantArray['FamilyHistory']) && strlen(trim($participantArray['FamilyHistory']['primary_icd10_code'])) == 0) {
            $participantArray['FamilyHistory']['primary_icd10_code'] = null;
        }
    }
}