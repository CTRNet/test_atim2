<?php

class CodingIcdo3sController extends CodingIcdAppController
{

    public $uses = array(
        "CodingIcd.CodingIcdo3Topo",
        "CodingIcd.CodingIcdo3Morpho"
    );

    public $icdDescriptionTableFields = array(
        'description'
    );

    /*
     * Forms Helper appends a "tool" link to the "add" and "edit" form types
     * Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
     */
    public function tool($useIcdType)
    {
        parent::tool($useIcdType);
        $this->set("useIcdType", $useIcdType);
    }

    public function search($useIcdType = "topo", $isTool = true)
    {
        $modelToUse = $this->getIcdo3Type($useIcdType);
        parent::globalSearch($isTool, $modelToUse);
        $this->set("useIcdType", $useIcdType);
    }

    public function autocomplete($useIcdType = "topo")
    {
        parent::globalAutocomplete($this->getIcdo3Type($useIcdType));
    }

    public function getIcdo3Type($icdTypeName)
    {
        $modelToUse = null;
        if ($icdTypeName == "topo") {
            $modelToUse = $this->CodingIcdo3Topo;
        } elseif ($icdTypeName == "morpho") {
            $modelToUse = $this->CodingIcdo3Morpho;
        } else {
            $this->CodingIcdo3Topos->validationErrors[][] = __("invalid model for icdo3 search [" . $icdTypeName . "]");
            $modelToUse = $this->CodingIcdo3Topo;
        }
        return $modelToUse;
    }
}