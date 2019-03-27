<?php

/**
 * Class CodingIcd10sController
 */
class CodingIcd10sController extends CodingIcdAppController
{

    public $uses = array(
        "CodingIcd.CodingIcd10Who",
        "CodingIcd.CodingIcd10Ca"
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
    public function search($useIcdType = "who", $isTool = true)
    {
        parent::globalSearch($isTool, $this->getIcd10Type($useIcdType));
        $this->set("useIcdType", $useIcdType);
    }

    /**
     *
     * @param string $useIcdType
     */
    public function autocomplete($useIcdType = "who")
    {
        $_GET['term'] = preg_replace('/([cC][0-9]{2})\.([0-9]){0,1}/', '$1$2', $_GET['term']);
        parent::globalAutocomplete($this->getIcd10Type($useIcdType));
    }

    /**
     *
     * @param $icdTypeName
     * @return mixed|null
     */
    public function getIcd10Type($icdTypeName)
    {
        $modelToUse = null;
        if ($icdTypeName == "who") {
            $modelToUse = $this->CodingIcd10Who;
        } elseif ($icdTypeName == "ca") {
            $modelToUse = $this->CodingIcd10Ca;
        } else {
            $this->CodingIcd10->validationErrors[][] = __("invalid model for icd10 search [" . $icdTypeName . "]");
            $modelToUse = $this->CodingIcd10Who;
        }
        return $modelToUse;
    }
}