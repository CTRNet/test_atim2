<?php

/**
 * Class TreatmentExtendControl
 */
class TreatmentExtendControlCustom extends TreatmentExtendControl
{

    var $useTable = 'treatment_extend_controls';

    var $name = 'TreatmentExtendControl';

    /**
     * @return array
     */
    public function getPrecisionTypeValues()
    {
        $result = parent::getPrecisionTypeValues();
        $result['chemotherapy complications'] = __('chemotherapy complications');
        natcasesort($result);
        return $result;
    }
}