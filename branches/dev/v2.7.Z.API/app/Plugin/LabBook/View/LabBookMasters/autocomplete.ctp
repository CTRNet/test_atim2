<?php
echo '[';
if (! empty($result)) {
    echo '"', implode('", "', $result), '"';
}
echo ']';