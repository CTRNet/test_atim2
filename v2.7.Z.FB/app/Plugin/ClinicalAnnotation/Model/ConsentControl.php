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
        $alias = $this->alis;
        $model = $this->name;
        
        $detailTableName = 'detail_'.$alias."_".date('ymsHis');
        $data[$model]["detail_tablename"] = $detailTableName;
        $data[$model]["flag_active"] = 1;
        $data[$model]["display_order"] = 100;
        $data[$model]["databrowser_label"] = $data[$model]["controls_type"];
        $this->addWritableField(array("detail_tablename", "flag_active", "display_order", "databrowser_label"));
        
        
    }
    
    public function valiateLabels(&$data = array()){
        $typeValue = $data["ConsentControl"]["controls_type"];

        $labels = array (
            "id" => $typeValue,
            "fr" =>$data["ConsentControl"]["databrowser_label_fr"],
            "en" =>$data["ConsentControl"]["databrowser_label_en"]
        );

        unset ($data["ConsentControl"]["databrowser_label_fr"]);
        unset ($data["ConsentControl"]["databrowser_label_en"]);

        $i18nModel = new Model(array(
            'table' => 'i18n',
            'name' => 0
        ));
        $i18n = $i18nModel->find('first', array(
            "conditions" => array(
                "id" => $typeValue
            )
        ));


        if (!empty($i18n) && empty($i18n[0]["page_id"])) {
            $fr = $i18n[0]['fr'];
            $en = $i18n[0]['en'];
            if ($labels['fr'] != $fr || $labels['en'] != $en) {
                $labels['fr'] = $fr;
                $labels['en'] = $en;
                AppController::addWarningMsg(__("the labels are already exist and unchangeable"));
            }
        }elseif (empty($i18n)){
            $labels["page_id"] = "fb_temp";
        }

        $i18nModel->save($labels);
    }
    
}