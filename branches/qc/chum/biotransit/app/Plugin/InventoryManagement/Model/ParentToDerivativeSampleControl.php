<?php

/**
 * Class ParentToDerivativeSampleControl
 */
class ParentToDerivativeSampleControl extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'ParentSampleControl' => array(
            'className' => 'InventoryManagement.SampleControl',
            'foreignKey' => 'parent_sample_control_id'
        ),
        'DerivativeControl' => array(
            'className' => 'InventoryManagement.SampleControl',
            'foreignKey' => 'derivative_sample_control_id'
        )
    );

    /**
     *
     * @return array
     */
    public function getActiveSamples()
    {
        $data = $this->find('all', array(
            'conditions' => array(
                'flag_active' => 1
            ),
            'recursive' => - 1
        ));
        $relations = array();
        // arrange the data
        foreach ($data as $unit) {
            $key = $unit["ParentToDerivativeSampleControl"]["parent_sample_control_id"];
            $value = $unit["ParentToDerivativeSampleControl"]["derivative_sample_control_id"];
            if (! isset($relations[$key])) {
                $relations[$key] = array();
            }
            $relations[$key][] = $value;
        }
        
        // start from the top and find the active samples
        return self::getActiveIdsFromRelations($relations, "");
    }

    /**
     *
     * @param $relations
     * @param $currentCheck
     * @return array
     */
    private static function getActiveIdsFromRelations($relations, $currentCheck)
    {
        $activeIds = array(
            '-1'
        ); // If no sample
        if (array_key_exists($currentCheck, $relations)) {
            foreach ($relations[$currentCheck] as $sampleId) {
                if ($currentCheck != $sampleId && $sampleId != 'already_parsed') {
                    $activeIds[] = $sampleId;
                    if (isset($relations[$sampleId]) && ! in_array('already_parsed', $relations[$sampleId])) {
                        $relations[$sampleId][] = 'already_parsed';
                        $activeIds = array_merge($activeIds, self::getActiveIdsFromRelations($relations, $sampleId));
                    }
                }
            }
        }
        return array_unique($activeIds);
    }

    /**
     * Gets the lab book control id that can be use by a derivative
     *
     * @param int $parentSampleCtrlId
     * @param int $childrenSampleCtrlId return int lab book control id on success, false if it's not found
     * @return bool
     */
    public function getLabBookControlId($parentSampleCtrlId, $childrenSampleCtrlId)
    {
        $labBookCtrlId = array_values($this->find('list', array(
            'fields' => array(
                'ParentToDerivativeSampleControl.lab_book_control_id'
            ),
            'conditions' => array(
                'ParentToDerivativeSampleControl.parent_sample_control_id' => $parentSampleCtrlId,
                'ParentToDerivativeSampleControl.derivative_sample_control_id' => $childrenSampleCtrlId
            )
        )));
        return empty($labBookCtrlId[0]) ? false : $labBookCtrlId[0];
    }
}