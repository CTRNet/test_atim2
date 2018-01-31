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
            $this->unbindModel(array(
                'hasMany' => array(
                    'AliquotMaster'
                )
            ));
            $specimenData = $this->find('first', array(
                'conditions' => $criteria,
                'recursive' => 0
            ));
            
            $samplePrecision = '';
            if (array_key_exists('blood_type', $specimenData['SampleDetail']) && $specimenData['SampleDetail']['blood_type']) {
                $query = array(
                    'recursive' => 2,
                    'conditions' => array(
                        'StructureValueDomain.domain_name' => 'blood_type'
                    )
                );
                App::uses("StructureValueDomain", 'Model');
                $structureValueDomainModel = new StructureValueDomain();
                $bloodTypesList = $structureValueDomainModel->find('first', $query);
                if (isset($bloodTypesList['StructurePermissibleValue'])) {
                    foreach ($bloodTypesList['StructurePermissibleValue'] as $newType)
                        if ($newType['value'] == $specimenData['SampleDetail']['blood_type'])
                            $samplePrecision = ' - ' . __($newType['language_alias']);
                }
            }
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type']) . $samplePrecision . ' [' . $specimenData['SampleMaster']['sample_code'] . ']'
                ),
                'title' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type']) . ' [' . $specimenData['SampleMaster']['sample_code'] . ']'
                ),
                'data' => $specimenData,
                'structure alias' => 'sample_masters'
            );
        }
        
        return $return;
    }

    public function derivativeSummary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id']) && isset($variables['SampleMaster.id'])) {
            // Get derivative data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.id']
            );
            $this->unbindModel(array(
                'hasMany' => array(
                    'AliquotMaster'
                )
            ));
            $derivativeData = $this->find('first', array(
                'conditions' => $criteria,
                'recursive' => 0
            ));
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($derivativeData['SampleControl']['sample_type']) . ' [' . $derivativeData['SampleMaster']['sample_code'] . ']'
                ),
                'title' => array(
                    null,
                    __($derivativeData['SampleControl']['sample_type']) . ' [' . $derivativeData['SampleMaster']['sample_code'] . ']'
                ),
                'data' => $derivativeData,
                'structure alias' => 'sample_masters'
            );
        }
        
        return $return;
    }
}