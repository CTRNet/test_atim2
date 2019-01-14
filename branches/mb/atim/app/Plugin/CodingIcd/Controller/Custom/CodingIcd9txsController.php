<?php

class CodingIcd9txsControllerCustom extends CodingIcd9txsController
{

    var $uses = array(
        "CodingIcd.CodingIcd9tx",
        "CodingIcd.CodingIcd10Ca"
    );

    /*
     * Forms Helper appends a "tool" link to the "add" and "edit" form types
     * Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
     */
    public function tool($useIcdType)
    {
        parent::tool();
        $this->set("useIcdType", $useIcdType);
    }

    public function search($useIcdType = "icd9tx", $isTool = true)
    {
        parent::globalSearch($isTool, $this->getIcd9Type($useIcdType));
        $this->set("useIcdType", $useIcdType);
    }

    public function autocomplete($useIcdType = "icd9tx")
    {
        parent::globalAutocomplete($this->getIcd9txType($useIcdType));
    }

    public function getIcd9txType($icdTypeName)
    {
        $modelToUse = null;
        if ($icdTypeName == "icd9tx") {
            $modelToUse = $this->CodingIcd9tx;
        } else 
            if ($icdTypeName == "ca") {
                $modelToUse = $this->CodingIcd10Ca;
            } else {
                $this->CodingIcd9->validationErrors[] = __("invalid model for icd9s search [" . $icdTypeName . "]", true);
                $modelToUse = $this->CodingIcd10Who;
            }
        return $modelToUse;
    }
}