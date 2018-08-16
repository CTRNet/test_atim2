<?php

class SampleMasterCustom extends SampleMaster
{

    var $useTable = 'sample_masters';

    var $name = 'SampleMaster';

    public function specimenSummary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
            // Get specimen data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']
            );
            $specimenData = $this->find('first', array(
                'conditions' => $criteria
            ));
            
            $precision = isset($specimenData['SampleDetail']['blood_type']) ? ' ' . __($specimenData['SampleDetail']['blood_type']) : '';
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type']) . $precision . ' : ' . $specimenData['SampleMaster']['sample_code']
                ),
                'title' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type']) . $precision . ' : ' . $specimenData['SampleMaster']['sample_code']
                ),
                'data' => $specimenData,
                'structure alias' => 'sample_masters'
            );
        }
        
        return $return;
    }
        
// *** PROCURE CHUM **************************************************************************
    public function validates($options = array())
    {
        $valRes = parent::validates($options);
        if (isset($this->data['SampleDetail']['blood_type']) && ! in_array($this->data['SampleDetail']['blood_type'], array(
            'k2-EDTA',
            'paxgene',
            'serum'
        ))) {
            $this->validationErrors['blood_type'][] = 'this blood type can not be used anymore';
            return false;
        }
        return $valRes;
    }
//*** END PROCURE CHUM **************************************************************************
    
}