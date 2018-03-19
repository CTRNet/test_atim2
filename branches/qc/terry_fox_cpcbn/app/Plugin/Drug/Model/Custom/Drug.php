<?php

class DrugCustom extends Drug
{

    var $name = 'Drug';

    var $useTable = 'drugs';

    public function getHormDrugPermissibleValues()
    {
        $result = array();
        foreach ($this->find('all', array(
            'conditions' => array(
                'Drug.type' => 'hormonal'
            ),
            'order' => array(
                'Drug.generic_name'
            )
        )) as $drug) {
            $result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
        }
        return $result;
    }

    public function getChemoDrugPermissibleValues()
    {
        $result = array();
        foreach ($this->find('all', array(
            'conditions' => array(
                'Drug.type' => 'chemotherapy'
            ),
            'order' => array(
                'Drug.generic_name'
            )
        )) as $drug) {
            $result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
        }
        return $result;
    }

    public function getBoneDrugPermissibleValues()
    {
        $result = array();
        foreach ($this->find('all', array(
            'conditions' => array(
                'Drug.type' => 'bone'
            ),
            'order' => array(
                'Drug.generic_name'
            )
        )) as $drug) {
            $result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
        }
        return $result;
    }

    public function getHrDrugPermissibleValues()
    {
        $result = array();
        foreach ($this->find('all', array(
            'conditions' => array(
                'Drug.type' => 'HR'
            ),
            'order' => array(
                'Drug.generic_name'
            )
        )) as $drug) {
            $result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
        }
        return $result;
    }
}