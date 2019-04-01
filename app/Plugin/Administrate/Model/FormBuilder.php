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
    
    public function normalisedAndSave($data = null, $validate = false, $fieldList = array())
    {
        $models = $data["models"];
        
        $modelInstance = AppModel::getInstance($models["main"]["plugin"], $models["main"]["model"]);
        
        
        $structureModelInstance = AppModel::getInstance('', 'Structure');
        $StructureFieldModelInstance = AppModel::getInstance("", "StructureField");
        $StructureFormatModelInstance = AppModel::getInstance("", "StructureFormat");
        $structureValidationModelInstance = AppModel::getInstance("", "StructureValidation");
        $StructureValueDomainModelInstance = AppModel::getInstance("", "StructureValueDomain");
        $StructurePermissibleValuesCustomControlModelInstance = AppModel::getInstance("", "StructurePermissibleValuesCustomControl");

        $options = $data["options"];
        $relatedData = $data["others"]['FormBuilder'];
        $modelName = $modelInstance->name;
        $alias = $data[$modelName]['detail_form_alias'];
        $structureValidationData = $data['StructureValidation'];
        
        $saveResult = $modelInstance->save($data);
        if (!$saveResult){
            AppController::getInstance()->atimFlashError(__("error in saving %s", $modelName), "javascript:history.back();");
        }

        $data['Structure'] = array(
            'alias' => $data[$modelName]['detail_form_alias'],
            'description' => $data[$modelName]['detail_form_alias']
        );
        $structureModelInstance->addWritableField(array("alias", "description"));
        $saveResult = $structureModelInstance->save($data, true);
        $structureId = "";
        if (!$saveResult){
            AppController::getInstance()->atimFlashError(__("error in saving %s", $structureModelInstance->name), "javascript:history.back();");
        }else{
            $structureId = $saveResult['Structure']['id'];
        }
        

        $commonPrefix = $options["prefix-common"];
        
        
        $tableName = $data[$modelName]['detail_tablename'];
        $index=0;
        $sfid=array();

        foreach ($data[$commonPrefix] as $key => $value) {
            $FunctionManagementData = $value['FunctionManagement'];
            $StructureFieldData = $value["StructureField"];
            $StructureFieldData["plugin"] = $relatedData["plugin"];
            $StructureFieldData["model"] = $relatedData["detail"];
            $StructureFieldData["tablename"] = $tableName;
            $StructureFieldData["language_tag"] = "";
            $StructureFieldData["default"] = "";
            $StructureFieldData["setting"] = (isset($StructureFieldData["setting"])) ? $StructureFieldData["setting"] : "";

            $svdId = $StructureFieldData["structure_value_domain"];
            if ($StructureFieldData["type"] == "select"){
                if (empty($StructureFieldData["structure_value_domain"])){
                    $spvccData = array(
                        'name' => $StructureFieldData["structure_value_domain_value"],
                        'flag_active' => 1,
                        'values_max_length' =>1000,
                        'category' => $alias,
                        'values_used_as_input_counter' => 0,
                        'values_counter' => 0
                    );

                    $spvccData = array("StructurePermissibleValuesCustomControl" => $spvccData);
                    $StructurePermissibleValuesCustomControlModelInstance->addWritableField(array("name", "flag_active", "values_max_length", "category", "values_used_as_input_counter", "values_counter"));
                    $StructurePermissibleValuesCustomControlModelInstance->id = null;
                    $saveResult = $StructurePermissibleValuesCustomControlModelInstance->save($spvccData);
                    if (!$saveResult){
                        AppController::getInstance()->atimFlashError(__("error in saving %s", $StructurePermissibleValuesCustomControlModelInstance->name), "javascript:history.back();");
                    }
                }
                $svdData = array(
                    'domain_name' => $alias."_".$StructureFieldData["structure_value_domain_value"],
                    'category' => $alias,
                    'source' => "StructurePermissibleValuesCustom::getCustomDropdown('".$StructureFieldData["structure_value_domain_value"]."')"
                );
                
                $svdData = array("StructureValueDomain" => $svdData);
                $StructureValueDomainModelInstance->addWritableField(array("domain_name", "category", "source"));
                $StructureValueDomainModelInstance->id = null;
                $saveResult = $StructureValueDomainModelInstance->save($svdData);

                if (!$saveResult){
                    AppController::getInstance()->atimFlashError(__("error in saving %s", $StructureValueDomainModelInstance->name), "javascript:history.back();");
                }else{
                    $svdId = $saveResult['StructureValueDomain']['id'];
                }
            }

            $StructureFieldModelInstance->id = null;
            $StructureFieldData["structure_value_domain"] = $svdId;
            $StructureFieldData = array("StructureField" => $StructureFieldData, "FunctionManagement" => $FunctionManagementData);
            $StructureFieldModelInstance->addWritableField(array("plugin", "model", "tablename", "language_tag", "default", "setting", "field", "structure_value_domain"));
            $StructureFieldModelInstance->id = null;
            $saveResult = $StructureFieldModelInstance->save($StructureFieldData, true);

            if (!$saveResult){
                AppController::getInstance()->atimFlashError(__("error in saving %s", $StructureFieldModelInstance->name), "javascript:history.back();");
            }

            $sfid[$index] = $saveResult["StructureField"]["id"];
            $StructureFormatData = $value["StructureFormat"];
            $StructureFormatData["structure_id"] = $structureId;
            $StructureFormatData["structure_field_id"] = $sfid[$index];
            $StructureFormatData["language_label"] = "";
            $StructureFormatData["language_tag"] = "";
            $StructureFormatData["language_help"] = "";
            $StructureFormatData = array("StructureFormat" => $StructureFormatData, "FunctionManagement" => $FunctionManagementData);
            $StructureFormatModelInstance->addWritableField(array("structure_id", "structure_field_id", "language_label", "language_tag", "language_help", "setting"));
            $StructureFormatModelInstance->id = null;
            $saveResult = $StructureFormatModelInstance->save($StructureFormatData);

            if (!$saveResult){
                AppController::getInstance()->atimFlashError(__("error in saving %s", $StructureFormatModelInstance->name), "javascript:history.back();");
            }
            $index++;
        }

        foreach ($structureValidationData as $key => $value) {
            $value["structure_field_id"] = $sfid[$value["structure_field_id"]];
            $value = array("StructureValidation" => $value);
            $structureValidationModelInstance->addWritableField(array("structure_field_id", "rule", "on_action", "language_message"));
            $structureValidationModelInstance->id = null;
            $structureValidationModelInstance->save($value);
        }
        
        if (true){
            $this->createTable($data);
        }else{
            $this->addFieldsToTable($data);
        }
    }
    
    private function addFieldsToTable($data)
    {
        
    }

    private function createTable($data)
    {

        $model = $data["models"]["main"]["model"];
        $detailTableName =  $data[$model]["detail_tablename"];
        $options = $data["options"];
        $relatedData = $data["others"]['FormBuilder'];
        $fieldsList = $data[$options["prefix-common"]];
        
        $refrenceTable = $relatedData["master_table"];
        $fk = Inflector::underscore($relatedData["master"]) ."_id";
        
        $query = "CREATE TABLE IF NOT EXISTS `{$detailTableName}` (\n\t"
            . "{$fk} int NOT NULL PRIMARY KEY, \n\t";
        
        $index = 0;
        $currentFieldQuery = array();
        foreach ($fieldsList as $field){
            $fieldName = $field['StructureField']['field'];
            $type = $field['StructureField']['type'];
            if ($type == 'checkbox'){
                $currentFieldQuery[] = $fieldName . " tinyint";
            }elseif ($type=='date'){
                $currentFieldQuery[] = $fieldName . " date ," . $fieldName . "_accuracy char(1) NOT NULL DEFAULT ''";
            }elseif ($type=='datetime'){
                $currentFieldQuery[] = $fieldName . " datetime";
            }elseif ($type=='float'){
                $currentFieldQuery[] = $fieldName . " decimal(10, 5)";
            }elseif ($type=='input'){
                $currentFieldQuery[] = $fieldName . " varchar(1000) COLLATE 'latin1_swedish_ci' ";
            }elseif ($type=='integer'){
                $currentFieldQuery[] = $fieldName . " int";
            }elseif ($type=='select'){
                $currentFieldQuery[] = $fieldName . " varchar(1000) COLLATE 'latin1_swedish_ci' ";
            }elseif ($type=='textarea'){
                $currentFieldQuery[] = $fieldName . " text";
            }elseif ($type=='time'){
                $currentFieldQuery[] = $fieldName . " time";
            }elseif ($type=='yes_no'){
                $currentFieldQuery[] = $fieldName . " char(1)";
            }elseif ($type=='autocomplete'){
                $currentFieldQuery[] = $fieldName . " varchar(1000) COLLATE 'latin1_swedish_ci' ";
            }
            $index ++;
        }
        
        $query .= implode(" ,\n\t", $currentFieldQuery) . " ,\n\t";
        
        $query .= "FOREIGN KEY (`{$fk}`) REFERENCES `{$refrenceTable}` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT \n";
        
        $query .= ") ENGINE='InnoDB' COLLATE 'latin1_swedish_ci';\n\n";
        $this->query($query);
    }
    
}