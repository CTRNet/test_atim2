<?php

/**
 * Class ConsentControl
 */
class ConsentControl extends ClinicalAnnotationAppModel
{

    public $masterFormAlias = 'consent_masters';

    /**
     * Get permissible values array gathering all existing consent types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getConsentTypePermissibleValuesFromId()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $consentControl) {
            $result[$consentControl['ConsentControl']['id']] = __($consentControl['ConsentControl']['controls_type']);
        }
        natcasesort($result);
        
        return $result;
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

    public function setDataBeforeSaveFB(&$data)
    {
        $model = $this->name;
        $maxDisplayOrder = $this->find("first", array(
            'fields'=>array("display_order"),
            'order'=>array("display_order DESC")
        ));

        $field = "controls_type";

        $name = preg_replace('/\s+/', '_', $data[$model][$field]);
        $aliasPart = substr($name, 0, 10);

        $detailTableName = 'cd_'.$aliasPart."_".date('YmsHis');
        $data[$model]["detail_tablename"] = $detailTableName;
        $data[$model]["detail_form_alias"] = $detailTableName;
        $data[$model]["flag_active"] = 1;
        $data[$model]["display_order"] = $maxDisplayOrder[$this->name]["display_order"] + 1;
        $data[$model]["databrowser_label"] = $name;
        $data[$model]["is_test_mode"] = '1';
        $this->addWritableField(array("detail_tablename", "flag_active", "display_order", "databrowser_label", "detail_form_alias", "is_test_mode"));
    }

}