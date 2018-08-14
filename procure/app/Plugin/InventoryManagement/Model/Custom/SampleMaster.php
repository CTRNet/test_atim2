<?php

class SampleMasterCustom extends SampleMaster
{

    var $useTable = 'sample_masters';

    var $name = 'SampleMaster';

    function specimenSummary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
            // Get specimen data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']
            );
            $specimen_data = $this->find('first', array(
                'conditions' => $criteria
            ));
            
            $precision = isset($specimen_data['SampleDetail']['blood_type']) ? ' ' . __($specimen_data['SampleDetail']['blood_type']) : '';
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($specimen_data['SampleControl']['sample_type']) . $precision . ' : ' . $specimen_data['SampleMaster']['sample_code']
                ),
                'title' => array(
                    null,
                    __($specimen_data['SampleControl']['sample_type']) . $precision . ' : ' . $specimen_data['SampleMaster']['sample_code']
                ),
                'data' => $specimen_data,
                'structure alias' => 'sample_masters'
            );
        }
        
        return $return;
    }
}
