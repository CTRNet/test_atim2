<?php
if (count($log)) {
    echo '<ul>';
    foreach ($log as $action) {
        echo '<li>' . $action . '</li>';
    }
    echo '</ul>';
} else {
    echo '<p>Nothing changed.</p>';
}