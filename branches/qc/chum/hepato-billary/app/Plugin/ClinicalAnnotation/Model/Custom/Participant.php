<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    public function summary($variables = array())
    {
        $return = array();
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            $result['FunctionManagement'] = array(
                'health_insurance_card' => null,
                'saint_luc_hospital_nbr' => null
            );
            
            $miscIdentifierModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
            $identifiers = $miscIdentifierModel->find('all', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id'],
                    'MiscIdentifier.misc_identifier_control_id < ' => 4
                )
            ));
            
            // Add No Labs to description
            foreach ($identifiers as $identifier) {
                $showValue = ($identifier['MiscIdentifierControl']['flag_confidential'] && ! AppController::getInstance()->Session->read('flag_show_confidential'))? false : true;            
                if (in_array($identifier['MiscIdentifierControl']['misc_identifier_name'], array_keys($result['FunctionManagement']))) {
                    $result['FunctionManagement'][$identifier['MiscIdentifierControl']['misc_identifier_name']] = $showValue? $identifier['MiscIdentifier']['identifier_value'] : CONFIDENTIAL_MARKER;
                }
            }
            
            $return = array(
                'menu' => array(
                    null,
                    ($result['Participant']['first_name'] . ' - ' . $result['Participant']['last_name'])
                ),
                'title' => array(
                    null,
                    __('participant', true) . ': ' . ($result['Participant']['first_name'] . ' - ' . $result['Participant']['last_name'])
                ),
                'structure alias' => 'participants,qc_hb_ident_summary',
                'data' => $result
            );
        }
        
        return $return;
    }
}