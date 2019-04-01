<?php

/**
 * Class StructureValidation
 */
class StructureValidation extends AppModel
{

    public $name = 'StructureValidation';

    public function setDataBeforeSaveFB(&$data, $options = array())
    {
        $validationData = json_decode($data["validationData"], true);
        $validationNormalizedData = array();
        if (isset($options["prefix-common"])) {
            $dataCommon = isset($data[$options["prefix-common"]]) ? $data[$options["prefix-common"]] : array();
            $index = 0;
            foreach ($dataCommon as $key => &$value) {
                if (is_numeric($key)) {
                    if($value['StructureField']['type'] =="validateIcd10WhoCode"){
                        $errorMessage = "invalid disease code";
                        $setting = "size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who";
                    }elseif($value['StructureField']['type'] =="validateIcdo3MorphoCode"){
                        $errorMessage = "invalid morphology code";
                        $setting = "size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/morpho,tool=/CodingIcd/CodingIcdo3s/tool/morpho";
                    }elseif($value['StructureField']['type'] =="validateIcdo3TopoCode"){
                        $errorMessage = "invalid topography code";
                        $setting = "size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo";
                    }
                    if (in_array($value['StructureField']['type'], array("validateIcd10WhoCode", "validateIcdo3MorphoCode", "validateIcdo3TopoCode", "validateIcd10CaCode"))!==false){
                        $validationNormalizedData[] = array(
                            "structure_field_id" => $index,
                            "rule" => $value['StructureField']['type'],
                            "language_message" => $errorMessage
                        );
                        $value['StructureField']['type'] = "autocomplete";
                        $value['StructureField']['setting'] = $setting;
                    }
                    $validation = $validationData[$index];
                    if (is_array($validation)){
                        foreach ($validation as $k1 => $v1){
                            if ($v1['name'] == "data[FunctionManagement][between_from]"  && isset($v1['value']) && $v1['value'] != ""){
                                $vFrom = $v1['value'];
                                $vTo = "";
                                foreach ($validation as $k2 => $v2){
                                    if ($v2['name'] == "data[FunctionManagement][between_to]"){
                                        $vTo = $v2['value'];
                                        unset($validation[$k2]);
                                        unset($validation[$k1]);
                                        break;
                                    }
                                }
                                if (!empty($vTo)){
                                    $validationNormalizedData[] = array(
                                        "structure_field_id" => $index,
                                        "rule" => "between,$vFrom,$vTo",
                                        "language_message" => "error-the {$value['StructureField']['language_label']} length should be between $vFrom and $vTo"
                                    );
                                }
                            }
                            if ($v1['name'] == "data[FunctionManagement][range_from]" && isset($v1['value']) && $v1['value'] != ""){
                                $vFrom = $v1['value'];
                                $vTo = "";
                                foreach ($validation as $k2 => $v2){
                                    if ($v2['name'] == "data[FunctionManagement][range_to]"){
                                        $vTo = $v2['value'];
                                        unset($validation[$k2]);
                                        unset($validation[$k1]);
                                        break;
                                    }
                                }
                                $vf=0;
                                $vt=0;
                                if ($value['StructureField']['type'] == "float"){
                                    $vf = $vFrom - 0.00001;
                                    $vt = $vTo + 0.00001;
                                }else{
                                    $vf = $vFrom - 1;
                                    $vt = $vTo + 1;
                                }
                                if (!empty($vTo)){
                                    $validationNormalizedData[] = array(
                                        "structure_field_id" => $index,
                                        "rule" => "range,$vf,$vt",
                                        "language_message" => __("error-the %s should be between %s and %s", $value['StructureField']['language_label'], $vFrom, $vTo)
                                    );
                                }
                            }
                            if($v1['name'] == "data[FunctionManagement][is_unique]"  && isset($v1['value']) && $v1['value'] == 1){
                                $validationNormalizedData[] = array(
                                    "structure_field_id" => $index,
                                    "rule" => "isUnique",
                                    "language_message" => "error- {$value['StructureField']['language_label']} must be unique"
                                );
                                
                            }

                            if($v1['name'] == "data[FunctionManagement][not_blank]" && isset($v1['value']) && $v1['value'] ==1){
                                $validationNormalizedData[] = array(
                                    "structure_field_id" => $index,
                                    "rule" => "notBlank",
                                    "language_message" => "error- {$value['StructureField']['language_label']} field is required"
                                );
                            }
                        }
                    }
                    $index++;
                }
            }
            unset ($data["validationData"]);
            $data["StructureValidation"] = $validationNormalizedData;
            $data[$options["prefix-common"]] = $dataCommon;
        }
    }

    
    public function validatesFormBuilder($metaData, $options = array()) {
        
        return parent::validates($options);
    }
}