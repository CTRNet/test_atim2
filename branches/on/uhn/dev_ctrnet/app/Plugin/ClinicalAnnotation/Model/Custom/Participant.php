<?php

/** **********************************************************************
 * UHN
 * ***********************************************************************
 *
 * CLinicalAnnotation plugin custom code
 *
 * Class AliquotMasterCustom
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-06-20
 */
    
/**
 * Class Participant
 */
class ParticipantCustom extends Participant
{
    var $useTable = 'participants';
    
    var $name = "Participant";
    
    /**
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    ($result['Participant']['participant_identifier'])
                ),
                'title' => array(
                    null,
                    ($result['Participant']['participant_identifier'])
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
        }
        
        return $return;
    }

    /**
     *
     * @param array $options            
     * @return bool
     */
    public function beforeSave($options = array())
    {
        if (isset($this->data['Participant']) && array_key_exists('uhn_mrn_number', $this->data['Participant']) && ! strlen($this->data['Participant']['uhn_mrn_number'])) {
            // Remove field to set default value to NULL and don't generate an error on unique constraint
            unset($this->data['Participant']['uhn_mrn_number']);
        }
        return parent::beforeSave($options);
    }
}