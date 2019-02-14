<?php

/**
 * Class FormBuilder
 */
class FormBuilder extends AdministrateAppModel
{
    public function getDataFromAlias($data, $model)
    {
        $result = array(
            "master" => $this->getData($data["master"], $model),
            "detail" => $this->getData($data["detail"], $model)
        );
        return $result;
    }
    
    private function getData($data, $model)
    {
        $result = array();
        $dataTemp = $data[0]["structure"]["Sfs"];
        foreach ($dataTemp as $d) {
            if ($model == $d["model"]){
                $tempFields = array();
                $tempFields["StructureField"]["language_label"]=(!empty($d["language_label"]))?$d["language_label"]:$d["language_tag"];
                $tempFields["StructureField"]["type"]=$d["type"];
                $tempFields["StructureField"]["flag_confidential"]=$d["flag_confidential"];
                $tempFields["StructureField"]["language_help"]=__($d["language_help"]);
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
        }
        return $result;
    }
    
    public function checkValidation($type)
    {
        $validation = null;
        if (isset($type)){
            if (in_array($type, array('date', 'datetime', 'time'))){
                $validation = array("is_unique", "not_blank");
            }
            if (in_array($type, array('float', 'integer', 'integer_positive'))){
                $validation = array("is_unique", "not_blank", "range_from");
            }
            if (in_array($type, array('input', 'textarea'))){
                $validation = array("is_unique", "not_blank", "between_from", "alpha_numeric");
            }
            if (in_array($type, array('yes_no', 'select'))){
                $validation = array("not_blank");
            }
            if (in_array($type, array('checkbox'))){
                $validation = null;
            }
            
        }
        return $validation;
    }
    
    public function normalised($data, $type)
    {
        $response = "";
        if($type == "validation" || true){
            if (isset($data["FunctionManagement"]['is_unique'])){
                $response = ($data["FunctionManagement"]['is_unique'])?$response . __("unique") . " & " : $response;
            }
            if (isset($data["FunctionManagement"]['not_blank'])){
                $response = ($data["FunctionManagement"]['not_blank'])?$response . __("required") . " & " : $response;
            }
            if (isset($data["FunctionManagement"]['between_from']) && $data["FunctionManagement"]['between_from']!=""){
                $response .= __("length from %s to %s", $data["FunctionManagement"]['between_from'], $data["FunctionManagement"]['between_to']) . " & ";
            }
            if (isset($data["FunctionManagement"]['range_from']) && $data["FunctionManagement"]['range_from']!=""){
                $response .= __("value from %s to %s", $data["FunctionManagement"]['range_from'], $data["FunctionManagement"]['range_to']) . " & ";
            }
        }else if($type == "valuedomain"){
            $response = "Test-Yaser";
        }
        
        if (!empty($response)){
            $response = substr($response, 0, strlen($response)-3);
        }
        $response = json_encode(array("text" => $response, "title" => str_replace(" & ", "\n", $response)));
        return $response;
    }
}