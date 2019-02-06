<?php

/**
 * Class DatamartAppController
 */
class DatamartAppController extends AppController
{

    /**
     *
     * @param $options
     * @param $label
     * @param $webroot
     */
    public static function printList($options, $label, $webroot)
    {
        foreach ($options as $option) {
            $currLabel = $label . " &gt; " . $option['label'];
            $currLabelForClass = str_replace("'", "&#39;", $currLabel);
            $action = isset($option['value']) ? ', "action" : "' . $webroot . $option['value'] . '" ' : "";
            $class = isset($option['class']) ? $option['class'] : "";
            echo ("<li class='" . "'><a href='#' class='{ \"value\" : \"" . $option['value'] . "\", \"label\" : \"" . $currLabelForClass . "\" " . $action . " } " . $class . "'>" . $option['default'] . "</a>");
            if (isset($option['children'])) {
                if (count($option['children']) > 15) {
                    $tmpChildren = array();
                    if ($option['children'][0]['label'] == __("filter")) {
                        // remove filter and no filter from the pages
                        $tmpChildren = array_splice($option['children'], 2);
                    } else {
                        $tmpChildren = $option['children'];
                        $option['children'] = array();
                    }
                    $childrenArr = array_chunk($tmpChildren, 15);
                    $pageStr = __("page %d");
                    $pageNum = 1;
                    foreach ($childrenArr as $child) {
                        $option['children'][] = array(
                            "default" => sprintf($pageStr, $pageNum),
                            "value" => "",
                            "children" => $child
                        );
                        $pageNum ++;
                    }
                }
                echo ("<ul>");
                self::printList($option['children'], $currLabel, $webroot);
                echo ("</ul>");
            }
            echo ("</li>\n");
        }
    }
}