<?php

/**
 * Class CodingIcdo3sController
 */
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
    /**
     *
     * @param $useIcdType
     */
    public function tool($useIcdType)
    {
        parent::tool($useIcdType);
        $this->set("useIcdType", $useIcdType);
    }

    /**
     *
     * @param string $useIcdType
     * @param bool $isTool
     */
    public function search($useIcdType = "topo", $isTool = true)
    {
        $modelToUse = $this->getIcdo3Type($useIcdType);
        parent::globalSearch($isTool, $modelToUse);
        $this->set("useIcdType", $useIcdType);
    }

    /**
     *
     * @param string $useIcdType
     */
    public function autocomplete($useIcdType = "topo")
    {
        if ($useIcdType != "topo") {
            $_GET['term'] = preg_replace('/([0-9]{4})\/([0-9]){0,1}/', '$1$2', $_GET['term']);
        }
        parent::globalAutocomplete($this->getIcdo3Type($useIcdType));
    }

    /**
     *
     * @param $icdTypeName
     * @return mixed|null
     */
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