<?php

/**
 * Class FormBuilder
 */
class FormBuilder extends AdministrateAppModel
{
    public function getDataFromAlias($data)
    {
        $result = array(
            "master" => $this->getData($data["master"]),
            "detail" => $this->getData($data["detail"])
        );
        return $result;
    }
    
    private function getData($data)
    {
        $result = array();
        $dataTemp = $data[0]["structure"]["Sfs"];
        foreach ($dataTemp as $d) {
            $tempFields = array();
            $tempFields["StructureField"]["language_label"]=(!empty($d["language_label"]))?$d["language_label"]:$d["language_tag"];
            $tempFields["StructureField"]["type"]=$d["type"];
            $tempFields["StructureField"]["flag_confidential"]=$d["flag_confidential"];
            $tempFields["StructureField"]["language_help"]=$d["language_help"];
            $tempFields["StructureFormat"]["flag_add"]=$d["flag_add"];
            $tempFields["StructureFormat"]["flag_edit"]=$d["flag_edit"];
            $tempFields["StructureFormat"]["flag_search"]=$d["flag_search"];
            $tempFields["StructureFormat"]["flag_index"]=$d["flag_index"];
            $tempFields["StructureFormat"]["flag_detail"]=$d["flag_detail"];
            $tempFields["StructureFormat"]["language_heading"]=$d["language_heading"];
            $tempFields["StructureFormat"]["display_column"]=$d["display_column"];
            $tempFields["StructureFormat"]["display_order"]=$d["display_order"];
            $result[] = $tempFields;
        }
        return $result;
    }
}