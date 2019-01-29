<?php

/**
 * Class TreatmentControl
 */
class TreatmentControl extends ClinicalAnnotationAppModel
{

    public $masterFormAlias = 'treatmentmasters';

    /**
     * Get permissible values array gathering all existing treatment disease sites.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getDiseaseSitePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $txCtrl) {
            $result[$txCtrl['TreatmentControl']['disease_site']] = __($txCtrl['TreatmentControl']['disease_site']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     * Get permissible values array gathering all existing treatment method.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getMethodPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $txCtrl) {
            $result[$txCtrl['TreatmentControl']['tx_method']] = __($txCtrl['TreatmentControl']['tx_method']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @param $participantId
     * @param string $diagnosisMasterId
     * @return mixed
     */
    public function getAddLinks($participantId, $diagnosisMasterId = '')
    {
        $treatmentControls = $this->find('all', array(
            'conditions' => array(
                'TreatmentControl.flag_active' => 1
            )
        ));
        foreach ($treatmentControls as $treatmentControl) {
            $trtHeader = __($treatmentControl['TreatmentControl']['tx_method']) . (empty($treatmentControl['TreatmentControl']['disease_site']) ? '' : ' - ' . __($treatmentControl['TreatmentControl']['disease_site']));
            $addLinks[$trtHeader] = '/ClinicalAnnotation/TreatmentMasters/add/' . $participantId . '/' . $treatmentControl['TreatmentControl']['id'] . '/' . $diagnosisMasterId;
        }
        ksort($addLinks);
        return $addLinks;
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}