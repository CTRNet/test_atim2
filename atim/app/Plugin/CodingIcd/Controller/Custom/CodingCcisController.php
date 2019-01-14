<?php

class CodingCcisControllerCustom extends CodingCcisController
{

    var $uses = array(
        "CodingIcd.CodingCci",
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

    public function search($useIcdType = "cci", $isTool = true)
    {
        parent::globalSearch($isTool, $this->getCciType($useIcdType));
        $this->set("useIcdType", $useIcdType);
    }

    public function autocomplete($useIcdType = "cci")
    {
        parent::globalAutocomplete($this->getCciType($useIcdType));
    }

    public function getCciType($icdTypeName)
    {
        $modelToUse = null;
        if ($icdTypeName == "cci") {
            $modelToUse = $this->CodingCci;
        } elseif ($icdTypeName == "ca") {
            $modelToUse = $this->CodingIcd10Ca;
        } else {
            $this->CodingIcd9->validationErrors[] = __("invalid model for icd9s search [" . $icdTypeName . "]", true);
            $modelToUse = $this->CodingIcd10Who;
        }
        return $modelToUse;
    }
}