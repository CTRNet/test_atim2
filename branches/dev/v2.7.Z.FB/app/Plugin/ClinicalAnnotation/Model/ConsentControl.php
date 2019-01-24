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

    public function setDataBeforeSave(&$data = array())
    {
        $model = $this->name;
        $maxDisplayOrder = $this->find("first", array(
            'fields'=>array("display_order"),
            'order'=>array("display_order DESC")
        ));
        
        $detailTableName = 'cd_'.substr($data[$model]["controls_type"], 0, 10)."_".date('YmsHis');
        $data[$model]["detail_tablename"] = $detailTableName;
        $data[$model]["detail_form_alias"] = $detailTableName;
        $data[$model]["flag_active"] = 1;
        $data[$model]["display_order"] = $maxDisplayOrder[$this->name]["display_order"] + 1;
        $data[$model]["databrowser_label"] = $data[$model]["controls_type"];
        $data[$model]["is_test_mode"] = '1';
        $this->addWritableField(array("detail_tablename", "flag_active", "display_order", "databrowser_label", "detail_form_alias", "is_test_mode"));

    }
    
    public function valiateLabels(&$data = array()){
        $model = $this->name;
        $typeValue = $data[$model]["controls_type"];

        $labels = array (
            "id" => $typeValue,
            "fr" =>$data[$model]["databrowser_label_fr"],
            "en" =>$data[$model]["databrowser_label_en"]
        );

        unset ($data[$model]["databrowser_label_fr"]);
        unset ($data[$model]["databrowser_label_en"]);

        $i18nModel = new Model(array(
            'table' => 'i18n',
            'name' => 0
        ));
        $i18n = $i18nModel->find('first', array(
            "conditions" => array(
                "id" => $typeValue
            )
        ));


        if (!empty($i18n) && (empty($i18n[0]["page_id"]) || $i18n[0]["page_id"] == "global")) {
            $fr = $i18n[0]['fr'];
            $en = $i18n[0]['en'];
            if ($labels['fr'] != $fr || $labels['en'] != $en) {
                $labels['fr'] = $fr;
                $labels['en'] = $en;
                AppController::addWarningMsg(__("the labels are already exist and unchangeable"));
            }
        }else{
            if (empty($i18n)){
                $labels["page_id"] = $data[$model]["detail_tablename"];
            }elseif (!empty($i18n[0]['page_id'])){
                $pageIds = explode(",", $i18n[0]['page_id']);
                $pageIds[] = $data[$model]["detail_tablename"];
                $labels["page_id"] = implode(",", $pageIds);
            }
            $i18nModel->save($labels);
        }

    }
    
}