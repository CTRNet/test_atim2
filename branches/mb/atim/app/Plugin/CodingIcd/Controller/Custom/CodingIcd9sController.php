<?php

class CodingIcd9sControllerCustom extends CodingIcd9sController
{

    var $uses = array(
        "CodingIcd.CodingIcd9",
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

    public function search($useIcdType = "icd9", $isTool = true)
    {
        parent::globalSearch($isTool, $this->getIcd9Type($useIcdType));
        $this->set("useIcdType", $useIcdType);
    }

    public function autocomplete($useIcdType = "icd9")
    {
        parent::globalAutocomplete($this->getIcd9Type($useIcdType));
    }

    public function getIcd9Type($icdTypeName)
    {
        $modelToUse = null;
        if ($icdTypeName == "icd9") {
            $modelToUse = $this->CodingIcd9;
        } elseif ($icdTypeName == "ca") {
            $modelToUse = $this->CodingIcd10Ca;
        } else {
            $this->CodingIcd9->validationErrors[] = __("invalid model for icd9s search [" . $icdTypeName . "]", true);
            $modelToUse = $this->CodingIcd10Who;
        }
        return $modelToUse;
    }
}