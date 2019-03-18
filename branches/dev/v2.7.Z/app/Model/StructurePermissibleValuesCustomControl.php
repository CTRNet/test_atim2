<?php

/**
 * Class StructurePermissibleValuesCustomControl
 */
class StructurePermissibleValuesCustomControl extends AppModel
{

    public $name = 'StructurePermissibleValuesCustomControl';

    public function getLink($data)
    {
        $link = "";
        if (strpos($data["source"], "StructurePermissibleValuesCustom::getCustomDropdown(") === 0){
            preg_match("/(StructurePermissibleValuesCustom::getCustomDropdown\()(.+)(\))/", $data["source"], $a);
            if (count($a) == 4){
                $a = substr($a[2], 1, strlen($a[2])-2);
                $id = $this->find("first", array(
                    'conditions' => array(
                        'StructurePermissibleValuesCustomControl.name' => $a
                    ),
                    'fields' => array(
                        "StructurePermissibleValuesCustomControl.id"
                    ) 
                ));
                $id = $id["StructurePermissibleValuesCustomControl"]["id"];
                $link =  "Administrate/Dropdowns/view/" .$id;
            }
        }
        return (empty($link)) ? $link : array("link" => $link, "text" => $a);
    }
    
}