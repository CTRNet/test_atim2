<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

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