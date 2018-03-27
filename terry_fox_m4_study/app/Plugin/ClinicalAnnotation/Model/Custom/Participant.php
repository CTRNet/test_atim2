<?php
/** **********************************************************************
 * TFRI-4MS Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    function summary($variables = array())
    {
        $return = false;
        if (isset($variables['Participant.id'])) {
            $structurePermissibleValuesCustomModel = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            $label = $structurePermissibleValuesCustomModel->getTranslatedCustomDropdownValue('TFRI 4MS Site IDs', $result['Participant']['tfri_m4s_site_id']) . ' ' . $result['Participant']['tfri_m4s_site_patient_id'];
            $return = array(
                'menu' => array(
                    NULL,
                    $label
                ),
                'title' => array(
                    NULL,
                    $label
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
        }
        
        return $return;
    }


    /**
     * Validate Site Id & Patient Id combination is unique.
     * 
     * @param array $options
     * @return array|bool
     */
    function validates($options = array())
    {
        $result = parent::validates($options);
        
        if (array_key_exists('tfri_m4s_site_id', $this->data['Participant'])) {
            $conditions = array(
                'Participant.tfri_m4s_site_id' => $this->data['Participant']['tfri_m4s_site_id'],
                'Participant.tfri_m4s_site_patient_id' => $this->data['Participant']['tfri_m4s_site_patient_id']
            );
            if ($this->id) {
                $conditions[] = 'Participant.id != ' . $this->id;
            }
            $count = $this->find('count', array(
                'conditions' => $conditions
            ));
            if ($count) {
                $this->validationErrors['qbcf_bank_participant_identifier'][] = 'the site patient id should be unique for the site';
                $result = false;
            }
        }
        return $result;
    }
}

?>