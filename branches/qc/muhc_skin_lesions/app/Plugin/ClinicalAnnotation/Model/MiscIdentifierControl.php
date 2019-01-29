<?php

/**
 * Class MiscIdentifierControl
 */
class MiscIdentifierControl extends ClinicalAnnotationAppModel
{

    private $confidentialIds = null;

    /**
     * Get permissible values array gathering all existing misc identifier names.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getMiscIdentifierNamePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $identCtrl) {
            $result[$identCtrl['MiscIdentifierControl']['misc_identifier_name']] = __($identCtrl['MiscIdentifierControl']['misc_identifier_name']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     * Get permissible values array gathering all existing misc identifier names.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getMiscIdentifierNamePermissibleValuesFromId()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $identCtrl) {
            $result[$identCtrl['MiscIdentifierControl']['id']] = __($identCtrl['MiscIdentifierControl']['misc_identifier_name']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @return array|null
     */
    public function getConfidentialIds()
    {
        if ($this->confidentialIds == null) {
            $miscControls = $this->find('all', array(
                'fields' => array(
                    'MiscIdentifierControl.id'
                ),
                'conditions' => array(
                    'flag_confidential' => 1
                )
            ));
            $this->confidentialIds = array();
            foreach ($miscControls as $miscControl) {
                $this->confidentialIds[] = $miscControl['MiscIdentifierControl']['id'];
            }
        }
        return $this->confidentialIds;
    }
}