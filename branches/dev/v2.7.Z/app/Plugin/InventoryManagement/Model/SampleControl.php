<?php

class SampleControl extends InventoryManagementAppModel
{

    public $masterFormAlias = 'sample_masters';

    public $actsAs = array(
        'OrderByTranslate' => array(
            'sample_type',
            'sample_category'
        )
    );

    /**
     * Get permissible values array gathering all existing sample types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getSampleTypePermissibleValuesFromId()
    {
        return $this->getSamplesPermissibleValues(true, false);
    }

    public function getParentSampleTypePermissibleValuesFromId()
    {
        return $this->getSamplesPermissibleValues(true, false, false);
    }

    /**
     * Get permissible values array gathering all existing sample types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getSampleTypePermissibleValues()
    {
        return $this->getSamplesPermissibleValues(false, false);
    }

    public function getParentSampleTypePermissibleValues()
    {
        return $this->getSamplesPermissibleValues(false, false, false);
    }

    /**
     * Get permissible values array gathering all existing specimen sample types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getSpecimenSampleTypePermissibleValues()
    {
        return $this->getSamplesPermissibleValues(false, true);
    }

    /**
     * Get permissible values array gathering all existing specimen sample types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getSpecimenSampleTypePermissibleValuesFromId()
    {
        return $this->getSamplesPermissibleValues(true, true);
    }

    public function getSamplesPermissibleValues($byId, $onlySpecimen, $dontLimitToSamplesThatCanBeParents = true)
    {
        $result = array();
        
        // Build tmp array to sort according translation
        $this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
        $conditions = array(
            'ParentToDerivativeSampleControl.flag_active' => true
        );
        if ($onlySpecimen) {
            $conditions['DerivativeControl.sample_category'] = 'specimen';
        }
        $controls = null;
        $modelName = null;
        if ($dontLimitToSamplesThatCanBeParents) {
            $modelName = 'DerivativeControl';
            $controls = $this->ParentToDerivativeSampleControl->find('all', array(
                'conditions' => $conditions,
                'fields' => array(
                    'DerivativeControl.*'
                )
            ));
        } else {
            $modelName = 'ParentSampleControl';
            $conditions['NOT'] = array(
                'ParentToDerivativeSampleControl.parent_sample_control_id' => null
            );
            $controls = $this->ParentToDerivativeSampleControl->find('all', array(
                'conditions' => $conditions,
                'fields' => array(
                    'ParentSampleControl.id',
                    'ParentSampleControl.sample_type'
                )
            ));
        }
        
        if ($byId) {
            foreach ($controls as $control) {
                $result[$control[$modelName]['id']] = __($control[$modelName]['sample_type']);
            }
        } else {
            foreach ($controls as $control) {
                $result[$control[$modelName]['sample_type']] = __($control[$modelName]['sample_type']);
            }
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     * Gets a list of sample types that could be created from a sample type.
     *
     * @param $sampleControlId ID
     *            of the sample control linked to the studied sample.
     *            
     * @return List of allowed aliquot types stored into the following array:
     *         array('aliquot_control_id' => 'aliquot_type')
     *        
     * @author N. Luc
     * @since 2009-11-01
     * @author FMLH 2010-08-04 (new flag_active policy)
     */
    public function getPermissibleSamplesArray($parentId)
    {
        $conditions = array(
            'ParentToDerivativeSampleControl.flag_active' => true
        );
        if ($parentId == null) {
            $conditions[] = 'ParentToDerivativeSampleControl.parent_sample_control_id IS NULL';
        } else {
            $conditions['ParentToDerivativeSampleControl.parent_sample_control_id'] = $parentId;
        }
        
        $this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
        $controls = $this->ParentToDerivativeSampleControl->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'DerivativeControl.*'
            )
        ));
        $specimenSampleControlsList = array();
        foreach ($controls as $control) {
            $specimenSampleControlsList[$control['DerivativeControl']['id']]['SampleControl'] = $control['DerivativeControl'];
        }
        return $specimenSampleControlsList;
    }

    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}